import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/result.dart';
import '../auth/auth_viewmodel.dart';
import '../wizard/wizard_viewmodel.dart';
import 'model/turma_model.dart';
import 'turma_repository.dart';

final turmaRepositoryProvider = Provider<TurmaRepository>(
  (_) => const TurmaRepository(),
);

final turmaViewModelProvider =
    AsyncNotifierProvider<TurmaViewModel, List<TurmaModel>>(
      TurmaViewModel.new,
    );

class TurmaViewModel extends AsyncNotifier<List<TurmaModel>> {
  @override
  Future<List<TurmaModel>> build() async {
    final wizardState = ref.watch(wizardViewModelProvider);
    final escolaId = wizardState.escolaId;
    if (escolaId == null) return [];

    final professor = ref.watch(authViewModelProvider).valueOrNull;
    if (professor == null) return [];

    final turmaIds = professor.turmaIds;
    if (turmaIds.isEmpty) return [];

    final result = await ref
        .read(turmaRepositoryProvider)
        .fetchByEscolaAndProfessor(escolaId, turmaIds);

    return switch (result) {
      Ok(:final value) => value,
      Err(:final error) => throw error,
    };
  }
}
