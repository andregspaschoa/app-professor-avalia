import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/score_colors.dart';
import '../../shared/widgets/gabarito_grid.dart';

/// Tela de detalhe de um scan salvo — acesso retrospectivo pelo professor.
///
/// Cenário de negócio: o aluno questiona que sua nota está errada.
/// O professor acessa este detalhe, visualiza o cartão resposta fotografado
/// e o gabarito colorido (acertos em verde, erros em vermelho) para
/// confirmar a correção ou identificar um equívoco.
///
/// Recebe o `Map<String, dynamic>` salvo no Hive via [GoRouterState.extra].
class ScanDetailScreen extends StatelessWidget {
  const ScanDetailScreen({super.key, required this.scanData});

  final Map<String, dynamic> scanData;

  void _showContestarDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contestar nota'),
        content: const Text(
          'Nesta versão, a correção manual está disponível diretamente '
          'no Gabarito durante o fluxo de avaliação.\n\n'
          'Em uma versão futura será possível editar respostas '
          'individuais diretamente nesta tela.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = scanData['aluno_nome']?.toString() ?? 'Aluno';
    final nota = (scanData['nota_calculada'] as num?)?.toDouble() ?? 0.0;
    final notaMax = (scanData['nota_maxima'] as num?)?.toDouble() ?? 10.0;
    final acertos = (scanData['acertos'] as num?)?.toInt() ?? 0;
    final total = (scanData['total_questoes'] as num?)?.toInt() ?? 0;
    final imagePath = scanData['image_path']?.toString();

    final respostas = (scanData['respostas_aluno'] as List?)
            ?.map((e) => e?.toString())
            .toList() ??
        [];
    final gabarito = (scanData['gabarito'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final createdAt = scanData['created_at']?.toString() ?? '';
    final date = DateTime.tryParse(createdAt);
    final dateLabel = date != null
        ? '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}  '
            '${date.hour.toString().padLeft(2, '0')}:'
            '${date.minute.toString().padLeft(2, '0')}'
        : '';

    final notaColor = ScoreColors.of(context, nota, notaMax);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do Scan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.edit_note_rounded, size: 18),
            label: const Text('Contestar'),
            onPressed: () => _showContestarDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Header: aluno + nota ──────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: notaColor.withAlpha(30),
                    child: Text(
                      nota.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: notaColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$acertos de $total acertos · nota $nota/$notaMax',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (dateLabel.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            dateLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(120),
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Imagem do cartão ──────────────────────────────────────────────
          Text(
            'Cartão resposta',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _ScanThumbnail(
            imagePath: imagePath,
            onTap: () => _showImageOverlay(context, imagePath),
          ),
          const SizedBox(height: 24),

          // ── Gabarito colorido ─────────────────────────────────────────────
          Text(
            'Correção detalhada',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          if (total > 0 && gabarito.isNotEmpty)
            GabaritoGrid(
              totalQuestoes: total,
              respostas: respostas,
              onSelect: (_, _) {},
              readOnly: true,
              gabarito: gabarito,
              shrinkWrap: true,
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Dados de gabarito não disponíveis.'),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showImageOverlay(BuildContext context, String? path) {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (!file.existsSync()) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.of(ctx).pop(),
        child: Dialog.fullscreen(
          backgroundColor: Colors.black87,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.file(file, fit: BoxFit.contain),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanThumbnail extends StatelessWidget {
  const _ScanThumbnail({required this.imagePath, required this.onTap});

  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _ImagePlaceholder(
        message: 'Imagem não disponível\n(correção realizada sem scan)',
      );
    }
    if (!File(imagePath!).existsSync()) {
      return _ImagePlaceholder(
        message: 'Imagem não encontrada\n(arquivo pode ter sido removido)',
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, e) => _ImagePlaceholder(
                  message: 'Não foi possível carregar a imagem.',
                ),
              ),
              // overlay escuro + ícone de zoom para indicar que é clicável
              Container(
                color: Colors.black38,
                child: const Icon(
                  Icons.zoom_in_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
                ),
          ),
        ],
      ),
    );
  }
}
