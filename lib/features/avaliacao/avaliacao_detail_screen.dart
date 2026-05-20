import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../avaliacao/avaliacao_viewmodel.dart';
import '../escola/escola_viewmodel.dart';
import '../turma/turma_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';

class AvaliacaoDetailScreen extends ConsumerWidget {
  const AvaliacaoDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(wizardViewModelProvider);

    final escolaId = wizardState.escolaId;
    final turmaId = wizardState.turmaId;
    final avaliacaoId = wizardState.avaliacaoId;

    final escolas = ref.watch(escolaViewModelProvider).valueOrNull;
    final turmas = ref.watch(turmaViewModelProvider).valueOrNull;
    final avaliacoes = ref.watch(avaliacaoViewModelProvider).valueOrNull;

    final escolaNome = escolas
            ?.where((e) => e.id == escolaId)
            .firstOrNull
            ?.nome ??
        'Carregando...';

    final turmaNome = turmas
            ?.where((t) => t.id == turmaId)
            .firstOrNull
            ?.nome ??
        'Carregando...';

    final avaliacao = avaliacoes
        ?.where((a) => a.id == avaliacaoId)
        .firstOrNull;

    final avaliacaoTitulo = avaliacao?.titulo ?? 'Carregando...';
    final gabaritoText =
        avaliacao != null ? '${avaliacao.totalQuestoes} questões' : 'Carregando...';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(
                    icon: Icons.school_rounded,
                    label: 'Escola',
                    value: escolaNome,
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    icon: Icons.group_rounded,
                    label: 'Turma',
                    value: turmaNome,
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    icon: Icons.assignment_rounded,
                    label: 'Avaliação',
                    value: avaliacaoTitulo,
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    icon: Icons.check_circle_rounded,
                    label: 'Gabarito',
                    value: gabaritoText,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.quiz_rounded),
            label: const Text('Inserir Respostas'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () {
              ref.read(wizardViewModelProvider.notifier).advanceToStep(5);
              context.push(AppRoutes.wizardGabaritoProf);
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.bar_chart_rounded),
            label: const Text('Ver Dashboard'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () {
              ref.read(wizardViewModelProvider.notifier).reset();
              context.go(AppRoutes.home);
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(140),
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
