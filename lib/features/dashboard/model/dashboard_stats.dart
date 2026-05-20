import 'avaliacao_recente.dart';

/// Métricas calculadas a partir dos scans salvos no Hive.
///
/// Classe de agregação imutável por convenção — não usa Freezed porque
/// não é serializada nem enviada para rede (YAGNI).
class DashboardStats {
  const DashboardStats({
    required this.totalCorrigidos,
    required this.mediaTurma,
    this.questaoCritica,
    required this.scansRecentes,
    this.avaliacoesRecentes = const [],
  });

  /// Total de cartões corrigidos e salvos no Hive.
  final int totalCorrigidos;

  /// Média das notas calculadas. Zero quando não há scans.
  final double mediaTurma;

  /// Índice (1-based) da questão com mais erros entre todos os scans.
  /// Nulo quando não há dados suficientes para calcular.
  final int? questaoCritica;

  /// Os últimos scans salvos, ordenados do mais recente para o mais antigo.
  /// Cada item é o `Map<String, dynamic>` persistido no Hive.
  final List<Map<String, dynamic>> scansRecentes;

  /// Avaliações agrupadas e ordenadas pela correção mais recente (top 10).
  final List<AvaliacaoRecente> avaliacoesRecentes;

  static const DashboardStats empty = DashboardStats(
    totalCorrigidos: 0,
    mediaTurma: 0,
    scansRecentes: [],
    avaliacoesRecentes: [],
  );
}
