import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../shared/widgets/gabarito_grid.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';
import 'gabarito_viewmodel.dart';

class GabaritoScreen extends ConsumerWidget {
  const GabaritoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gabState = ref.watch(gabaritoViewModelProvider);

    if (gabState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gabState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(gabState.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(gabaritoViewModelProvider.notifier).reset(),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final aluno = gabState.currentAluno;
    if (aluno == null) {
      return const Center(child: Text('Nenhum aluno encontrado.'));
    }

    final avaliacaoId = ref.watch(wizardViewModelProvider).avaliacaoId;
    final avaliacoes = ref.watch(avaliacaoViewModelProvider).valueOrNull;
    final avaliacao =
        avaliacoes?.where((a) => a.id == avaliacaoId).firstOrNull;
    final totalQuestoes = avaliacao?.totalQuestoes ?? 0;

    final respostas = gabState.currentRespostas;
    final total = gabState.alunos.length;
    final atual = gabState.currentIndex + 1;

    return Column(
      children: [
        // ── Header: progresso do aluno ─────────────────────────────────────
        _AlunoHeader(
          nomeAluno: aluno.nome,
          atual: atual,
          total: total,
        ),
        // ── Grid de respostas ──────────────────────────────────────────────
        Expanded(
          child: totalQuestoes == 0
              ? const Center(child: Text('Avaliação sem questões.'))
              : GabaritoGrid(
                  totalQuestoes: totalQuestoes,
                  respostas: respostas,
                  onSelect: (questao, alt) => ref
                      .read(gabaritoViewModelProvider.notifier)
                      .setResposta(questao, alt),
                ),
        ),
        // ── Barra de ações ─────────────────────────────────────────────────
        _ActionBar(
          isFirst: gabState.isFirstAluno,
          isLast: gabState.isUltimoAluno,
          onAnterior: () =>
              ref.read(gabaritoViewModelProvider.notifier).alunoAnterior(),
          onProximo: () {
            if (gabState.isUltimoAluno) {
              context.push(AppRoutes.wizardResultado);
            } else {
              ref.read(gabaritoViewModelProvider.notifier).proximoAluno();
            }
          },
          onEscanear: () => context.push(AppRoutes.scanner),
        ),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _AlunoHeader extends StatelessWidget {
  const _AlunoHeader({
    required this.nomeAluno,
    required this.atual,
    required this.total,
  });

  final String nomeAluno;
  final int atual;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              nomeAluno.isNotEmpty ? nomeAluno[0].toUpperCase() : '?',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                Text(
                  'Aluno $atual de $total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(140),
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

// ── Action Bar ────────────────────────────────────────────────────────────────

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isFirst,
    required this.isLast,
    required this.onAnterior,
    required this.onProximo,
    required this.onEscanear,
  });

  final bool isFirst;
  final bool isLast;
  final VoidCallback onAnterior;
  final VoidCallback onProximo;
  final VoidCallback onEscanear;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Linha 1 — Escanear (largura completa)
            OutlinedButton.icon(
              icon: const Icon(Icons.document_scanner_rounded),
              label: const Text('Escanear cartão resposta'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: onEscanear,
            ),
            const SizedBox(height: 8),
            // Linha 2 — Anterior | Próximo/Finalizar
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
                    label: const Text('Anterior'),
                    onPressed: isFirst ? null : onAnterior,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    icon: Icon(
                      isLast
                          ? Icons.check_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                    label: Text(isLast ? 'Finalizar' : 'Próximo'),
                    onPressed: onProximo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
