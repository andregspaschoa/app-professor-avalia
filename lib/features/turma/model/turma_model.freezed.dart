// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'turma_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TurmaModel _$TurmaModelFromJson(Map<String, dynamic> json) {
  return _TurmaModel.fromJson(json);
}

/// @nodoc
mixin _$TurmaModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'escola_id')
  String get escolaId => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get serie => throw _privateConstructorUsedError;

  /// Turno da turma: `matutino`, `vespertino` ou `noturno`.
  String get turno => throw _privateConstructorUsedError;
  @JsonKey(name: 'ano_letivo')
  int get anoLetivo => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_alunos')
  int get totalAlunos => throw _privateConstructorUsedError;
  bool get ativo => throw _privateConstructorUsedError;

  /// Serializes this TurmaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TurmaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TurmaModelCopyWith<TurmaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TurmaModelCopyWith<$Res> {
  factory $TurmaModelCopyWith(
    TurmaModel value,
    $Res Function(TurmaModel) then,
  ) = _$TurmaModelCopyWithImpl<$Res, TurmaModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'escola_id') String escolaId,
    String nome,
    String serie,
    String turno,
    @JsonKey(name: 'ano_letivo') int anoLetivo,
    @JsonKey(name: 'total_alunos') int totalAlunos,
    bool ativo,
  });
}

/// @nodoc
class _$TurmaModelCopyWithImpl<$Res, $Val extends TurmaModel>
    implements $TurmaModelCopyWith<$Res> {
  _$TurmaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TurmaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? escolaId = null,
    Object? nome = null,
    Object? serie = null,
    Object? turno = null,
    Object? anoLetivo = null,
    Object? totalAlunos = null,
    Object? ativo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            escolaId: null == escolaId
                ? _value.escolaId
                : escolaId // ignore: cast_nullable_to_non_nullable
                      as String,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            serie: null == serie
                ? _value.serie
                : serie // ignore: cast_nullable_to_non_nullable
                      as String,
            turno: null == turno
                ? _value.turno
                : turno // ignore: cast_nullable_to_non_nullable
                      as String,
            anoLetivo: null == anoLetivo
                ? _value.anoLetivo
                : anoLetivo // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAlunos: null == totalAlunos
                ? _value.totalAlunos
                : totalAlunos // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$TurmaModelImplCopyWith<$Res>
    implements $TurmaModelCopyWith<$Res> {
  factory _$$TurmaModelImplCopyWith(
    _$TurmaModelImpl value,
    $Res Function(_$TurmaModelImpl) then,
  ) = __$$TurmaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'escola_id') String escolaId,
    String nome,
    String serie,
    String turno,
    @JsonKey(name: 'ano_letivo') int anoLetivo,
    @JsonKey(name: 'total_alunos') int totalAlunos,
    bool ativo,
  });
}

/// @nodoc
class __$$TurmaModelImplCopyWithImpl<$Res>
    extends _$TurmaModelCopyWithImpl<$Res, _$TurmaModelImpl>
    implements _$$TurmaModelImplCopyWith<$Res> {
  __$$TurmaModelImplCopyWithImpl(
    _$TurmaModelImpl _value,
    $Res Function(_$TurmaModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TurmaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? escolaId = null,
    Object? nome = null,
    Object? serie = null,
    Object? turno = null,
    Object? anoLetivo = null,
    Object? totalAlunos = null,
    Object? ativo = null,
  }) {
    return _then(
      _$TurmaModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        escolaId: null == escolaId
            ? _value.escolaId
            : escolaId // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        serie: null == serie
            ? _value.serie
            : serie // ignore: cast_nullable_to_non_nullable
                  as String,
        turno: null == turno
            ? _value.turno
            : turno // ignore: cast_nullable_to_non_nullable
                  as String,
        anoLetivo: null == anoLetivo
            ? _value.anoLetivo
            : anoLetivo // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAlunos: null == totalAlunos
            ? _value.totalAlunos
            : totalAlunos // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$TurmaModelImpl implements _TurmaModel {
  const _$TurmaModelImpl({
    required this.id,
    @JsonKey(name: 'escola_id') required this.escolaId,
    required this.nome,
    required this.serie,
    required this.turno,
    @JsonKey(name: 'ano_letivo') required this.anoLetivo,
    @JsonKey(name: 'total_alunos') required this.totalAlunos,
    this.ativo = true,
  });

  factory _$TurmaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TurmaModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'escola_id')
  final String escolaId;
  @override
  final String nome;
  @override
  final String serie;

  /// Turno da turma: `matutino`, `vespertino` ou `noturno`.
  @override
  final String turno;
  @override
  @JsonKey(name: 'ano_letivo')
  final int anoLetivo;
  @override
  @JsonKey(name: 'total_alunos')
  final int totalAlunos;
  @override
  @JsonKey()
  final bool ativo;

  @override
  String toString() {
    return 'TurmaModel(id: $id, escolaId: $escolaId, nome: $nome, serie: $serie, turno: $turno, anoLetivo: $anoLetivo, totalAlunos: $totalAlunos, ativo: $ativo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TurmaModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.escolaId, escolaId) ||
                other.escolaId == escolaId) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.serie, serie) || other.serie == serie) &&
            (identical(other.turno, turno) || other.turno == turno) &&
            (identical(other.anoLetivo, anoLetivo) ||
                other.anoLetivo == anoLetivo) &&
            (identical(other.totalAlunos, totalAlunos) ||
                other.totalAlunos == totalAlunos) &&
            (identical(other.ativo, ativo) || other.ativo == ativo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    escolaId,
    nome,
    serie,
    turno,
    anoLetivo,
    totalAlunos,
    ativo,
  );

  /// Create a copy of TurmaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TurmaModelImplCopyWith<_$TurmaModelImpl> get copyWith =>
      __$$TurmaModelImplCopyWithImpl<_$TurmaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TurmaModelImplToJson(this);
  }
}

abstract class _TurmaModel implements TurmaModel {
  const factory _TurmaModel({
    required final String id,
    @JsonKey(name: 'escola_id') required final String escolaId,
    required final String nome,
    required final String serie,
    required final String turno,
    @JsonKey(name: 'ano_letivo') required final int anoLetivo,
    @JsonKey(name: 'total_alunos') required final int totalAlunos,
    final bool ativo,
  }) = _$TurmaModelImpl;

  factory _TurmaModel.fromJson(Map<String, dynamic> json) =
      _$TurmaModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'escola_id')
  String get escolaId;
  @override
  String get nome;
  @override
  String get serie;

  /// Turno da turma: `matutino`, `vespertino` ou `noturno`.
  @override
  String get turno;
  @override
  @JsonKey(name: 'ano_letivo')
  int get anoLetivo;
  @override
  @JsonKey(name: 'total_alunos')
  int get totalAlunos;
  @override
  bool get ativo;

  /// Create a copy of TurmaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TurmaModelImplCopyWith<_$TurmaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
