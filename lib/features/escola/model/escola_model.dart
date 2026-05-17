import 'package:freezed_annotation/freezed_annotation.dart';

part 'escola_model.freezed.dart';
part 'escola_model.g.dart';

/// Modelo imutável de uma escola.
///
/// Mapeado diretamente de `assets/mock/escolas.json`.
@freezed
abstract class EscolaModel with _$EscolaModel {
  const factory EscolaModel({
    required String id,
    required String nome,

    /// Código INEP da escola (identificador nacional único).
    @JsonKey(name: 'codigo_inep') required String codigoInep,

    required String municipio,
    required String uf,

    /// Tipo da escola: `municipal`, `estadual` ou `privada`.
    required String tipo,

    @Default(true) bool ativo,
  }) = _EscolaModel;

  factory EscolaModel.fromJson(Map<String, dynamic> json) =>
      _$EscolaModelFromJson(json);
}
