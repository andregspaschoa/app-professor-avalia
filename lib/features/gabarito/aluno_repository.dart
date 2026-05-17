import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/error/failures.dart';
import '../../core/error/result.dart';
import 'model/aluno_model.dart';

typedef JsonLoader = Future<String> Function(String path);

/// Fonte de dados de alunos para o MVP.
///
/// Lê `assets/mock/alunos.json` e filtra por [turmaId] e [ativo == true].
class AlunoRepository {
  const AlunoRepository({this.jsonLoader});

  final JsonLoader? jsonLoader;

  static const String _mockAssetPath = 'assets/mock/alunos.json';

  Future<String> _load(String path) =>
      jsonLoader != null ? jsonLoader!(path) : rootBundle.loadString(path);

  /// Retorna os alunos ativos da turma identificada por [turmaId].
  Future<Result<List<AlunoModel>, Failure>> fetchByTurma(
    String turmaId,
  ) async {
    try {
      final raw = await _load(_mockAssetPath);
      final list =
          (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
      final alunos = list
          .map(AlunoModel.fromJson)
          .where((a) => a.ativo && a.turmaId == turmaId)
          .toList();
      if (alunos.isEmpty) {
        return const Err(
          NotFoundFailure('Nenhum aluno encontrado para esta turma.'),
        );
      }
      return Ok(alunos);
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }
}
