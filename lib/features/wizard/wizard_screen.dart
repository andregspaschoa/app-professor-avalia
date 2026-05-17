import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';

/// Shell do wizard — envolve todos os sub-steps com o Scaffold compartilhado.
///
/// Exibe:
/// - AppBar com título do step atual, botão Voltar (steps 2–6) e botão de logout.
/// - [LinearProgressIndicator] indicando progresso (step 1–6).
/// - [child]: conteúdo da rota ativa (EscolaScreen, TurmaScreen, etc.).
///
/// O step é lido de [wizardViewModelProvider] para garantir atualização correta
/// independentemente de push() ou go() ser usado na navegação.
class WizardScreen extends ConsumerWidget {
  const WizardScreen({super.key, required this.child});

  /// Corpo do step atual — injetado pelo [ShellRoute] do go_router.
  final Widget child;

  static const _stepTitles = [
    'Selecionar Escola',      // step 1
    'Selecionar Turma',       // step 2
    'Selecionar Avaliação',   // step 3
    'Confirmar Avaliação',    // step 4
    'Gabarito do Professor',  // step 5
    'Inserir Respostas',      // step 6
  ];

  static const _totalSteps = 6;

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
    final step = ref.watch(wizardViewModelProvider).step;
    final safeStep = step.clamp(1, _totalSteps);
    final title = _stepTitles[safeStep - 1];
    final progress = safeStep / _totalSteps;

    return Scaffold(
      appBar: AppBar(
        leading: safeStep > 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: 'Voltar',
                onPressed: () {
                  ref
                      .read(wizardViewModelProvider.notifier)
                      .advanceToStep(safeStep - 1);
                  context.pop();
                },
              )
            : null,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'Passo $safeStep de $_totalSteps',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(150),
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sair',
            onPressed: () => _confirmLogout(context, ref),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      body: child,
    );
  }
}
