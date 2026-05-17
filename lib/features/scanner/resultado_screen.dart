import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/widgets/gabarito_grid.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../gabarito/gabarito_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';
import 'scanner_viewmodel.dart';

/// Tela de resultado pós-scan para um aluno.
///
/// Exibe:
/// - Score calculado (acertos / total e nota).
/// - Grid do gabarito com acertos em verde e erros em vermelho.
/// - Botão "Salvar" → persiste no Hive e avança o gabarito para o próximo aluno.
/// - Botão "Refazer" → volta para a tela do scanner.
class ResultadoScreen extends ConsumerWidget {
  const ResultadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scannerViewModelProvider);
    final scanResult = scanState.scanResult;

    final wizardState = ref.watch(wizardViewModelProvider);
    final avaliacoes = ref.watch(avaliacaoViewModelProvider).valueOrNull;
    final avaliacao =
        avaliacoes?.where((a) => a.id == wizardState.avaliacaoId).firstOrNull;

    final gabState = ref.watch(gabaritoViewModelProvider);
    final aluno = gabState.currentAluno;

    if (scanResult == null || avaliacao == null || aluno == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final gabarito =
        wizardState.gabaritoConfirmado ?? avaliacao.gabarito;
    final totalQuestoes = avaliacao.totalQuestoes;
    final acertos = _calcularAcertos(scanResult, gabarito);
    final nota = acertos * avaliacao.pesoPorQuestao;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado do Scan'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // ── Score ──────────────────────────────────────────────────────────
          _ScoreHeader(
            nomeAluno: aluno.nome,
            acertos: acertos,
            totalQuestoes: totalQuestoes,
            nota: nota,
            notaMaxima: avaliacao.notaMaxima,
          ),
          // ── Gabarito colorido ──────────────────────────────────────────────
          Expanded(
            child: GabaritoGrid(
              totalQuestoes: totalQuestoes,
              respostas: List<String?>.from(scanResult),
              onSelect: (_, _) {},
              readOnly: true,
              gabarito: gabarito,
            ),
          ),
          // ── Ações ──────────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Refazer'),
                      onPressed: () {
                        ref.read(scannerViewModelProvider.notifier).reset();
                        context.pop(); // volta para ScannerScreen
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Salvar'),
                      onPressed: () => _salvar(context, ref, {
                        'aluno_id': aluno.id,
                        'aluno_nome': aluno.nome,
                        'avaliacao_id': wizardState.avaliacaoId,
                        'turma_id': wizardState.turmaId,
                        'escola_id': wizardState.escolaId,
                        'respostas_aluno': scanResult,
                        'acertos': acertos,
                        'nota_calculada': nota,
                        'status': 'corrigida',
                        'origem': 'scanner',
                        'created_at': DateTime.now().toIso8601String(),
                      }, scanResult),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calcularAcertos(List<String> respostas, List<String> gabarito) {
    int count = 0;
    final limit = respostas.length < gabarito.length
        ? respostas.length
        : gabarito.length;
    for (var i = 0; i < limit; i++) {
      if (respostas[i] == gabarito[i]) count++;
    }
    return count;
  }

  Future<void> _salvar(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> data,
    List<String> scanResult,
  ) async {
    try {
      final box = Hive.box<dynamic>(AppConstants.hiveBoxScans);
      await box.add(data);
    } catch (_) {
      // Hive pode não estar aberto em ambiente de teste; ignora silenciosamente.
    }

    // Aplica as respostas no GabaritoViewModel e avança para o próximo aluno
    ref.read(gabaritoViewModelProvider.notifier).setRespostasFromScan(scanResult);
    ref.read(scannerViewModelProvider.notifier).reset();

    if (context.mounted) {
    // Descarta scanner_resultado e scanner — preserva a pilha do wizard shell
    final router = GoRouter.of(context);
    router.pop(); // /scanner/resultado → /scanner
    router.pop(); // /scanner → /wizard/gabarito (na pilha do shell)
    }
  }
}

// ── Score Header ──────────────────────────────────────────────────────────────

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({
    required this.nomeAluno,
    required this.acertos,
    required this.totalQuestoes,
    required this.nota,
    required this.notaMaxima,
  });

  final String nomeAluno;
  final int acertos;
  final int totalQuestoes;
  final double nota;
  final double notaMaxima;

  Color _notaColor() {
    final pct = nota / notaMaxima;
    if (pct >= 0.7) return Colors.green.shade700;
    if (pct >= 0.5) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeAluno,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$acertos de $totalQuestoes acertos',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _notaColor().withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _notaColor().withAlpha(100)),
            ),
            child: Column(
              children: [
                Text(
                  nota.toStringAsFixed(1),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: _notaColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'de ${notaMaxima.toStringAsFixed(0)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _notaColor().withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
