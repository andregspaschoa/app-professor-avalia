import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';

/// Placeholder da tela de login.
/// Será substituído pela implementação real na Fase 2 (feat: auth).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Login', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Fase 2 — em breve',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(120),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: FilledButton.icon(
                onPressed: () => context.goNamed(AppRoutes.wizardName),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Wizard (demo)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
