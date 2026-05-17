import 'package:freezed_annotation/freezed_annotation.dart';

part 'aluno_model.freezed.dart';
part 'aluno_model.g.dart';

/// Modelo imutável de um aluno.
///
/// Mapeado diretamente de `assets/mock/alunos.json`.
@freezed
abstract class AlunoModel with _$AlunoModel {
  const factory AlunoModel({
    required String id,
    @JsonKey(name: 'turma_id') required String turmaId,
    required String nome,
    required String matricula,
    @JsonKey(name: 'data_nascimento') required String dataNascimento,
    @Default(true) bool ativo,
  }) = _AlunoModel;

  factory AlunoModel.fromJson(Map<String, dynamic> json) =>
      _$AlunoModelFromJson(json);
}
