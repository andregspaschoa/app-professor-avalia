import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../auth/auth_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';

/// Tela inicial pós-login — futura Dashboard do professor.
///
/// Por ora é um placeholder com stubs visuais.
/// A navegação principal parte daqui via [FilledButton] "Corrigir avaliação".
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final professor = ref.watch(authViewModelProvider).valueOrNull;
    final firstName = professor?.nome.split(' ').first ?? 'Professor';

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $firstName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair da conta',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          _StubCard(
            icon: Icons.bar_chart_rounded,
            title: 'Dashboard',
            description: 'Resumo de avaliações, desempenho por turma e '
                'estatísticas gerais estarão disponíveis em breve.',
          ),
          const SizedBox(height: 12),
          _StubCard(
            icon: Icons.history_rounded,
            title: 'Avaliações recentes',
            description: 'O histórico das últimas correções realizadas '
                'estará disponível em breve.',
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            icon: const Icon(Icons.quiz_rounded),
            label: const Text('Corrigir avaliação'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () {
              ref.read(wizardViewModelProvider.notifier).reset();
              context.push(AppRoutes.wizardEscola);
            },
          ),
        ],
      ),
    );
  }
}

// ── Widget interno ────────────────────────────────────────────────────────────

class _StubCard extends StatelessWidget {
  const _StubCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: theme.colorScheme.onSurface.withAlpha(80),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: const Text('Em breve'),
                    labelStyle: theme.textTheme.labelSmall,
                    padding: EdgeInsets.zero,
                    side: BorderSide.none,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
