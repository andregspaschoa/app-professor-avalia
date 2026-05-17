// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aluno_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlunoModelImpl _$$AlunoModelImplFromJson(Map<String, dynamic> json) =>
    _$AlunoModelImpl(
      id: json['id'] as String,
      turmaId: json['turma_id'] as String,
      nome: json['nome'] as String,
      matricula: json['matricula'] as String,
      dataNascimento: json['data_nascimento'] as String,
      ativo: json['ativo'] as bool? ?? true,
    );

Map<String, dynamic> _$$AlunoModelImplToJson(_$AlunoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'turma_id': instance.turmaId,
      'nome': instance.nome,
      'matricula': instance.matricula,
      'data_nascimento': instance.dataNascimento,
      'ativo': instance.ativo,
    };
