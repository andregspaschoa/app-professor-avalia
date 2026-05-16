import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_viewmodel.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/model/auth_model.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/wizard/wizard_screen.dart';

/// Provedor do GoRouter.
///
/// Usando [Provider] manual (sem @riverpod codegen) porque o router é
/// infraestrutura de configuração — não gerencia estado reativo diretamente.
/// O estado reativo é delegado ao [_RouterNotifier].
final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: notifier,
    redirect: notifier.redirect,
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

/// Conecta o estado de autenticação ao [GoRouter].
///
/// Chama [notifyListeners] sempre que [authViewModelProvider] muda,
/// forçando o go_router a re-avaliar os redirects automaticamente.
///
/// Regras de redirect:
///   - Splash: nenhum redirect — gerencia sua própria navegação.
///   - Sessão carregando: nenhum redirect (aguarda resolução).
///   - Autenticado em /login: vai para /wizard.
///   - Não autenticado em /wizard: vai para /login.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<ProfessorModel?>>(
      authViewModelProvider,
      (_, __) => notifyListeners(),
    );
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authViewModelProvider);
    final loc = state.matchedLocation;

    // Splash gerencia sua própria navegação (animação → /login).
    if (loc == AppRoutes.splash) return null;

    // Aguarda a verificação de sessão ser concluída antes de redirecionar.
    if (authState.isLoading) return null;

    final isAuthenticated = authState.valueOrNull != null;

    // Sessão ativa → pula o login e vai direto ao wizard.
    if (isAuthenticated && loc == AppRoutes.login) return AppRoutes.wizard;

    // Sem sessão → protege o wizard contra acesso direto.
    if (!isAuthenticated && loc == AppRoutes.wizard) return AppRoutes.login;

    return null;
  }
}

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


