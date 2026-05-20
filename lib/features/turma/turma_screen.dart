import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/error/failures.dart';
import '../../core/router/app_routes.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/error_state_widget.dart';
import '../../shared/widgets/skeleton_loader.dart';
import '../wizard/wizard_viewmodel.dart';
import 'model/turma_model.dart';
import 'turma_viewmodel.dart';

extension _StringCapitalize on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

class TurmaScreen extends ConsumerWidget {
  const TurmaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(turmaViewModelProvider);

    return state.when(
      loading: () => const SkeletonListView(),
      error: (error, _) => ErrorStateWidget(
        message:
            error is Failure ? error.message : 'Ocorreu um erro. Tente novamente.',
        onRetry: () => ref.invalidate(turmaViewModelProvider),
      ),
      data: (turmas) {
        if (turmas.isEmpty) {
          return const EmptyStateWidget(
            message: 'Nenhuma turma encontrada para esta escola.',
            icon: Icons.class_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: turmas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _TurmaCard(turma: turmas[index])
              .animate(delay: (50 * index.clamp(0, 7)).ms)
              .fadeIn(duration: 280.ms)
              .slideX(begin: 0.12, curve: Curves.easeOut),
        );
      },
    );
  }
}

class _AnoChip extends StatelessWidget {
  const _AnoChip({required this.anoLetivo});
  final int anoLetivo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Chip(
      label: Text(anoLetivo.toString()),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        color: isDark ? const Color(0xFFBDBDBD) : Colors.grey.shade700,
      ),
      backgroundColor: isDark ? const Color(0xFF3D3D3D) : Colors.grey.shade200,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _TurmaCard extends ConsumerWidget {
  const _TurmaCard({required this.turma});

  final TurmaModel turma;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(turma.nome, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${turma.turno.capitalize()} · ${turma.totalAlunos} alunos',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: _AnoChip(anoLetivo: turma.anoLetivo),
        onTap: () {
          ref.read(wizardViewModelProvider.notifier).setTurma(turma.id, turma.nome);
          context.push(AppRoutes.wizardAvaliacao);
        },
      ),
    );
  }
}
