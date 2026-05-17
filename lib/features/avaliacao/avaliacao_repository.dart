import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/error/failures.dart';
import '../../core/error/result.dart';
import 'model/avaliacao_model.dart';

typedef JsonLoader = Future<String> Function(String path);

class AvaliacaoRepository {
  const AvaliacaoRepository({this.jsonLoader});

  final JsonLoader? jsonLoader;

  static const String _mockAssetPath = 'assets/mock/avaliacoes.json';

  Future<String> _load(String path) =>
      jsonLoader != null ? jsonLoader!(path) : rootBundle.loadString(path);

  Future<Result<List<AvaliacaoModel>, Failure>> fetchByTurma(
    String turmaId,
  ) async {
    try {
      final raw = await _load(_mockAssetPath);
      final list =
          (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
      final avaliacoes = list
          .map(AvaliacaoModel.fromJson)
          .where((a) => a.turmaId == turmaId)
          .toList();
      if (avaliacoes.isEmpty) {
        return const Err(
          NotFoundFailure('Nenhuma avaliação encontrada para esta turma.'),
        );
      }
      return Ok(avaliacoes);
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }
}
