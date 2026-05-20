import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:professor_avalia/core/constants/app_constants.dart';
import 'package:professor_avalia/features/dashboard/dashboard_repository.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;

  setUp(() async {
    tempDir =
        await Directory.systemTemp.createTemp('hive_dashboard_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>(AppConstants.hiveBoxScans);
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  const repo = DashboardRepository();

  group('DashboardRepository.load()', () {
    test('box vazia → DashboardStats.empty, sem lançar exceção', () {
      final stats = repo.load();

      expect(stats.totalCorrigidos, 0);
      expect(stats.mediaTurma, 0.0);
      expect(stats.questaoCritica, isNull);
      expect(stats.scansRecentes, isEmpty);
      expect(stats.avaliacoesRecentes, isEmpty);
    });

    test('3 scans com notas 8, 6, 10 → mediaTurma ≈ 8.0', () async {
      for (final nota in [8.0, 6.0, 10.0]) {
        await box.add(<String, dynamic>{
          'nota_calculada': nota,
          'avaliacao_id': 'ava_01',
          'avaliacao_titulo': 'Prova 1',
          'escola_nome': 'Escola A',
          'turma_nome': '3A',
          'created_at': '2025-01-01T10:00:00.000Z',
          'gabarito': ['A', 'B', 'C'],
          'respostas_aluno': ['A', 'B', 'C'],
        });
      }

      final stats = repo.load();

      expect(stats.totalCorrigidos, 3);
      expect(stats.mediaTurma, closeTo(8.0, 0.001));
    });

    test('questão crítica — 1-based, identifica a questão com mais erros',
        () async {
      // Q1: 1 erro (scan 1); Q2: 2 erros (scan 1 e 2) → crítica = 2
      await box.add(<String, dynamic>{
        'nota_calculada': 5.0,
        'avaliacao_id': 'ava_01',
        'created_at': '2025-01-01T10:00:00.000Z',
        'gabarito': ['A', 'B'],
        'respostas_aluno': ['B', 'A'], // Q1 errou, Q2 errou
      });
      await box.add(<String, dynamic>{
        'nota_calculada': 5.0,
        'avaliacao_id': 'ava_01',
        'created_at': '2025-01-02T10:00:00.000Z',
        'gabarito': ['A', 'B'],
        'respostas_aluno': ['A', 'A'], // Q1 acertou, Q2 errou
      });

      final stats = repo.load();

      // Q2 (índice 1, 1-based = 2) acumula 2 erros; Q1 acumula 1.
      expect(stats.questaoCritica, 2);
    });

    test('scansRecentes limitado a 20 registros quando há mais de 20 scans',
        () async {
      for (var i = 0; i < 25; i++) {
        final day = (i + 1).toString().padLeft(2, '0');
        await box.add(<String, dynamic>{
          'nota_calculada': 7.0,
          'avaliacao_id': 'ava_01',
          'created_at': '2025-01-${day}T10:00:00.000Z',
          'gabarito': ['A'],
          'respostas_aluno': ['A'],
        });
      }

      final stats = repo.load();

      expect(stats.totalCorrigidos, 25);
      expect(stats.scansRecentes, hasLength(20));
    });
  });
}
