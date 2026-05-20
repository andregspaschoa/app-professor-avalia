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
import 'escola_viewmodel.dart';
import 'model/escola_model.dart';

class EscolaScreen extends ConsumerWidget {
  const EscolaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(escolaViewModelProvider);

    return state.when(
      loading: () => const SkeletonListView(),
      error: (error, _) => ErrorStateWidget(
        message:
            error is Failure ? error.message : 'Ocorreu um erro. Tente novamente.',
        onRetry: () => ref.invalidate(escolaViewModelProvider),
      ),
      data: (escolas) {
        if (escolas.isEmpty) {
          return const EmptyStateWidget(
            message: 'Nenhuma escola encontrada para este professor.',
            icon: Icons.school_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: escolas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _EscolaCard(escola: escolas[index])
              .animate(delay: (50 * index.clamp(0, 7)).ms)
              .fadeIn(duration: 280.ms)
              .slideX(begin: 0.12, curve: Curves.easeOut),
        );
      },
    );
  }
}

class _TipoChip extends StatelessWidget {
  const _TipoChip({required this.tipo});
  final String tipo;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Chip(
      label: Text(tipo),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        color: isDark ? const Color(0xFFBDBDBD) : Colors.grey.shade700,
      ),
      backgroundColor: isDark ? const Color(0xFF3D3D3D) : Colors.grey.shade200,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _EscolaCard extends ConsumerWidget {
  const _EscolaCard({required this.escola});

  final EscolaModel escola;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(escola.nome, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${escola.municipio} — ${escola.uf}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: _TipoChip(tipo: escola.tipo),
        onTap: () {
          ref.read(wizardViewModelProvider.notifier).setEscola(escola.id, escola.nome);
          context.push(AppRoutes.wizardTurma);
        },
      ),
    );
  }
}
