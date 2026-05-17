import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/error/failures.dart';
import '../../core/error/result.dart';
import 'model/turma_model.dart';

typedef JsonLoader = Future<String> Function(String path);

class TurmaRepository {
  const TurmaRepository({this.jsonLoader});

  final JsonLoader? jsonLoader;

  static const String _mockAssetPath = 'assets/mock/turmas.json';

  Future<String> _load(String path) =>
      jsonLoader != null ? jsonLoader!(path) : rootBundle.loadString(path);

  Future<Result<List<TurmaModel>, Failure>> fetchByEscolaAndProfessor(
    String escolaId,
    List<String> turmaIds,
  ) async {
    if (turmaIds.isEmpty) {
      return const Err(NotFoundFailure('Professor sem turmas vinculadas.'));
    }
    try {
      final raw = await _load(_mockAssetPath);
      final list =
          (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
      final turmas = list
          .map(TurmaModel.fromJson)
          .where(
            (t) =>
                t.ativo &&
                t.escolaId == escolaId &&
                turmaIds.contains(t.id),
          )
          .toList();
      if (turmas.isEmpty) {
        return const Err(
          NotFoundFailure('Nenhuma turma encontrada para esta escola.'),
        );
      }
      return Ok(turmas);
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }
}
