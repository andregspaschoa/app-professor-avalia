// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfessorModelImpl _$$ProfessorModelImplFromJson(Map<String, dynamic> json) =>
    _$ProfessorModelImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      escolaIds: (json['escola_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      turmaIds: (json['turma_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      disciplinas:
          (json['disciplinas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fotoUrl: json['foto_url'] as String?,
      ativo: json['ativo'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$ProfessorModelImplToJson(
  _$ProfessorModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'nome': instance.nome,
  'email': instance.email,
  'escola_ids': instance.escolaIds,
  'turma_ids': instance.turmaIds,
  'disciplinas': instance.disciplinas,
  'foto_url': instance.fotoUrl,
  'ativo': instance.ativo,
  'created_at': instance.createdAt,
};
