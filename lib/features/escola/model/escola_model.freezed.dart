// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escola_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EscolaModel _$EscolaModelFromJson(Map<String, dynamic> json) {
  return _EscolaModel.fromJson(json);
}

/// @nodoc
mixin _$EscolaModel {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;

  /// Código INEP da escola (identificador nacional único).
  @JsonKey(name: 'codigo_inep')
  String get codigoInep => throw _privateConstructorUsedError;
  String get municipio => throw _privateConstructorUsedError;
  String get uf => throw _privateConstructorUsedError;

  /// Tipo da escola: `municipal`, `estadual` ou `privada`.
  String get tipo => throw _privateConstructorUsedError;
  bool get ativo => throw _privateConstructorUsedError;

  /// Serializes this EscolaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EscolaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EscolaModelCopyWith<EscolaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EscolaModelCopyWith<$Res> {
  factory $EscolaModelCopyWith(
    EscolaModel value,
    $Res Function(EscolaModel) then,
  ) = _$EscolaModelCopyWithImpl<$Res, EscolaModel>;
  @useResult
  $Res call({
    String id,
    String nome,
    @JsonKey(name: 'codigo_inep') String codigoInep,
    String municipio,
    String uf,
    String tipo,
    bool ativo,
  });
}

/// @nodoc
class _$EscolaModelCopyWithImpl<$Res, $Val extends EscolaModel>
    implements $EscolaModelCopyWith<$Res> {
  _$EscolaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EscolaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? codigoInep = null,
    Object? municipio = null,
    Object? uf = null,
    Object? tipo = null,
    Object? ativo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            codigoInep: null == codigoInep
                ? _value.codigoInep
                : codigoInep // ignore: cast_nullable_to_non_nullable
                      as String,
            municipio: null == municipio
                ? _value.municipio
                : municipio // ignore: cast_nullable_to_non_nullable
                      as String,
            uf: null == uf
                ? _value.uf
                : uf // ignore: cast_nullable_to_non_nullable
                      as String,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
            ativo: null == ativo
                ? _value.ativo
                : ativo // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EscolaModelImplCopyWith<$Res>
    implements $EscolaModelCopyWith<$Res> {
  factory _$$EscolaModelImplCopyWith(
    _$EscolaModelImpl value,
    $Res Function(_$EscolaModelImpl) then,
  ) = __$$EscolaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    @JsonKey(name: 'codigo_inep') String codigoInep,
    String municipio,
    String uf,
    String tipo,
    bool ativo,
  });
}

/// @nodoc
class __$$EscolaModelImplCopyWithImpl<$Res>
    extends _$EscolaModelCopyWithImpl<$Res, _$EscolaModelImpl>
    implements _$$EscolaModelImplCopyWith<$Res> {
  __$$EscolaModelImplCopyWithImpl(
    _$EscolaModelImpl _value,
    $Res Function(_$EscolaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EscolaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? codigoInep = null,
    Object? municipio = null,
    Object? uf = null,
    Object? tipo = null,
    Object? ativo = null,
  }) {
    return _then(
      _$EscolaModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        codigoInep: null == codigoInep
            ? _value.codigoInep
            : codigoInep // ignore: cast_nullable_to_non_nullable
                  as String,
        municipio: null == municipio
            ? _value.municipio
            : municipio // ignore: cast_nullable_to_non_nullable
                  as String,
        uf: null == uf
            ? _value.uf
            : uf // ignore: cast_nullable_to_non_nullable
                  as String,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
        ativo: null == ativo
            ? _value.ativo
            : ativo // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EscolaModelImpl implements _EscolaModel {
  const _$EscolaModelImpl({
    required this.id,
    required this.nome,
    @JsonKey(name: 'codigo_inep') required this.codigoInep,
    required this.municipio,
    required this.uf,
    required this.tipo,
    this.ativo = true,
  });

  factory _$EscolaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EscolaModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;

  /// Código INEP da escola (identificador nacional único).
  @override
  @JsonKey(name: 'codigo_inep')
  final String codigoInep;
  @override
  final String municipio;
  @override
  final String uf;

  /// Tipo da escola: `municipal`, `estadual` ou `privada`.
  @override
  final String tipo;
  @override
  @JsonKey()
  final bool ativo;

  @override
  String toString() {
    return 'EscolaModel(id: $id, nome: $nome, codigoInep: $codigoInep, municipio: $municipio, uf: $uf, tipo: $tipo, ativo: $ativo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EscolaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.codigoInep, codigoInep) ||
                other.codigoInep == codigoInep) &&
            (identical(other.municipio, municipio) ||
                other.municipio == municipio) &&
            (identical(other.uf, uf) || other.uf == uf) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.ativo, ativo) || other.ativo == ativo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    codigoInep,
    municipio,
    uf,
    tipo,
    ativo,
  );

  /// Create a copy of EscolaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EscolaModelImplCopyWith<_$EscolaModelImpl> get copyWith =>
      __$$EscolaModelImplCopyWithImpl<_$EscolaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EscolaModelImplToJson(this);
  }
}

abstract class _EscolaModel implements EscolaModel {
  const factory _EscolaModel({
    required final String id,
    required final String nome,
    @JsonKey(name: 'codigo_inep') required final String codigoInep,
    required final String municipio,
    required final String uf,
    required final String tipo,
    final bool ativo,
  }) = _$EscolaModelImpl;

  factory _EscolaModel.fromJson(Map<String, dynamic> json) =
      _$EscolaModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;

  /// Código INEP da escola (identificador nacional único).
  @override
  @JsonKey(name: 'codigo_inep')
  String get codigoInep;
  @override
  String get municipio;
  @override
  String get uf;

  /// Tipo da escola: `municipal`, `estadual` ou `privada`.
  @override
  String get tipo;
  @override
  bool get ativo;

  /// Create a copy of EscolaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EscolaModelImplCopyWith<_$EscolaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
