import 'package:freezed_annotation/freezed_annotation.dart';

part 'turma_model.freezed.dart';
part 'turma_model.g.dart';

/// Modelo imutável de uma turma.
///
/// Mapeado diretamente de `assets/mock/turmas.json`.
@freezed
abstract class TurmaModel with _$TurmaModel {
  const factory TurmaModel({
    required String id,
    @JsonKey(name: 'escola_id') required String escolaId,
    required String nome,
    required String serie,

    /// Turno da turma: `matutino`, `vespertino` ou `noturno`.
    required String turno,

    @JsonKey(name: 'ano_letivo') required int anoLetivo,
    @JsonKey(name: 'total_alunos') required int totalAlunos,
    @Default(true) bool ativo,
  }) = _TurmaModel;

  factory TurmaModel.fromJson(Map<String, dynamic> json) =>
      _$TurmaModelFromJson(json);
}
