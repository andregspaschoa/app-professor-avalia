import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/error/failures.dart';
import '../../core/router/app_router.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/error_state_widget.dart';
import '../wizard/wizard_viewmodel.dart';
import 'avaliacao_viewmodel.dart';
import 'model/avaliacao_model.dart';

class AvaliacaoScreen extends ConsumerWidget {
  const AvaliacaoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(avaliacaoViewModelProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
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
              _AvaliacaoCard(avaliacao: avaliacoes[index]),
        );
      },
    );
  }
}

class _AvaliacaoCard extends ConsumerWidget {
  const _AvaliacaoCard({required this.avaliacao});

  final AvaliacaoModel avaliacao;

  Color _chipBackgroundColor(String status) => switch (status) {
        'aplicada' => Colors.blue.shade100,
        'corrigida' => Colors.green.shade100,
        _ => Colors.grey.shade200,
      };

  Color _chipLabelColor(String status) => switch (status) {
        'aplicada' => Colors.blue.shade900,
        'corrigida' => Colors.green.shade900,
        _ => Colors.grey.shade700,
      };

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
              color: _chipLabelColor(status),
            ),
          ),
          backgroundColor: _chipBackgroundColor(status),
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
