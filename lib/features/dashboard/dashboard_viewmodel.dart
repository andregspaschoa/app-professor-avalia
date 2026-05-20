import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_repository.dart';
import 'model/dashboard_stats.dart';

/// Gerencia o estado do dashboard.
///
/// Expõe [DashboardStats] carregado do [DashboardRepository].
/// Chame [refresh()] sempre que entrar na HomeScreen para garantir dados atualizados.
class DashboardViewModel extends AutoDisposeNotifier<DashboardStats> {
  @override
  DashboardStats build() {
    // Carrega imediatamente ao ser criado (primeira leitura do Hive).
    return _repository.load();
  }

  DashboardRepository get _repository => const DashboardRepository();

  /// Recarrega as métricas do Hive — chamar ao entrar na HomeScreen
  /// e após salvar um novo scan.
  void refresh() {
    state = _repository.load();
  }
}

/// autoDispose garante que o provider seja recriado sempre que HomeScreen
/// entra novamente na árvore de widgets — dados sempre frescos sem precisar
/// de chamadas manuais a refresh() no ponto de entrada.
final dashboardViewModelProvider =
    NotifierProvider.autoDispose<DashboardViewModel, DashboardStats>(
  DashboardViewModel.new,
);
