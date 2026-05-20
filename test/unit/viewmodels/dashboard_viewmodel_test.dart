import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/features/dashboard/dashboard_viewmodel.dart';

void main() {
  group('DashboardViewModel', () {
    test('build() retorna DashboardStats.empty quando Hive não está aberto', () {
      // DashboardRepository.load() captura exceção e retorna .empty quando
      // o box do Hive não está inicializado.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final stats = container.read(dashboardViewModelProvider);

      expect(stats.totalCorrigidos, 0);
      expect(stats.mediaTurma, 0.0);
      expect(stats.questaoCritica, isNull);
      expect(stats.scansRecentes, isEmpty);
    });

    test('refresh() atualiza estado sem lançar exceção', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Leitura inicial — garante que o provider está ativo.
      container.read(dashboardViewModelProvider);

      // refresh() não deve lançar mesmo sem Hive aberto.
      expect(
        () => container.read(dashboardViewModelProvider.notifier).refresh(),
        returnsNormally,
      );

      final stats = container.read(dashboardViewModelProvider);
      expect(stats.totalCorrigidos, 0);
    });
  });
}
