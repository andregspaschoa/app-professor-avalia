import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/result.dart';
import '../wizard/wizard_viewmodel.dart';
import 'avaliacao_repository.dart';
import 'model/avaliacao_model.dart';

final avaliacaoRepositoryProvider = Provider<AvaliacaoRepository>(
  (_) => const AvaliacaoRepository(),
);

final avaliacaoViewModelProvider =
    AsyncNotifierProvider<AvaliacaoViewModel, List<AvaliacaoModel>>(
      AvaliacaoViewModel.new,
    );

class AvaliacaoViewModel extends AsyncNotifier<List<AvaliacaoModel>> {
  @override
  Future<List<AvaliacaoModel>> build() async {
    final wizardState = ref.watch(wizardViewModelProvider);
    final turmaId = wizardState.turmaId;
    if (turmaId == null) return [];

    final result = await ref
        .read(avaliacaoRepositoryProvider)
        .fetchByTurma(turmaId);

    return switch (result) {
      Ok(:final value) => value,
      Err(:final error) => throw error,
    };
  }
}
