// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avaliacao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvaliacaoModelImpl _$$AvaliacaoModelImplFromJson(Map<String, dynamic> json) =>
    _$AvaliacaoModelImpl(
      id: json['id'] as String,
      turmaId: json['turma_id'] as String,
      professorId: json['professor_id'] as String,
      titulo: json['titulo'] as String,
      disciplina: json['disciplina'] as String,
      bimestre: (json['bimestre'] as num).toInt(),
      tipo: json['tipo'] as String,
      dataAplicacao: json['data_aplicacao'] as String,
      totalQuestoes: (json['total_questoes'] as num).toInt(),
      notaMaxima: (json['nota_maxima'] as num).toDouble(),
      pesoPorQuestao: (json['peso_por_questao'] as num).toDouble(),
      status: json['status'] as String,
      gabarito: (json['gabarito'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$AvaliacaoModelImplToJson(
  _$AvaliacaoModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'turma_id': instance.turmaId,
  'professor_id': instance.professorId,
  'titulo': instance.titulo,
  'disciplina': instance.disciplina,
  'bimestre': instance.bimestre,
  'tipo': instance.tipo,
  'data_aplicacao': instance.dataAplicacao,
  'total_questoes': instance.totalQuestoes,
  'nota_maxima': instance.notaMaxima,
  'peso_por_questao': instance.pesoPorQuestao,
  'status': instance.status,
  'gabarito': instance.gabarito,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
