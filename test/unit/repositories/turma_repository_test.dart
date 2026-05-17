import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/core/error/failures.dart';
import 'package:professor_avalia/core/error/result.dart';
import 'package:professor_avalia/features/turma/model/turma_model.dart';
import 'package:professor_avalia/features/turma/turma_repository.dart';

// ── Fixtures ─────────────────────────────────────────────────────────────────

const _tur01 = {
  'id': 'tur_01',
  'escola_id': 'esc_01',
  'nome': '5º Ano A',
  'serie': '5',
  'turno': 'matutino',
  'ano_letivo': 2025,
  'total_alunos': 3,
  'ativo': true,
};

const _tur02 = {
  'id': 'tur_02',
  'escola_id': 'esc_01',
  'nome': '5º Ano B',
  'serie': '5',
  'turno': 'vespertino',
  'ano_letivo': 2025,
  'total_alunos': 2,
  'ativo': true,
};

const _tur03 = {
  'id': 'tur_03',
  'escola_id': 'esc_02',
  'nome': '6º Ano A',
  'serie': '6',
  'turno': 'matutino',
  'ano_letivo': 2025,
  'total_alunos': 1,
  'ativo': true,
};

const _tur05Inativa = {
  'id': 'tur_05',
  'escola_id': 'esc_01',
  'nome': '9º Ano Único',
  'serie': '9',
  'turno': 'noturno',
  'ano_letivo': 2025,
  'total_alunos': 0,
  'ativo': false,
};

TurmaRepository _repoWith(List<Map<String, dynamic>> data) =>
    TurmaRepository(jsonLoader: (_) async => jsonEncode(data));

// ── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('TurmaRepository.fetchByEscolaAndProfessor()', () {
    test('retorna turmas filtradas por escolaId E turmaIds do professor', () async {
      final repo = _repoWith([_tur01, _tur02, _tur03]);

      final result = await repo.fetchByEscolaAndProfessor(
        'esc_01',
        ['tur_01', 'tur_02'],
      );

      expect(result, isA<Ok<List<TurmaModel>, Failure>>());
      final turmas = (result as Ok<List<TurmaModel>, Failure>).value;
      expect(turmas.length, 2);
      expect(turmas.map((t) => t.id), containsAll(['tur_01', 'tur_02']));
    });

    test('campos mapeados corretamente (snake_case → camelCase)', () async {
      final repo = _repoWith([_tur01]);

      final result = await repo.fetchByEscolaAndProfessor('esc_01', ['tur_01']);

      final turma = (result as Ok<List<TurmaModel>, Failure>).value.first;
      expect(turma.id, 'tur_01');
      expect(turma.escolaId, 'esc_01');
      expect(turma.nome, '5º Ano A');
      expect(turma.serie, '5');
      expect(turma.turno, 'matutino');
      expect(turma.anoLetivo, 2025);
      expect(turma.totalAlunos, 3);
      expect(turma.ativo, isTrue);
    });

    test('turma de outra escola é excluída mesmo se ID do professor contém', () async {
      final repo = _repoWith([_tur01, _tur03]);

      // Professor tem tur_01 e tur_03, mas filtramos por esc_01 — tur_03 é esc_02
      final result = await repo.fetchByEscolaAndProfessor(
        'esc_01',
        ['tur_01', 'tur_03'],
      );

      final turmas = (result as Ok<List<TurmaModel>, Failure>).value;
      expect(turmas.length, 1);
      expect(turmas.first.id, 'tur_01');
    });

    test('turma ativa mas fora do turmaIds do professor é excluída', () async {
      final repo = _repoWith([_tur01, _tur02]);

      // Professor só tem acesso a tur_01
      final result = await repo.fetchByEscolaAndProfessor('esc_01', ['tur_01']);

      final turmas = (result as Ok<List<TurmaModel>, Failure>).value;
      expect(turmas.length, 1);
      expect(turmas.first.id, 'tur_01');
    });

    test('turma inativa é excluída do resultado', () async {
      final repo = _repoWith([_tur01, _tur05Inativa]);

      final result = await repo.fetchByEscolaAndProfessor(
        'esc_01',
        ['tur_01', 'tur_05'],
      );

      final turmas = (result as Ok<List<TurmaModel>, Failure>).value;
      expect(turmas.length, 1);
      expect(turmas.first.id, 'tur_01');
    });

    test('lista de turmaIds vazia → Err(NotFoundFailure)', () async {
      final repo = _repoWith([_tur01]);

      final result = await repo.fetchByEscolaAndProfessor('esc_01', []);

      expect(result, isA<Err<List<TurmaModel>, Failure>>());
      expect(
        (result as Err<List<TurmaModel>, Failure>).error,
        isA<NotFoundFailure>(),
      );
    });

    test('nenhuma turma coincide → Err(NotFoundFailure)', () async {
      final repo = _repoWith([_tur01, _tur02]);

      final result = await repo.fetchByEscolaAndProfessor(
        'esc_99', // escola inexistente
        ['tur_01'],
      );

      expect(result, isA<Err<List<TurmaModel>, Failure>>());
      expect(
        (result as Err<List<TurmaModel>, Failure>).error,
        isA<NotFoundFailure>(),
      );
    });

    test('JSON malformado → Err(ParseFailure)', () async {
      final repo = TurmaRepository(jsonLoader: (_) async => 'não é JSON');

      final result = await repo.fetchByEscolaAndProfessor('esc_01', ['tur_01']);

      expect(result, isA<Err<List<TurmaModel>, Failure>>());
      expect(
        (result as Err<List<TurmaModel>, Failure>).error,
        isA<ParseFailure>(),
      );
    });
  });
}
