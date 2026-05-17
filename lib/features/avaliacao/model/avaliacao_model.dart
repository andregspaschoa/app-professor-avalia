import 'package:freezed_annotation/freezed_annotation.dart';

part 'avaliacao_model.freezed.dart';
part 'avaliacao_model.g.dart';

/// Modelo imutável de uma avaliação.
///
/// Mapeado diretamente de `assets/mock/avaliacoes.json`.
@freezed
abstract class AvaliacaoModel with _$AvaliacaoModel {
  const factory AvaliacaoModel({
    required String id,
    @JsonKey(name: 'turma_id') required String turmaId,
    @JsonKey(name: 'professor_id') required String professorId,
    required String titulo,
    required String disciplina,
    required int bimestre,
    required String tipo,

    /// Data de aplicação no formato ISO 8601 (YYYY-MM-DD).
    @JsonKey(name: 'data_aplicacao') required String dataAplicacao,

    @JsonKey(name: 'total_questoes') required int totalQuestoes,
    @JsonKey(name: 'nota_maxima') required double notaMaxima,
    @JsonKey(name: 'peso_por_questao') required double pesoPorQuestao,

    /// Status da avaliação: `rascunho`, `aplicada` ou `corrigida`.
    required String status,

    /// Gabarito com as alternativas corretas (A, B, C, D, E).
    required List<String> gabarito,

    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _AvaliacaoModel;

  factory AvaliacaoModel.fromJson(Map<String, dynamic> json) =>
      _$AvaliacaoModelFromJson(json);
}
