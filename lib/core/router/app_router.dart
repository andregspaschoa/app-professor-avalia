import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_viewmodel.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/model/auth_model.dart';
import '../../features/avaliacao/avaliacao_detail_screen.dart';
import '../../features/avaliacao/avaliacao_screen.dart';
import '../../features/dashboard/avaliacao_detalhe_screen.dart';
import '../../features/dashboard/scan_detail_screen.dart';
import '../../features/escola/escola_screen.dart';
import '../../features/gabarito/gabarito_professor_screen.dart';
import '../../features/gabarito/gabarito_screen.dart';
import '../../features/gabarito/resultado_final_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/scanner/resultado_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/turma/turma_screen.dart';
import '../../features/wizard/wizard_screen.dart';
import '../../features/wizard/wizard_viewmodel.dart';
import 'app_routes.dart';
import 'route_transitions.dart';

/// Chave do navigator aninhado do ShellRoute do wizard.
///
/// Permite ao [_WizardStepObserver] detectar pops dentro do shell e
/// manter o [wizardViewModelProvider].step sincronizado.
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Detecta pops dentro do navigator do wizard shell e atualiza o step
/// no [wizardViewModelProvider] — necessário para o gesto/botão de sistema
/// do Android funcionar corretamente sem precisar de PopScope no shell.
class _WizardStepObserver extends NavigatorObserver {
  _WizardStepObserver(this._ref);
  final Ref _ref;

  /// Mapeia nome ou path da rota para o step do wizard.
  ///
  /// go_router pode usar o campo `name` ou o `path` do GoRoute como
  /// `route.settings.name` dependendo da versão — cobrimos os dois.
  static int _stepFromName(String? name) => switch (name) {
        AppRoutes.wizardEscolaName || AppRoutes.wizardEscola => 1,
        AppRoutes.wizardTurmaName || AppRoutes.wizardTurma => 2,
        AppRoutes.wizardAvaliacaoName || AppRoutes.wizardAvaliacao => 3,
        AppRoutes.wizardAvaliacaoDetalheName ||
              AppRoutes.wizardAvaliacaoDetalhe =>
            4,
        AppRoutes.wizardGabaritoProfName || AppRoutes.wizardGabaritoProf => 5,
        AppRoutes.wizardGabaritoName || AppRoutes.wizardGabarito => 6,
        _ => 1,
      };

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final name = previousRoute?.settings.name;
    // Só sincroniza se ainda há uma rota de wizard na pilha
    if (name != null) {
      _ref
          .read(wizardViewModelProvider.notifier)
          .advanceToStep(_stepFromName(name));
    }
  }
}

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
        pageBuilder: (context, state) => fadePage(state, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        pageBuilder: (context, state) => fadePage(state, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        pageBuilder: (context, state) => fadePage(state, const HomeScreen()),
      ),
      // ── Scanner (fora do wizard shell) ──────────────────────────────────────
      GoRoute(
        path: AppRoutes.scanner,
        name: AppRoutes.scannerName,
        pageBuilder: (context, state) =>
            slideRightPage(state, const ScannerScreen()),
      ),
      GoRoute(
        path: AppRoutes.scannerResultado,
        name: AppRoutes.scannerResultadoName,
        pageBuilder: (context, state) =>
            slideRightPage(state, const ResultadoScreen()),
      ),
      GoRoute(
        path: AppRoutes.scanDetail,
        name: AppRoutes.scanDetailName,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return slideBottomPage(state, ScanDetailScreen(scanData: data));
        },
      ),
      GoRoute(
        path: AppRoutes.avaliacaoDetalhe,
        name: AppRoutes.avaliacaoDetalheName,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return slideBottomPage(state, AvaliacaoDetalheScreen(data: data));
        },
      ),
      // ── Wizard shell ────────────────────────────────────────────────────────
      // O ShellRoute envolve todas as sub-rotas do wizard com o Scaffold
      // compartilhado (AppBar + LinearProgressIndicator).
      // A primeira rota (/wizard/escola) é o ponto de entrada do wizard.
      // ── Wizard shell ────────────────────────────────────────────────────────
      // O ShellRoute envolve todas as sub-rotas do wizard com o Scaffold
      // compartilhado (AppBar + LinearProgressIndicator).
      // O step é gerenciado pelo WizardViewModel — não pelo estado da rota.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        observers: [_WizardStepObserver(ref)],
        pageBuilder: (context, state, child) =>
            slideRightPage(state, WizardScreen(child: child)),
        routes: [
          GoRoute(
            path: AppRoutes.wizardEscola,
            name: AppRoutes.wizardEscolaName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const EscolaScreen()),
          ),
          GoRoute(
            path: AppRoutes.wizardTurma,
            name: AppRoutes.wizardTurmaName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const TurmaScreen()),
          ),
          GoRoute(
            path: AppRoutes.wizardAvaliacao,
            name: AppRoutes.wizardAvaliacaoName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const AvaliacaoScreen()),
          ),
          GoRoute(
            path: AppRoutes.wizardAvaliacaoDetalhe,
            name: AppRoutes.wizardAvaliacaoDetalheName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const AvaliacaoDetailScreen()),
          ),
          GoRoute(
            path: AppRoutes.wizardGabaritoProf,
            name: AppRoutes.wizardGabaritoProfName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const GabaritoProfessorScreen()),
          ),
          GoRoute(
            path: AppRoutes.wizardGabarito,
            name: AppRoutes.wizardGabaritoName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const GabaritoScreen()),
          ),
          GoRoute(
            path: AppRoutes.wizardResultado,
            name: AppRoutes.wizardResultadoName,
            pageBuilder: (context, state) =>
                slideRightPage(state, const ResultadoFinalScreen()),
          ),
        ],
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
      (_, _) => notifyListeners(),
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

    // Sessão ativa → pula o login e vai direto à home.
    if (isAuthenticated && loc == AppRoutes.login) return AppRoutes.home;

    // Sem sessão → protege home e qualquer sub-rota do wizard.
    if (!isAuthenticated && (loc == AppRoutes.home || loc.startsWith('/wizard'))) return AppRoutes.login;

    return null;
  }
}

// AppRoutes foi extraído para app_routes.dart
