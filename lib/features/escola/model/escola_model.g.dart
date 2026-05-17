// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escola_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EscolaModelImpl _$$EscolaModelImplFromJson(Map<String, dynamic> json) =>
    _$EscolaModelImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      codigoInep: json['codigo_inep'] as String,
      municipio: json['municipio'] as String,
      uf: json['uf'] as String,
      tipo: json['tipo'] as String,
      ativo: json['ativo'] as bool? ?? true,
    );

Map<String, dynamic> _$$EscolaModelImplToJson(_$EscolaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'codigo_inep': instance.codigoInep,
      'municipio': instance.municipio,
      'uf': instance.uf,
      'tipo': instance.tipo,
      'ativo': instance.ativo,
    };
