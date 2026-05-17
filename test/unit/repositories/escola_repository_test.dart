import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/core/error/failures.dart';
import 'package:professor_avalia/core/error/result.dart';
import 'package:professor_avalia/features/escola/escola_repository.dart';
import 'package:professor_avalia/features/escola/model/escola_model.dart';

// ── Fixtures ─────────────────────────────────────────────────────────────────

const _esc01 = {
  'id': 'esc_01',
  'nome': 'Escola Municipal Professor Carlos',
  'codigo_inep': '35012345',
  'municipio': 'São Paulo',
  'uf': 'SP',
  'tipo': 'municipal',
  'ativo': true,
};

const _esc02 = {
  'id': 'esc_02',
  'nome': 'Colégio Estadual Maria Helena',
  'codigo_inep': '35023456',
  'municipio': 'Campinas',
  'uf': 'SP',
  'tipo': 'estadual',
  'ativo': true,
};

const _esc03 = {
  'id': 'esc_03',
  'nome': 'Instituto Educacional Santo Antônio',
  'codigo_inep': '35034567',
  'municipio': 'Guarulhos',
  'uf': 'SP',
  'tipo': 'privada',
  'ativo': true,
};

const _esc04Inativo = {
  'id': 'esc_04',
  'nome': 'Escola Inativa',
  'codigo_inep': '35099999',
  'municipio': 'São Paulo',
  'uf': 'SP',
  'tipo': 'municipal',
  'ativo': false,
};

EscolaRepository _repoWith(List<Map<String, dynamic>> data) =>
    EscolaRepository(jsonLoader: (_) async => jsonEncode(data));

// ── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('EscolaRepository.fetchByProfessor()', () {
    test('retorna escolas filtradas pelos IDs do professor', () async {
      final repo = _repoWith([_esc01, _esc02, _esc03]);

      final result = await repo.fetchByProfessor(['esc_01', 'esc_02']);

      expect(result, isA<Ok<List<EscolaModel>, Failure>>());
      final escolas = (result as Ok<List<EscolaModel>, Failure>).value;
      expect(escolas.length, 2);
      expect(escolas.map((e) => e.id), containsAll(['esc_01', 'esc_02']));
    });

    test('campos mapeados corretamente (snake_case → camelCase)', () async {
      final repo = _repoWith([_esc01]);

      final result = await repo.fetchByProfessor(['esc_01']);

      final escola = (result as Ok<List<EscolaModel>, Failure>).value.first;
      expect(escola.id, 'esc_01');
      expect(escola.nome, 'Escola Municipal Professor Carlos');
      expect(escola.codigoInep, '35012345');
      expect(escola.municipio, 'São Paulo');
      expect(escola.uf, 'SP');
      expect(escola.tipo, 'municipal');
      expect(escola.ativo, isTrue);
    });

    test('escola inativa é excluída do resultado', () async {
      final repo = _repoWith([_esc01, _esc04Inativo]);

      final result = await repo.fetchByProfessor(['esc_01', 'esc_04']);

      final escolas = (result as Ok<List<EscolaModel>, Failure>).value;
      expect(escolas.length, 1);
      expect(escolas.first.id, 'esc_01');
    });

    test('IDs fora da lista do professor são ignorados', () async {
      final repo = _repoWith([_esc01, _esc02, _esc03]);

      // professor só tem esc_01, mas o JSON tem esc_01, esc_02, esc_03
      final result = await repo.fetchByProfessor(['esc_01']);

      final escolas = (result as Ok<List<EscolaModel>, Failure>).value;
      expect(escolas.length, 1);
      expect(escolas.first.id, 'esc_01');
    });

    test('lista de IDs vazia → Err(NotFoundFailure)', () async {
      final repo = _repoWith([_esc01]);

      final result = await repo.fetchByProfessor([]);

      expect(result, isA<Err<List<EscolaModel>, Failure>>());
      expect(
        (result as Err<List<EscolaModel>, Failure>).error,
        isA<NotFoundFailure>(),
      );
    });

    test('nenhuma escola coincide com os IDs → Err(NotFoundFailure)', () async {
      final repo = _repoWith([_esc01, _esc02]);

      final result = await repo.fetchByProfessor(['esc_99']);

      expect(result, isA<Err<List<EscolaModel>, Failure>>());
      expect(
        (result as Err<List<EscolaModel>, Failure>).error,
        isA<NotFoundFailure>(),
      );
    });

    test('JSON malformado → Err(ParseFailure)', () async {
      final repo = EscolaRepository(jsonLoader: (_) async => 'não é JSON');

      final result = await repo.fetchByProfessor(['esc_01']);

      expect(result, isA<Err<List<EscolaModel>, Failure>>());
      expect(
        (result as Err<List<EscolaModel>, Failure>).error,
        isA<ParseFailure>(),
      );
    });

    test('todas as três escolas do mock retornam quando todos os IDs são passados',
        () async {
      final repo = _repoWith([_esc01, _esc02, _esc03]);

      final result =
          await repo.fetchByProfessor(['esc_01', 'esc_02', 'esc_03']);

      final escolas = (result as Ok<List<EscolaModel>, Failure>).value;
      expect(escolas.length, 3);
    });
  });
}
