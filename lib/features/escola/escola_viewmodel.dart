import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/result.dart';
import '../auth/auth_viewmodel.dart';
import 'escola_repository.dart';
import 'model/escola_model.dart';

final escolaRepositoryProvider = Provider<EscolaRepository>(
  (_) => const EscolaRepository(),
);

final escolaViewModelProvider =
    AsyncNotifierProvider<EscolaViewModel, List<EscolaModel>>(
      EscolaViewModel.new,
    );

class EscolaViewModel extends AsyncNotifier<List<EscolaModel>> {
  @override
  Future<List<EscolaModel>> build() async {
    final professor = ref.watch(authViewModelProvider).valueOrNull;
    if (professor == null) return [];

    final result = await ref
        .read(escolaRepositoryProvider)
        .fetchByProfessor(professor.escolaIds);

    return switch (result) {
      Ok(:final value) => value,
      Err(:final error) => throw error,
    };
  }
}
