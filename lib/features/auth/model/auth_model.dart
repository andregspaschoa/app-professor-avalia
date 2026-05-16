import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

/// Modelo imutável do professor autenticado.
///
/// Campos mapeados diretamente do mock `assets/mock/professores.json`.
/// Os campos snake_case do JSON são convertidos para camelCase via
/// [JsonKey] onde necessário.
///
/// Campos excluídos intencionalmente:
///   - `senha_hash`: nunca deve trafegar pelo modelo de domínio.
///
/// @JsonKey é usado nos parâmetros do factory para mapear snake_case do JSON
/// para camelCase do Dart. O aviso `invalid_annotation_target` é um falso
/// positivo conhecido — suprimido globalmente em analysis_options.yaml.
@freezed
abstract class ProfessorModel with _$ProfessorModel {
  const factory ProfessorModel({
    required String id,
    required String nome,
    required String email,

    /// IDs das escolas às quais o professor está vinculado.
    @JsonKey(name: 'escola_ids') required List<String> escolaIds,

    /// IDs das turmas sob responsabilidade do professor.
    @JsonKey(name: 'turma_ids') required List<String> turmaIds,

    /// Disciplinas lecionadas pelo professor.
    @Default([]) List<String> disciplinas,

    /// URL da foto de perfil — nulo quando não cadastrada.
    @JsonKey(name: 'foto_url') String? fotoUrl,

    /// Indica se a conta do professor está ativa no sistema.
    @Default(true) bool ativo,

    /// Data/hora de criação do registro (ISO 8601).
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ProfessorModel;

  factory ProfessorModel.fromJson(Map<String, dynamic> json) =>
      _$ProfessorModelFromJson(json);
}
