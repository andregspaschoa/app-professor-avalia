// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aluno_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlunoModel _$AlunoModelFromJson(Map<String, dynamic> json) {
  return _AlunoModel.fromJson(json);
}

/// @nodoc
mixin _$AlunoModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'turma_id')
  String get turmaId => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get matricula => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_nascimento')
  String get dataNascimento => throw _privateConstructorUsedError;
  bool get ativo => throw _privateConstructorUsedError;

  /// Serializes this AlunoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlunoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlunoModelCopyWith<AlunoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlunoModelCopyWith<$Res> {
  factory $AlunoModelCopyWith(
    AlunoModel value,
    $Res Function(AlunoModel) then,
  ) = _$AlunoModelCopyWithImpl<$Res, AlunoModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'turma_id') String turmaId,
    String nome,
    String matricula,
    @JsonKey(name: 'data_nascimento') String dataNascimento,
    bool ativo,
  });
}

/// @nodoc
class _$AlunoModelCopyWithImpl<$Res, $Val extends AlunoModel>
    implements $AlunoModelCopyWith<$Res> {
  _$AlunoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlunoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? turmaId = null,
    Object? nome = null,
    Object? matricula = null,
    Object? dataNascimento = null,
    Object? ativo = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            turmaId: null == turmaId
                ? _value.turmaId
                : turmaId // ignore: cast_nullable_to_non_nullable
                      as String,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            matricula: null == matricula
                ? _value.matricula
                : matricula // ignore: cast_nullable_to_non_nullable
                      as String,
            dataNascimento: null == dataNascimento
                ? _value.dataNascimento
                : dataNascimento // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AlunoModelImplCopyWith<$Res>
    implements $AlunoModelCopyWith<$Res> {
  factory _$$AlunoModelImplCopyWith(
    _$AlunoModelImpl value,
    $Res Function(_$AlunoModelImpl) then,
  ) = __$$AlunoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'turma_id') String turmaId,
    String nome,
    String matricula,
    @JsonKey(name: 'data_nascimento') String dataNascimento,
    bool ativo,
  });
}

/// @nodoc
class __$$AlunoModelImplCopyWithImpl<$Res>
    extends _$AlunoModelCopyWithImpl<$Res, _$AlunoModelImpl>
    implements _$$AlunoModelImplCopyWith<$Res> {
  __$$AlunoModelImplCopyWithImpl(
    _$AlunoModelImpl _value,
    $Res Function(_$AlunoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlunoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? turmaId = null,
    Object? nome = null,
    Object? matricula = null,
    Object? dataNascimento = null,
    Object? ativo = null,
  }) {
    return _then(
      _$AlunoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        turmaId: null == turmaId
            ? _value.turmaId
            : turmaId // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        matricula: null == matricula
            ? _value.matricula
            : matricula // ignore: cast_nullable_to_non_nullable
                  as String,
        dataNascimento: null == dataNascimento
            ? _value.dataNascimento
            : dataNascimento // ignore: cast_nullable_to_non_nullable
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
class _$AlunoModelImpl implements _AlunoModel {
  const _$AlunoModelImpl({
    required this.id,
    @JsonKey(name: 'turma_id') required this.turmaId,
    required this.nome,
    required this.matricula,
    @JsonKey(name: 'data_nascimento') required this.dataNascimento,
    this.ativo = true,
  });

  factory _$AlunoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlunoModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'turma_id')
  final String turmaId;
  @override
  final String nome;
  @override
  final String matricula;
  @override
  @JsonKey(name: 'data_nascimento')
  final String dataNascimento;
  @override
  @JsonKey()
  final bool ativo;

  @override
  String toString() {
    return 'AlunoModel(id: $id, turmaId: $turmaId, nome: $nome, matricula: $matricula, dataNascimento: $dataNascimento, ativo: $ativo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlunoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.turmaId, turmaId) || other.turmaId == turmaId) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.matricula, matricula) ||
                other.matricula == matricula) &&
            (identical(other.dataNascimento, dataNascimento) ||
                other.dataNascimento == dataNascimento) &&
            (identical(other.ativo, ativo) || other.ativo == ativo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    turmaId,
    nome,
    matricula,
    dataNascimento,
    ativo,
  );

  /// Create a copy of AlunoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlunoModelImplCopyWith<_$AlunoModelImpl> get copyWith =>
      __$$AlunoModelImplCopyWithImpl<_$AlunoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlunoModelImplToJson(this);
  }
}

abstract class _AlunoModel implements AlunoModel {
  const factory _AlunoModel({
    required final String id,
    @JsonKey(name: 'turma_id') required final String turmaId,
    required final String nome,
    required final String matricula,
    @JsonKey(name: 'data_nascimento') required final String dataNascimento,
    final bool ativo,
  }) = _$AlunoModelImpl;

  factory _AlunoModel.fromJson(Map<String, dynamic> json) =
      _$AlunoModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'turma_id')
  String get turmaId;
  @override
  String get nome;
  @override
  String get matricula;
  @override
  @JsonKey(name: 'data_nascimento')
  String get dataNascimento;
  @override
  bool get ativo;

  /// Create a copy of AlunoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlunoModelImplCopyWith<_$AlunoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
