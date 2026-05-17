import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/core/error/failures.dart';
import 'package:professor_avalia/core/error/result.dart';
import 'package:professor_avalia/features/avaliacao/avaliacao_repository.dart';
import 'package:professor_avalia/features/avaliacao/model/avaliacao_model.dart';

// ── Fixtures ─────────────────────────────────────────────────────────────────

const _ava01 = {
  'id': 'ava_01',
  'turma_id': 'tur_01',
  'professor_id': 'prof_01',
  'titulo': 'Prova Bimestral - Matemática',
  'disciplina': 'Matemática',
  'bimestre': 1,
  'tipo': 'objetiva',
  'data_aplicacao': '2025-03-15',
  'total_questoes': 10,
  'nota_maxima': 10.0,
  'peso_por_questao': 1.0,
  'status': 'aplicada',
  'gabarito': ['C', 'B', 'D', 'A', 'E', 'B', 'C', 'D', 'A', 'B'],
  'created_at': '2025-03-10T08:00:00Z',
  'updated_at': '2025-03-15T14:00:00Z',
};

const _ava02 = {
  'id': 'ava_02',
  'turma_id': 'tur_01',
  'professor_id': 'prof_01',
  'titulo': 'Simulado - Português',
  'disciplina': 'Português',
  'bimestre': 1,
  'tipo': 'objetiva',
  'data_aplicacao': '2025-04-10',
  'total_questoes': 8,
  'nota_maxima': 10.0,
  'peso_por_questao': 1.25,
  'status': 'corrigida',
  'gabarito': ['B', 'C', 'A', 'D', 'B', 'C', 'A', 'D'],
  'created_at': '2025-04-05T09:00:00Z',
  'updated_at': '2025-04-10T16:30:00Z',
};

const _ava03 = {
  'id': 'ava_03',
  'turma_id': 'tur_02',
  'professor_id': 'prof_01',
  'titulo': 'Prova Bimestral - Ciências',
  'disciplina': 'Ciências',
  'bimestre': 1,
  'tipo': 'objetiva',
  'data_aplicacao': '2025-03-20',
  'total_questoes': 10,
  'nota_maxima': 10.0,
  'peso_por_questao': 1.0,
  'status': 'rascunho',
  'gabarito': ['A', 'B', 'C', 'D', 'E', 'A', 'B', 'C', 'D', 'E'],
  'created_at': '2025-03-18T10:00:00Z',
  'updated_at': '2025-03-18T10:00:00Z',
};

AvaliacaoRepository _repoWith(List<Map<String, dynamic>> data) =>
    AvaliacaoRepository(jsonLoader: (_) async => jsonEncode(data));

// ── Testes ───────────────────────────────────────────────────────────────────

void main() {
  group('AvaliacaoRepository.fetchByTurma()', () {
    test('retorna apenas avaliações da turma solicitada', () async {
      final repo = _repoWith([_ava01, _ava02, _ava03]);

      final result = await repo.fetchByTurma('tur_01');

      expect(result, isA<Ok<List<AvaliacaoModel>, Failure>>());
      final avaliacoes = (result as Ok<List<AvaliacaoModel>, Failure>).value;
      expect(avaliacoes.length, 2);
      expect(avaliacoes.map((a) => a.id), containsAll(['ava_01', 'ava_02']));
    });

    test('campos mapeados corretamente (snake_case → camelCase)', () async {
      final repo = _repoWith([_ava01]);

      final result = await repo.fetchByTurma('tur_01');

      final ava = (result as Ok<List<AvaliacaoModel>, Failure>).value.first;
      expect(ava.id, 'ava_01');
      expect(ava.turmaId, 'tur_01');
      expect(ava.professorId, 'prof_01');
      expect(ava.titulo, 'Prova Bimestral - Matemática');
      expect(ava.disciplina, 'Matemática');
      expect(ava.bimestre, 1);
      expect(ava.totalQuestoes, 10);
      expect(ava.notaMaxima, 10.0);
      expect(ava.pesoPorQuestao, 1.0);
      expect(ava.status, 'aplicada');
      expect(ava.dataAplicacao, '2025-03-15');
    });

    test('gabarito é List<String> com as alternativas corretas', () async {
      final repo = _repoWith([_ava01]);

      final result = await repo.fetchByTurma('tur_01');

      final ava = (result as Ok<List<AvaliacaoModel>, Failure>).value.first;
      expect(ava.gabarito, ['C', 'B', 'D', 'A', 'E', 'B', 'C', 'D', 'A', 'B']);
      expect(ava.gabarito.length, ava.totalQuestoes);
    });

    test('avaliação de outra turma não aparece no resultado', () async {
      final repo = _repoWith([_ava01, _ava02, _ava03]);

      final result = await repo.fetchByTurma('tur_02');

      final avaliacoes = (result as Ok<List<AvaliacaoModel>, Failure>).value;
      expect(avaliacoes.length, 1);
      expect(avaliacoes.first.id, 'ava_03');
    });

    test('turmaId sem avaliações → Err(NotFoundFailure)', () async {
      final repo = _repoWith([_ava01, _ava02]);

      final result = await repo.fetchByTurma('tur_99');

      expect(result, isA<Err<List<AvaliacaoModel>, Failure>>());
      expect(
        (result as Err<List<AvaliacaoModel>, Failure>).error,
        isA<NotFoundFailure>(),
      );
    });

    test('JSON malformado → Err(ParseFailure)', () async {
      final repo = AvaliacaoRepository(jsonLoader: (_) async => 'não é JSON');

      final result = await repo.fetchByTurma('tur_01');

      expect(result, isA<Err<List<AvaliacaoModel>, Failure>>());
      expect(
        (result as Err<List<AvaliacaoModel>, Failure>).error,
        isA<ParseFailure>(),
      );
    });

    test('status rascunho/aplicada/corrigida são preservados', () async {
      final repo = _repoWith([_ava01, _ava02, _ava03]);

      final r1 = await repo.fetchByTurma('tur_01');
      final turma1 = (r1 as Ok<List<AvaliacaoModel>, Failure>).value;

      final r2 = await repo.fetchByTurma('tur_02');
      final turma2 = (r2 as Ok<List<AvaliacaoModel>, Failure>).value;

      final statuses = turma1.map((a) => a.status).toSet();
      expect(statuses, containsAll(['aplicada', 'corrigida']));
      expect(turma2.first.status, 'rascunho');
    });
  });
}
