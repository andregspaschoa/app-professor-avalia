/// Constantes de todas as rotas do app.
///
/// Uso com path:  context.go(AppRoutes.wizardEscola)
/// Uso com name:  context.goNamed(AppRoutes.wizardEscolaName)
abstract final class AppRoutes {
  static const String splash = '/';
  static const String splashName = 'splash';

  static const String home = '/home';
  static const String homeName = 'home';

  static const String login = '/login';
  static const String loginName = 'login';

  // ── Wizard sub-routes ──────────────────────────────────────────────────────
  // Ponto de entrada: /wizard/escola (step 1).
  // Mantemos a constante `wizard` apontando para o step 1 por conveniência.
  static const String wizard = wizardEscola;

  static const String wizardEscola = '/wizard/escola';
  static const String wizardEscolaName = 'wizard-escola';

  static const String wizardTurma = '/wizard/turma';
  static const String wizardTurmaName = 'wizard-turma';

  static const String wizardAvaliacao = '/wizard/avaliacao';
  static const String wizardAvaliacaoName = 'wizard-avaliacao';

  static const String wizardAvaliacaoDetalhe = '/wizard/avaliacao/detalhe';
  static const String wizardAvaliacaoDetalheName = 'wizard-avaliacao-detalhe';

  static const String wizardGabaritoProf = '/wizard/gabarito/professor';
  static const String wizardGabaritoProfName = 'wizard-gabarito-professor';

  static const String wizardGabarito = '/wizard/gabarito';
  static const String wizardGabaritoName = 'wizard-gabarito';

  static const String wizardResultado = '/wizard/resultado';
  static const String wizardResultadoName = 'wizard-resultado';

  static const String scanner = '/scanner';
  static const String scannerName = 'scanner';

  static const String scannerResultado = '/scanner/resultado';
  static const String scannerResultadoName = 'scanner-resultado';

  static const String scanDetail = '/scan/detail';
  static const String scanDetailName = 'scan-detail';

  static const String avaliacaoDetalhe = '/avaliacao/detalhe';
  static const String avaliacaoDetalheName = 'avaliacao-detalhe';
}
