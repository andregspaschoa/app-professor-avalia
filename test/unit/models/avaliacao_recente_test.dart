import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/features/dashboard/model/avaliacao_recente.dart';

void main() {
  final _scan = <String, dynamic>{
    'aluno_id': 'al_01',
    'nota_calculada': 8.0,
  };

  final _avaliacao = AvaliacaoRecente(
    avaliacaoId: 'ava_01',
    avaliacaoTitulo: 'Prova de Matemática',
    escolaNome: 'Escola Alpha',
    turmaNome: '3A',
    totalAlunos: 30,
    mediaGeral: 7.5,
    dataUltimaCorrecao: DateTime(2025, 6, 1, 10, 0),
    scans: [_scan],
  );

  group('AvaliacaoRecente.toMap()', () {
    test('serializa todos os campos corretamente', () {
      final map = _avaliacao.toMap();

      expect(map['avaliacao_id'], 'ava_01');
      expect(map['avaliacao_titulo'], 'Prova de Matemática');
      expect(map['escola_nome'], 'Escola Alpha');
      expect(map['turma_nome'], '3A');
      expect(map['total_alunos'], 30);
      expect(map['media_geral'], 7.5);
      expect(map['data_ultima_correcao'], '2025-06-01T10:00:00.000');
      expect(map['scans'], [_scan]);
    });

    test('dataUltimaCorrecao null → campo null no mapa', () {
      final sem = AvaliacaoRecente(
        avaliacaoId: 'x',
        avaliacaoTitulo: '?',
        escolaNome: '?',
        turmaNome: '?',
        totalAlunos: 0,
        mediaGeral: 0,
        scans: const [],
      );
      expect(sem.toMap()['data_ultima_correcao'], isNull);
    });
  });

  group('AvaliacaoRecente.fromMap()', () {
    test('round-trip toMap → fromMap preserva todos os campos', () {
      final map = _avaliacao.toMap();
      final resultado = AvaliacaoRecente.fromMap(map);

      expect(resultado.avaliacaoId, _avaliacao.avaliacaoId);
      expect(resultado.avaliacaoTitulo, _avaliacao.avaliacaoTitulo);
      expect(resultado.escolaNome, _avaliacao.escolaNome);
      expect(resultado.turmaNome, _avaliacao.turmaNome);
      expect(resultado.totalAlunos, _avaliacao.totalAlunos);
      expect(resultado.mediaGeral, _avaliacao.mediaGeral);
      expect(resultado.dataUltimaCorrecao, _avaliacao.dataUltimaCorrecao);
      expect(resultado.scans.length, 1);
    });

    test('campos ausentes → valores padrão sem lançar', () {
      final resultado = AvaliacaoRecente.fromMap({});

      expect(resultado.avaliacaoId, '');
      expect(resultado.avaliacaoTitulo, '?');
      expect(resultado.escolaNome, '?');
      expect(resultado.turmaNome, '?');
      expect(resultado.totalAlunos, 0);
      expect(resultado.mediaGeral, 0.0);
      expect(resultado.dataUltimaCorrecao, isNull);
      expect(resultado.scans, isEmpty);
    });
  });
}
