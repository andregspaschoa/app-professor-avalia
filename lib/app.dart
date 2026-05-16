import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

/// Widget raiz do app.
///
/// Mantido em arquivo separado de main.dart para:
/// - deixar main.dart como puro entry point (bootstrap);
/// - facilitar widget tests que precisam de ProfessorAvaliaApp;
/// - centralizar a configuração do MaterialApp em um único lugar.
class ProfessorAvaliaApp extends StatelessWidget {
  const ProfessorAvaliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professor Avalia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // TODO(nav): substituir por GoRouter e remover routes/home na feature 1.2
      home: const SplashScreen(),
      routes: {
        '/login': (_) => const _LoginPlaceholder(),
      },
    );
  }
}

/// Placeholder temporário para a rota /login.
/// Será substituído por LoginScreen na Fase 2 (feat: auth).
class _LoginPlaceholder extends StatelessWidget {
  const _LoginPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: Text(
          'Login — em breve',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Reexporta ProviderScope para uso em testes de widget que
// precisam instanciar ProfessorAvaliaApp com Riverpod.
typedef AppWithProviderScope = ProviderScope;
