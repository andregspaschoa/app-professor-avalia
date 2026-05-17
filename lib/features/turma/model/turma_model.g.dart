// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turma_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TurmaModelImpl _$$TurmaModelImplFromJson(Map<String, dynamic> json) =>
    _$TurmaModelImpl(
      id: json['id'] as String,
      escolaId: json['escola_id'] as String,
      nome: json['nome'] as String,
      serie: json['serie'] as String,
      turno: json['turno'] as String,
      anoLetivo: (json['ano_letivo'] as num).toInt(),
      totalAlunos: (json['total_alunos'] as num).toInt(),
      ativo: json['ativo'] as bool? ?? true,
    );

Map<String, dynamic> _$$TurmaModelImplToJson(_$TurmaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'escola_id': instance.escolaId,
      'nome': instance.nome,
      'serie': instance.serie,
      'turno': instance.turno,
      'ano_letivo': instance.anoLetivo,
      'total_alunos': instance.totalAlunos,
      'ativo': instance.ativo,
    };
