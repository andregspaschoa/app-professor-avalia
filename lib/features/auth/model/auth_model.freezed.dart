// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfessorModel _$ProfessorModelFromJson(Map<String, dynamic> json) {
  return _ProfessorModel.fromJson(json);
}

/// @nodoc
mixin _$ProfessorModel {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// IDs das escolas às quais o professor está vinculado.
  @JsonKey(name: 'escola_ids')
  List<String> get escolaIds => throw _privateConstructorUsedError;

  /// IDs das turmas sob responsabilidade do professor.
  @JsonKey(name: 'turma_ids')
  List<String> get turmaIds => throw _privateConstructorUsedError;

  /// Disciplinas lecionadas pelo professor.
  List<String> get disciplinas => throw _privateConstructorUsedError;

  /// URL da foto de perfil — nulo quando não cadastrada.
  @JsonKey(name: 'foto_url')
  String? get fotoUrl => throw _privateConstructorUsedError;

  /// Indica se a conta do professor está ativa no sistema.
  bool get ativo => throw _privateConstructorUsedError;

  /// Data/hora de criação do registro (ISO 8601).
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProfessorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfessorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfessorModelCopyWith<ProfessorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessorModelCopyWith<$Res> {
  factory $ProfessorModelCopyWith(
    ProfessorModel value,
    $Res Function(ProfessorModel) then,
  ) = _$ProfessorModelCopyWithImpl<$Res, ProfessorModel>;
  @useResult
  $Res call({
    String id,
    String nome,
    String email,
    @JsonKey(name: 'escola_ids') List<String> escolaIds,
    @JsonKey(name: 'turma_ids') List<String> turmaIds,
    List<String> disciplinas,
    @JsonKey(name: 'foto_url') String? fotoUrl,
    bool ativo,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$ProfessorModelCopyWithImpl<$Res, $Val extends ProfessorModel>
    implements $ProfessorModelCopyWith<$Res> {
  _$ProfessorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfessorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? email = null,
    Object? escolaIds = null,
    Object? turmaIds = null,
    Object? disciplinas = null,
    Object? fotoUrl = freezed,
    Object? ativo = null,
    Object? createdAt = freezed,
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
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            escolaIds: null == escolaIds
                ? _value.escolaIds
                : escolaIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            turmaIds: null == turmaIds
                ? _value.turmaIds
                : turmaIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            disciplinas: null == disciplinas
                ? _value.disciplinas
                : disciplinas // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            fotoUrl: freezed == fotoUrl
                ? _value.fotoUrl
                : fotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            ativo: null == ativo
                ? _value.ativo
                : ativo // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfessorModelImplCopyWith<$Res>
    implements $ProfessorModelCopyWith<$Res> {
  factory _$$ProfessorModelImplCopyWith(
    _$ProfessorModelImpl value,
    $Res Function(_$ProfessorModelImpl) then,
  ) = __$$ProfessorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    String email,
    @JsonKey(name: 'escola_ids') List<String> escolaIds,
    @JsonKey(name: 'turma_ids') List<String> turmaIds,
    List<String> disciplinas,
    @JsonKey(name: 'foto_url') String? fotoUrl,
    bool ativo,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$ProfessorModelImplCopyWithImpl<$Res>
    extends _$ProfessorModelCopyWithImpl<$Res, _$ProfessorModelImpl>
    implements _$$ProfessorModelImplCopyWith<$Res> {
  __$$ProfessorModelImplCopyWithImpl(
    _$ProfessorModelImpl _value,
    $Res Function(_$ProfessorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfessorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? email = null,
    Object? escolaIds = null,
    Object? turmaIds = null,
    Object? disciplinas = null,
    Object? fotoUrl = freezed,
    Object? ativo = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ProfessorModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        escolaIds: null == escolaIds
            ? _value._escolaIds
            : escolaIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        turmaIds: null == turmaIds
            ? _value._turmaIds
            : turmaIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        disciplinas: null == disciplinas
            ? _value._disciplinas
            : disciplinas // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        fotoUrl: freezed == fotoUrl
            ? _value.fotoUrl
            : fotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        ativo: null == ativo
            ? _value.ativo
            : ativo // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfessorModelImpl implements _ProfessorModel {
  const _$ProfessorModelImpl({
    required this.id,
    required this.nome,
    required this.email,
    @JsonKey(name: 'escola_ids') required final List<String> escolaIds,
    @JsonKey(name: 'turma_ids') required final List<String> turmaIds,
    final List<String> disciplinas = const [],
    @JsonKey(name: 'foto_url') this.fotoUrl,
    this.ativo = true,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _escolaIds = escolaIds,
       _turmaIds = turmaIds,
       _disciplinas = disciplinas;

  factory _$ProfessorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfessorModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final String email;

  /// IDs das escolas às quais o professor está vinculado.
  final List<String> _escolaIds;

  /// IDs das escolas às quais o professor está vinculado.
  @override
  @JsonKey(name: 'escola_ids')
  List<String> get escolaIds {
    if (_escolaIds is EqualUnmodifiableListView) return _escolaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_escolaIds);
  }

  /// IDs das turmas sob responsabilidade do professor.
  final List<String> _turmaIds;

  /// IDs das turmas sob responsabilidade do professor.
  @override
  @JsonKey(name: 'turma_ids')
  List<String> get turmaIds {
    if (_turmaIds is EqualUnmodifiableListView) return _turmaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_turmaIds);
  }

  /// Disciplinas lecionadas pelo professor.
  final List<String> _disciplinas;

  /// Disciplinas lecionadas pelo professor.
  @override
  @JsonKey()
  List<String> get disciplinas {
    if (_disciplinas is EqualUnmodifiableListView) return _disciplinas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disciplinas);
  }

  /// URL da foto de perfil — nulo quando não cadastrada.
  @override
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;

  /// Indica se a conta do professor está ativa no sistema.
  @override
  @JsonKey()
  final bool ativo;

  /// Data/hora de criação do registro (ISO 8601).
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'ProfessorModel(id: $id, nome: $nome, email: $email, escolaIds: $escolaIds, turmaIds: $turmaIds, disciplinas: $disciplinas, fotoUrl: $fotoUrl, ativo: $ativo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessorModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(
              other._escolaIds,
              _escolaIds,
            ) &&
            const DeepCollectionEquality().equals(other._turmaIds, _turmaIds) &&
            const DeepCollectionEquality().equals(
              other._disciplinas,
              _disciplinas,
            ) &&
            (identical(other.fotoUrl, fotoUrl) || other.fotoUrl == fotoUrl) &&
            (identical(other.ativo, ativo) || other.ativo == ativo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    email,
    const DeepCollectionEquality().hash(_escolaIds),
    const DeepCollectionEquality().hash(_turmaIds),
    const DeepCollectionEquality().hash(_disciplinas),
    fotoUrl,
    ativo,
    createdAt,
  );

  /// Create a copy of ProfessorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessorModelImplCopyWith<_$ProfessorModelImpl> get copyWith =>
      __$$ProfessorModelImplCopyWithImpl<_$ProfessorModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfessorModelImplToJson(this);
  }
}

abstract class _ProfessorModel implements ProfessorModel {
  const factory _ProfessorModel({
    required final String id,
    required final String nome,
    required final String email,
    @JsonKey(name: 'escola_ids') required final List<String> escolaIds,
    @JsonKey(name: 'turma_ids') required final List<String> turmaIds,
    final List<String> disciplinas,
    @JsonKey(name: 'foto_url') final String? fotoUrl,
    final bool ativo,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$ProfessorModelImpl;

  factory _ProfessorModel.fromJson(Map<String, dynamic> json) =
      _$ProfessorModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  String get email;

  /// IDs das escolas às quais o professor está vinculado.
  @override
  @JsonKey(name: 'escola_ids')
  List<String> get escolaIds;

  /// IDs das turmas sob responsabilidade do professor.
  @override
  @JsonKey(name: 'turma_ids')
  List<String> get turmaIds;

  /// Disciplinas lecionadas pelo professor.
  @override
  List<String> get disciplinas;

  /// URL da foto de perfil — nulo quando não cadastrada.
  @override
  @JsonKey(name: 'foto_url')
  String? get fotoUrl;

  /// Indica se a conta do professor está ativa no sistema.
  @override
  bool get ativo;

  /// Data/hora de criação do registro (ISO 8601).
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of ProfessorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfessorModelImplCopyWith<_$ProfessorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
