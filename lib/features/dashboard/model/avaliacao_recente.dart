/// Representa uma avaliação agrupada no dashboard — gerada pelo
/// [DashboardRepository] a partir dos scans do Hive.
///
/// Classe simples sem Freezed: não é serializada para rede, apenas
/// usada localmente entre o repository, o viewmodel e as telas.
class AvaliacaoRecente {
  const AvaliacaoRecente({
    required this.avaliacaoId,
    required this.avaliacaoTitulo,
    required this.escolaNome,
    required this.turmaNome,
    required this.totalAlunos,
    required this.mediaGeral,
    this.dataUltimaCorrecao,
    required this.scans,
  });

  final String avaliacaoId;

  /// Título da prova (campo `avaliacao_titulo` no scan).
  final String avaliacaoTitulo;

  /// Nome da escola (campo `escola_nome` no scan).
  final String escolaNome;

  /// Nome da turma (campo `turma_nome` no scan).
  final String turmaNome;

  /// Quantidade de alunos corrigidos nesta avaliação.
  final int totalAlunos;

  /// Média das notas calculadas dos alunos desta avaliação.
  final double mediaGeral;

  /// Data/hora da correção mais recente nesta avaliação.
  final DateTime? dataUltimaCorrecao;

  /// Lista completa dos scans desta avaliação — passada para a tela de detalhe.
  final List<Map<String, dynamic>> scans;

  /// Serializa para [Map] para passar via GoRouter `extra`.
  Map<String, dynamic> toMap() => {
        'avaliacao_id': avaliacaoId,
        'avaliacao_titulo': avaliacaoTitulo,
        'escola_nome': escolaNome,
        'turma_nome': turmaNome,
        'total_alunos': totalAlunos,
        'media_geral': mediaGeral,
        'data_ultima_correcao': dataUltimaCorrecao?.toIso8601String(),
        'scans': scans,
      };

  /// Desserializa de [Map] recebido via GoRouter `extra`.
  factory AvaliacaoRecente.fromMap(Map<String, dynamic> map) {
    return AvaliacaoRecente(
      avaliacaoId: map['avaliacao_id']?.toString() ?? '',
      avaliacaoTitulo: map['avaliacao_titulo']?.toString() ?? '?',
      escolaNome: map['escola_nome']?.toString() ?? '?',
      turmaNome: map['turma_nome']?.toString() ?? '?',
      totalAlunos: (map['total_alunos'] as num?)?.toInt() ?? 0,
      mediaGeral: (map['media_geral'] as num?)?.toDouble() ?? 0.0,
      dataUltimaCorrecao: DateTime.tryParse(
        map['data_ultima_correcao']?.toString() ?? '',
      ),
      scans: (map['scans'] as List?)
              ?.whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
    );
  }
}
