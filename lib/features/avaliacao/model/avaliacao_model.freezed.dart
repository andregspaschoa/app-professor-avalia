// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avaliacao_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AvaliacaoModel _$AvaliacaoModelFromJson(Map<String, dynamic> json) {
  return _AvaliacaoModel.fromJson(json);
}

/// @nodoc
mixin _$AvaliacaoModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'turma_id')
  String get turmaId => throw _privateConstructorUsedError;
  @JsonKey(name: 'professor_id')
  String get professorId => throw _privateConstructorUsedError;
  String get titulo => throw _privateConstructorUsedError;
  String get disciplina => throw _privateConstructorUsedError;
  int get bimestre => throw _privateConstructorUsedError;
  String get tipo => throw _privateConstructorUsedError;

  /// Data de aplicação no formato ISO 8601 (YYYY-MM-DD).
  @JsonKey(name: 'data_aplicacao')
  String get dataAplicacao => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_questoes')
  int get totalQuestoes => throw _privateConstructorUsedError;
  @JsonKey(name: 'nota_maxima')
  double get notaMaxima => throw _privateConstructorUsedError;
  @JsonKey(name: 'peso_por_questao')
  double get pesoPorQuestao => throw _privateConstructorUsedError;

  /// Status da avaliação: `rascunho`, `aplicada` ou `corrigida`.
  String get status => throw _privateConstructorUsedError;

  /// Gabarito com as alternativas corretas (A, B, C, D, E).
  List<String> get gabarito => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AvaliacaoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvaliacaoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvaliacaoModelCopyWith<AvaliacaoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvaliacaoModelCopyWith<$Res> {
  factory $AvaliacaoModelCopyWith(
    AvaliacaoModel value,
    $Res Function(AvaliacaoModel) then,
  ) = _$AvaliacaoModelCopyWithImpl<$Res, AvaliacaoModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'turma_id') String turmaId,
    @JsonKey(name: 'professor_id') String professorId,
    String titulo,
    String disciplina,
    int bimestre,
    String tipo,
    @JsonKey(name: 'data_aplicacao') String dataAplicacao,
    @JsonKey(name: 'total_questoes') int totalQuestoes,
    @JsonKey(name: 'nota_maxima') double notaMaxima,
    @JsonKey(name: 'peso_por_questao') double pesoPorQuestao,
    String status,
    List<String> gabarito,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
  });
}

/// @nodoc
class _$AvaliacaoModelCopyWithImpl<$Res, $Val extends AvaliacaoModel>
    implements $AvaliacaoModelCopyWith<$Res> {
  _$AvaliacaoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvaliacaoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? turmaId = null,
    Object? professorId = null,
    Object? titulo = null,
    Object? disciplina = null,
    Object? bimestre = null,
    Object? tipo = null,
    Object? dataAplicacao = null,
    Object? totalQuestoes = null,
    Object? notaMaxima = null,
    Object? pesoPorQuestao = null,
    Object? status = null,
    Object? gabarito = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
            professorId: null == professorId
                ? _value.professorId
                : professorId // ignore: cast_nullable_to_non_nullable
                      as String,
            titulo: null == titulo
                ? _value.titulo
                : titulo // ignore: cast_nullable_to_non_nullable
                      as String,
            disciplina: null == disciplina
                ? _value.disciplina
                : disciplina // ignore: cast_nullable_to_non_nullable
                      as String,
            bimestre: null == bimestre
                ? _value.bimestre
                : bimestre // ignore: cast_nullable_to_non_nullable
                      as int,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as String,
            dataAplicacao: null == dataAplicacao
                ? _value.dataAplicacao
                : dataAplicacao // ignore: cast_nullable_to_non_nullable
                      as String,
            totalQuestoes: null == totalQuestoes
                ? _value.totalQuestoes
                : totalQuestoes // ignore: cast_nullable_to_non_nullable
                      as int,
            notaMaxima: null == notaMaxima
                ? _value.notaMaxima
                : notaMaxima // ignore: cast_nullable_to_non_nullable
                      as double,
            pesoPorQuestao: null == pesoPorQuestao
                ? _value.pesoPorQuestao
                : pesoPorQuestao // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            gabarito: null == gabarito
                ? _value.gabarito
                : gabarito // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvaliacaoModelImplCopyWith<$Res>
    implements $AvaliacaoModelCopyWith<$Res> {
  factory _$$AvaliacaoModelImplCopyWith(
    _$AvaliacaoModelImpl value,
    $Res Function(_$AvaliacaoModelImpl) then,
  ) = __$$AvaliacaoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'turma_id') String turmaId,
    @JsonKey(name: 'professor_id') String professorId,
    String titulo,
    String disciplina,
    int bimestre,
    String tipo,
    @JsonKey(name: 'data_aplicacao') String dataAplicacao,
    @JsonKey(name: 'total_questoes') int totalQuestoes,
    @JsonKey(name: 'nota_maxima') double notaMaxima,
    @JsonKey(name: 'peso_por_questao') double pesoPorQuestao,
    String status,
    List<String> gabarito,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
  });
}

/// @nodoc
class __$$AvaliacaoModelImplCopyWithImpl<$Res>
    extends _$AvaliacaoModelCopyWithImpl<$Res, _$AvaliacaoModelImpl>
    implements _$$AvaliacaoModelImplCopyWith<$Res> {
  __$$AvaliacaoModelImplCopyWithImpl(
    _$AvaliacaoModelImpl _value,
    $Res Function(_$AvaliacaoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvaliacaoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? turmaId = null,
    Object? professorId = null,
    Object? titulo = null,
    Object? disciplina = null,
    Object? bimestre = null,
    Object? tipo = null,
    Object? dataAplicacao = null,
    Object? totalQuestoes = null,
    Object? notaMaxima = null,
    Object? pesoPorQuestao = null,
    Object? status = null,
    Object? gabarito = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AvaliacaoModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        turmaId: null == turmaId
            ? _value.turmaId
            : turmaId // ignore: cast_nullable_to_non_nullable
                  as String,
        professorId: null == professorId
            ? _value.professorId
            : professorId // ignore: cast_nullable_to_non_nullable
                  as String,
        titulo: null == titulo
            ? _value.titulo
            : titulo // ignore: cast_nullable_to_non_nullable
                  as String,
        disciplina: null == disciplina
            ? _value.disciplina
            : disciplina // ignore: cast_nullable_to_non_nullable
                  as String,
        bimestre: null == bimestre
            ? _value.bimestre
            : bimestre // ignore: cast_nullable_to_non_nullable
                  as int,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as String,
        dataAplicacao: null == dataAplicacao
            ? _value.dataAplicacao
            : dataAplicacao // ignore: cast_nullable_to_non_nullable
                  as String,
        totalQuestoes: null == totalQuestoes
            ? _value.totalQuestoes
            : totalQuestoes // ignore: cast_nullable_to_non_nullable
                  as int,
        notaMaxima: null == notaMaxima
            ? _value.notaMaxima
            : notaMaxima // ignore: cast_nullable_to_non_nullable
                  as double,
        pesoPorQuestao: null == pesoPorQuestao
            ? _value.pesoPorQuestao
            : pesoPorQuestao // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        gabarito: null == gabarito
            ? _value._gabarito
            : gabarito // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvaliacaoModelImpl implements _AvaliacaoModel {
  const _$AvaliacaoModelImpl({
    required this.id,
    @JsonKey(name: 'turma_id') required this.turmaId,
    @JsonKey(name: 'professor_id') required this.professorId,
    required this.titulo,
    required this.disciplina,
    required this.bimestre,
    required this.tipo,
    @JsonKey(name: 'data_aplicacao') required this.dataAplicacao,
    @JsonKey(name: 'total_questoes') required this.totalQuestoes,
    @JsonKey(name: 'nota_maxima') required this.notaMaxima,
    @JsonKey(name: 'peso_por_questao') required this.pesoPorQuestao,
    required this.status,
    required final List<String> gabarito,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _gabarito = gabarito;

  factory _$AvaliacaoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvaliacaoModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'turma_id')
  final String turmaId;
  @override
  @JsonKey(name: 'professor_id')
  final String professorId;
  @override
  final String titulo;
  @override
  final String disciplina;
  @override
  final int bimestre;
  @override
  final String tipo;

  /// Data de aplicação no formato ISO 8601 (YYYY-MM-DD).
  @override
  @JsonKey(name: 'data_aplicacao')
  final String dataAplicacao;
  @override
  @JsonKey(name: 'total_questoes')
  final int totalQuestoes;
  @override
  @JsonKey(name: 'nota_maxima')
  final double notaMaxima;
  @override
  @JsonKey(name: 'peso_por_questao')
  final double pesoPorQuestao;

  /// Status da avaliação: `rascunho`, `aplicada` ou `corrigida`.
  @override
  final String status;

  /// Gabarito com as alternativas corretas (A, B, C, D, E).
  final List<String> _gabarito;

  /// Gabarito com as alternativas corretas (A, B, C, D, E).
  @override
  List<String> get gabarito {
    if (_gabarito is EqualUnmodifiableListView) return _gabarito;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gabarito);
  }

  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'AvaliacaoModel(id: $id, turmaId: $turmaId, professorId: $professorId, titulo: $titulo, disciplina: $disciplina, bimestre: $bimestre, tipo: $tipo, dataAplicacao: $dataAplicacao, totalQuestoes: $totalQuestoes, notaMaxima: $notaMaxima, pesoPorQuestao: $pesoPorQuestao, status: $status, gabarito: $gabarito, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvaliacaoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.turmaId, turmaId) || other.turmaId == turmaId) &&
            (identical(other.professorId, professorId) ||
                other.professorId == professorId) &&
            (identical(other.titulo, titulo) || other.titulo == titulo) &&
            (identical(other.disciplina, disciplina) ||
                other.disciplina == disciplina) &&
            (identical(other.bimestre, bimestre) ||
                other.bimestre == bimestre) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.dataAplicacao, dataAplicacao) ||
                other.dataAplicacao == dataAplicacao) &&
            (identical(other.totalQuestoes, totalQuestoes) ||
                other.totalQuestoes == totalQuestoes) &&
            (identical(other.notaMaxima, notaMaxima) ||
                other.notaMaxima == notaMaxima) &&
            (identical(other.pesoPorQuestao, pesoPorQuestao) ||
                other.pesoPorQuestao == pesoPorQuestao) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._gabarito, _gabarito) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    turmaId,
    professorId,
    titulo,
    disciplina,
    bimestre,
    tipo,
    dataAplicacao,
    totalQuestoes,
    notaMaxima,
    pesoPorQuestao,
    status,
    const DeepCollectionEquality().hash(_gabarito),
    createdAt,
    updatedAt,
  );

  /// Create a copy of AvaliacaoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvaliacaoModelImplCopyWith<_$AvaliacaoModelImpl> get copyWith =>
      __$$AvaliacaoModelImplCopyWithImpl<_$AvaliacaoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvaliacaoModelImplToJson(this);
  }
}

abstract class _AvaliacaoModel implements AvaliacaoModel {
  const factory _AvaliacaoModel({
    required final String id,
    @JsonKey(name: 'turma_id') required final String turmaId,
    @JsonKey(name: 'professor_id') required final String professorId,
    required final String titulo,
    required final String disciplina,
    required final int bimestre,
    required final String tipo,
    @JsonKey(name: 'data_aplicacao') required final String dataAplicacao,
    @JsonKey(name: 'total_questoes') required final int totalQuestoes,
    @JsonKey(name: 'nota_maxima') required final double notaMaxima,
    @JsonKey(name: 'peso_por_questao') required final double pesoPorQuestao,
    required final String status,
    required final List<String> gabarito,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'updated_at') required final String updatedAt,
  }) = _$AvaliacaoModelImpl;

  factory _AvaliacaoModel.fromJson(Map<String, dynamic> json) =
      _$AvaliacaoModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'turma_id')
  String get turmaId;
  @override
  @JsonKey(name: 'professor_id')
  String get professorId;
  @override
  String get titulo;
  @override
  String get disciplina;
  @override
  int get bimestre;
  @override
  String get tipo;

  /// Data de aplicação no formato ISO 8601 (YYYY-MM-DD).
  @override
  @JsonKey(name: 'data_aplicacao')
  String get dataAplicacao;
  @override
  @JsonKey(name: 'total_questoes')
  int get totalQuestoes;
  @override
  @JsonKey(name: 'nota_maxima')
  double get notaMaxima;
  @override
  @JsonKey(name: 'peso_por_questao')
  double get pesoPorQuestao;

  /// Status da avaliação: `rascunho`, `aplicada` ou `corrigida`.
  @override
  String get status;

  /// Gabarito com as alternativas corretas (A, B, C, D, E).
  @override
  List<String> get gabarito;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;

  /// Create a copy of AvaliacaoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvaliacaoModelImplCopyWith<_$AvaliacaoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
