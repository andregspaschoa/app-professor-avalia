import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/wizard/wizard_screen.dart';

/// Provedor do GoRouter.
///
/// Usando [Provider] manual (sem @riverpod codegen) porque o router é
/// infraestrutura de configuração — não gerencia estado reativo.
/// [Provider] (sem autoDispose) é keepAlive por padrão no Riverpod 2.
///
/// TODO(auth): injetar authStateProvider no [redirect] após Fase 2.
/// Lógica futura: sessão válida → go('/wizard'), sem sessão → go('/login').
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.wizard,
        name: AppRoutes.wizardName,
        builder: (context, state) => const WizardScreen(),
      ),
    ],
  );
});

/// Constantes de todas as rotas do app.
///
/// Uso com path:  context.go(AppRoutes.login)
/// Uso com name:  context.goNamed(AppRoutes.loginName)
abstract final class AppRoutes {
  static const String splash = '/';
  static const String splashName = 'splash';

  static const String login = '/login';
  static const String loginName = 'login';

  static const String wizard = '/wizard';
  static const String wizardName = 'wizard';
}

