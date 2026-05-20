import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/shared/widgets/gabarito_grid.dart';

/// Cria o widget em isolamento dentro de um MaterialApp mínimo.
Widget _buildGrid({
  required int totalQuestoes,
  required List<String?> respostas,
  required void Function(int questao, String alternativa) onSelect,
  bool readOnly = false,
  List<String>? gabarito,
}) {
  return MaterialApp(
    home: Scaffold(
      body: GabaritoGrid(
        totalQuestoes: totalQuestoes,
        respostas: respostas,
        onSelect: onSelect,
        readOnly: readOnly,
        gabarito: gabarito,
      ),
    ),
  );
}

void main() {
  group('GabaritoGrid — renderização', () {
    testWidgets('exibe o número de cada questão', (tester) async {
      await tester.pumpWidget(
        _buildGrid(
          totalQuestoes: 5,
          respostas: List.filled(5, null),
          onSelect: (_, __) {},
        ),
      );

      for (var i = 1; i <= 5; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('renderiza alternativas A–E para cada questão', (tester) async {
      await tester.pumpWidget(
        _buildGrid(
          totalQuestoes: 2,
          respostas: [null, null],
          onSelect: (_, __) {},
        ),
      );

      // 2 questões × 5 alternativas = 2 ocorrências de cada letra.
      for (final alt in ['A', 'B', 'C', 'D', 'E']) {
        expect(find.text(alt), findsNWidgets(2));
      }
    });
  });

  group('GabaritoGrid — interação', () {
    testWidgets('tap em alternativa dispara onSelect com índice e alt corretos',
        (tester) async {
      int? capturedQuestao;
      String? capturedAlt;

      await tester.pumpWidget(
        _buildGrid(
          totalQuestoes: 3,
          respostas: List.filled(3, null),
          onSelect: (q, a) {
            capturedQuestao = q;
            capturedAlt = a;
          },
        ),
      );

      // Toca no primeiro botão 'B' — corresponde à questão 0.
      await tester.tap(find.text('B').first);
      await tester.pump();

      expect(capturedQuestao, 0);
      expect(capturedAlt, 'B');
    });

    testWidgets('readOnly=true — onSelect não é disparado ao tocar',
        (tester) async {
      var called = false;

      await tester.pumpWidget(
        _buildGrid(
          totalQuestoes: 2,
          respostas: ['A', null],
          readOnly: true,
          onSelect: (_, __) => called = true,
        ),
      );

      // Em modo readOnly, os chips não têm handler de toque.
      await tester.tap(find.text('A').first, warnIfMissed: false);
      await tester.pump();

      expect(called, isFalse);
    });

    testWidgets('gabarito correto em readOnly — questão acertada e errada renderizam',
        (tester) async {
      // Apenas verifica que o widget renderiza sem crash.
      await tester.pumpWidget(
        _buildGrid(
          totalQuestoes: 2,
          respostas: ['A', 'C'],          // Q1: acerto; Q2: erro
          readOnly: true,
          gabarito: ['A', 'B'],
          onSelect: (_, __) {},
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
