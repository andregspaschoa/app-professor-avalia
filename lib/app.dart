import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Widget raiz do app.
///
/// Mantido em arquivo separado de main.dart para:
/// - deixar main.dart como puro entry point (bootstrap);
/// - facilitar widget tests que precisam de ProfessorAvaliaApp;
/// - centralizar a configuração do MaterialApp em um único lugar.
///
/// Usa [ConsumerWidget] para observar o [appRouterProvider] — necessário
/// para que o redirect do go_router acesse providers de auth na Fase 2.
class ProfessorAvaliaApp extends ConsumerWidget {
  const ProfessorAvaliaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Professor Avalia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

