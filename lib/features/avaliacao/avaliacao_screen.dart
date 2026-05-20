import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/error/failures.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/error_state_widget.dart';
import '../../shared/widgets/skeleton_loader.dart';
import '../wizard/wizard_viewmodel.dart';
import 'avaliacao_viewmodel.dart';
import 'model/avaliacao_model.dart';

class AvaliacaoScreen extends ConsumerWidget {
  const AvaliacaoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(avaliacaoViewModelProvider);

    return state.when(
      loading: () => const SkeletonListView(),
      error: (error, _) => ErrorStateWidget(
        message: error is Failure
            ? error.message
            : 'Ocorreu um erro. Tente novamente.',
        onRetry: () => ref.invalidate(avaliacaoViewModelProvider),
      ),
      data: (avaliacoes) {
        if (avaliacoes.isEmpty) {
          return const EmptyStateWidget(
            message: 'Nenhuma avaliação encontrada para esta turma.',
            icon: Icons.assignment_outlined,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: avaliacoes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              _AvaliacaoCard(avaliacao: avaliacoes[index])
                  .animate(delay: (50 * index.clamp(0, 7)).ms)
                  .fadeIn(duration: 280.ms)
                  .slideX(begin: 0.12, curve: Curves.easeOut),
        );
      },
    );
  }
}

class _AvaliacaoCard extends ConsumerWidget {
  const _AvaliacaoCard({required this.avaliacao});

  final AvaliacaoModel avaliacao;

  Color _chipBackgroundColor(BuildContext context, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (status) {
      'corrigida' =>
        isDark ? AppColors.chipSuccessBgDark : AppColors.chipSuccessBgLight,
      'aplicada' =>
        isDark ? AppColors.chipInfoBgDark : AppColors.chipInfoBgLight,
      _ => isDark ? const Color(0xFF3D3D3D) : Colors.grey.shade200,
    };
  }

  Color _chipLabelColor(BuildContext context, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (status) {
      'corrigida' =>
        isDark ? AppColors.chipSuccessTextDark : AppColors.chipSuccessTextLight,
      'aplicada' =>
        isDark ? AppColors.chipInfoTextDark : AppColors.chipInfoTextLight,
      _ => isDark ? const Color(0xFFBDBDBD) : Colors.grey.shade700,
    };
  }

  String _statusLabel(String status) => switch (status) {
        'rascunho' => 'Rascunho',
        'aplicada' => 'Aplicada',
        'corrigida' => 'Corrigida',
        _ => status,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final status = avaliacao.status;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(avaliacao.titulo, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${avaliacao.disciplina} · ${avaliacao.bimestre}º bimestre',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ),
        trailing: Chip(
          label: Text(
            _statusLabel(status),
            style: theme.textTheme.labelSmall?.copyWith(
              color: _chipLabelColor(context, status),
            ),
          ),
          backgroundColor: _chipBackgroundColor(context, status),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        onTap: () {
          ref
              .read(wizardViewModelProvider.notifier)
              .setAvaliacao(avaliacao.id, avaliacao.titulo);
          context.push(AppRoutes.wizardAvaliacaoDetalhe);
        },
      ),
    );
  }
}
