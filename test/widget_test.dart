import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:professor_avalia/app.dart';

void main() {
  testWidgets('ProfessorAvaliaApp smoke test — renderiza sem crash',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ProfessorAvaliaApp()),
    );
    // Verifica que o app renderizou (SplashScreen está na árvore).
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
