import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/error/failures.dart';
import '../../core/error/result.dart';
import 'model/escola_model.dart';

/// Função de carregamento de asset JSON — injetável para facilitar testes
/// unitários sem depender de [rootBundle] (plataforma Flutter).
typedef JsonLoader = Future<String> Function(String path);

/// Fonte de dados de escolas para o MVP.
///
/// Lê `assets/mock/escolas.json` e filtra as escolas pelo conjunto de IDs
/// ao qual o professor está vinculado ([ProfessorModel.escolaIds]).
///
/// Contrato de retorno:
/// - [Ok<List<EscolaModel>>]     → lista filtrada (pode ser vazia).
/// - [Err<NotFoundFailure>]      → nenhuma escola encontrada para os IDs.
/// - [Err<ParseFailure>]         → JSON malformado.
/// - [Err<UnexpectedFailure>]    → qualquer outro erro interno.
///
/// TODO(3.x): substituir por chamada real à API quando o backend estiver pronto.
class EscolaRepository {
  const EscolaRepository({this.jsonLoader});

  /// Injetável para testes — usa [rootBundle.loadString] por padrão em produção.
  final JsonLoader? jsonLoader;

  static const String _mockAssetPath = 'assets/mock/escolas.json';

  Future<String> _load(String path) =>
      jsonLoader != null ? jsonLoader!(path) : rootBundle.loadString(path);

  /// Retorna as escolas vinculadas ao professor filtradas por [escolaIds].
  ///
  /// Retorna apenas escolas com [EscolaModel.ativo] == `true`.
  ///
  /// A ordem retornada segue a ordem em que aparecem no JSON.
  Future<Result<List<EscolaModel>, Failure>> fetchByProfessor(
    List<String> escolaIds,
  ) async {
    if (escolaIds.isEmpty) {
      return const Err(
        NotFoundFailure('Professor sem escolas vinculadas.'),
      );
    }

    try {
      final raw = await _load(_mockAssetPath);
      final list = (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>();

      final escolas = list
          .map(EscolaModel.fromJson)
          .where((e) => e.ativo && escolaIds.contains(e.id))
          .toList();

      if (escolas.isEmpty) {
        return const Err(
          NotFoundFailure('Nenhuma escola encontrada para este professor.'),
        );
      }

      return Ok(escolas);
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }
}
