import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/result.dart';
import '../wizard/wizard_viewmodel.dart';
import 'aluno_repository.dart';
import 'model/aluno_model.dart';

final alunoRepositoryProvider = Provider<AlunoRepository>(
  (_) => const AlunoRepository(),
);

// ── State ─────────────────────────────────────────────────────────────────────

class GabaritoState {
  const GabaritoState({
    this.alunos = const [],
    this.currentIndex = 0,
    this.respostas = const {},
    this.loading = true,
    this.errorMessage,
  });

  final List<AlunoModel> alunos;
  final int currentIndex;

  /// Mapa alunoId → lista de alternativas escolhidas (null = não respondida).
  final Map<String, List<String?>> respostas;

  final bool loading;
  final String? errorMessage;

  bool get isUltimoAluno =>
      alunos.isNotEmpty && currentIndex == alunos.length - 1;

  bool get isFirstAluno => currentIndex == 0;

  AlunoModel? get currentAluno =>
      alunos.isEmpty ? null : alunos[currentIndex];

  List<String?> get currentRespostas {
    final aluno = currentAluno;
    if (aluno == null) return [];
    return respostas[aluno.id] ?? [];
  }

  GabaritoState copyWith({
    List<AlunoModel>? alunos,
    int? currentIndex,
    Map<String, List<String?>>? respostas,
    bool? loading,
    Object? errorMessage = _sentinel,
  }) {
    return GabaritoState(
      alunos: alunos ?? this.alunos,
      currentIndex: currentIndex ?? this.currentIndex,
      respostas: respostas ?? this.respostas,
      loading: loading ?? this.loading,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const _sentinel = Object();

// ── Notifier ──────────────────────────────────────────────────────────────────

class GabaritoViewModel extends Notifier<GabaritoState> {
  @override
  GabaritoState build() {
    final turmaId = ref.watch(
      wizardViewModelProvider.select((s) => s.turmaId),
    );
    _loadAlunos(turmaId);
    return const GabaritoState();
  }

  Future<void> _loadAlunos(String? turmaId) async {
    if (turmaId == null) {
      state = state.copyWith(loading: false, errorMessage: 'Turma não selecionada.');
      return;
    }
    final result = await ref.read(alunoRepositoryProvider).fetchByTurma(turmaId);
    switch (result) {
      case Ok(:final value):
        final respostas = {for (final a in value) a.id: <String?>[]};
        state = state.copyWith(alunos: value, respostas: respostas, loading: false);
      case Err(:final error):
        state = state.copyWith(loading: false, errorMessage: error.message);
    }
  }

  /// Seleciona ou deseleciona a [alternativa] na [questao] (0-based)
  /// para o aluno atual. Tocar na mesma alternativa já selecionada desfaz.
  void setResposta(int questao, String alternativa) {
    final aluno = state.currentAluno;
    if (aluno == null) return;

    final atual = List<String?>.from(state.respostas[aluno.id] ?? []);
    // Garante tamanho suficiente
    while (atual.length <= questao) {
      atual.add(null);
    }
    // Toggle: deseleciona se já estava marcada
    atual[questao] = atual[questao] == alternativa ? null : alternativa;

    state = state.copyWith(
      respostas: {...state.respostas, aluno.id: atual},
    );
  }

  /// Aplica uma lista de respostas geradas pelo scanner para o aluno atual.
  void setRespostasFromScan(List<String> scanResult) {
    final aluno = state.currentAluno;
    if (aluno == null) return;
    state = state.copyWith(
      respostas: {...state.respostas, aluno.id: List<String?>.from(scanResult)},
    );
  }

  void proximoAluno() {
    if (!state.isUltimoAluno) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void alunoAnterior() {
    if (!state.isFirstAluno) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  /// Retorna true se todas as questões do [alunoId] estão respondidas.
  bool isAlunoCompleto(String alunoId, int totalQuestoes) {
    final resp = state.respostas[alunoId] ?? [];
    if (resp.length < totalQuestoes) return false;
    return resp.every((r) => r != null);
  }

  /// Reseta para o primeiro aluno (usado após o fluxo completo).
  void reset() {
    state = const GabaritoState(loading: false);
    _loadAlunos(ref.read(wizardViewModelProvider).turmaId);
  }
}

final gabaritoViewModelProvider =
    NotifierProvider<GabaritoViewModel, GabaritoState>(GabaritoViewModel.new);
