import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';
import 'scanner_viewmodel.dart';

/// Tela de scanner com preview da câmera ao vivo e viewfinder animado.
///
/// Fluxo:
/// 1. Usuário vê preview da câmera com viewfinder pulsante.
/// 2. Toca "Capturar" → simula processamento por [AppConstants.fakeScannerDelay].
/// 3. Ao concluir, navega automaticamente para [AppRoutes.scannerResultado].
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  CameraController? _cameraController;
  bool _cameraReady = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _cameraController = controller;
        _cameraReady = true;
      });
    } catch (_) {
      // sem câmera (emulador) — fundo preto como fallback
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onCapturar() async {
    final avaliacaoId = ref.read(wizardViewModelProvider).avaliacaoId;
    final avaliacoes = ref.read(avaliacaoViewModelProvider).valueOrNull;
    final avaliacao =
        avaliacoes?.where((a) => a.id == avaliacaoId).firstOrNull;
    final totalQuestoes = avaliacao?.totalQuestoes ?? 10;

    // Captura a foto real se a câmera estiver disponível.
    // O path é persistido no Hive para consulta posterior (ex: contestação de nota).
    String? imagePath;
    if (_cameraReady && _cameraController != null) {
      try {
        final xfile = await _cameraController!.takePicture();
        imagePath = xfile.path;
      } catch (_) {
        // Falha silenciosa — scan continua sem imagem (emulador sem câmera real).
      }
    }

    await ref
        .read(scannerViewModelProvider.notifier)
        .scan(totalQuestoes, imagePath: imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scannerViewModelProvider);

    // Navega automaticamente ao concluir o scan
    ref.listen<ScannerState>(scannerViewModelProvider, (prev, next) {
      if (next.status == ScannerStatus.done) {
        final isProfessorStep = ref.read(wizardViewModelProvider).step == 5;
        if (isProfessorStep) {
          if (context.mounted) context.pop(); // volta direto ao professor
        } else {
          context.push(AppRoutes.scannerResultado);
        }
      }
      if (next.status == ScannerStatus.error && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Erro no scan.')),
        );
        ref.read(scannerViewModelProvider.notifier).reset();
      }
    });

    final isProcessing = scanState.status == ScannerStatus.processing ||
        scanState.status == ScannerStatus.scanning;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Escanear Cartão',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // ── Fundo: camera preview ou preto (fallback para emulador) ───────────
          if (_cameraReady && _cameraController != null)
            Positioned.fill(child: CameraPreview(_cameraController!))
          else
            Container(color: Colors.black),

          // ── Viewfinder animado ─────────────────────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, _) {
                return Opacity(
                  opacity: _pulseAnimation.value,
                  child: Container(
                    width: 280,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.greenAccent.shade400,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner_rounded,
                          size: 48,
                          color: Colors.greenAccent.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aponte para o cartão resposta',
                          style: TextStyle(
                            color: Colors.greenAccent.shade400,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Overlay de processamento ───────────────────────────────────────
          if (isProcessing)
            Container(
              color: Colors.black.withAlpha(180),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.greenAccent),
                    SizedBox(height: 20),
                    Text(
                      'Processando respostas...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      // ── FAB Capturar ───────────────────────────────────────────────────────
      floatingActionButton: isProcessing
          ? null
          : FloatingActionButton.extended(
              onPressed: _onCapturar,
              backgroundColor: Colors.greenAccent.shade400,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Capturar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
