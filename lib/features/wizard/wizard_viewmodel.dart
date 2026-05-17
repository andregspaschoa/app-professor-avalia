import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado global do wizard — preservado entre os steps.
///
/// Imutável por convenção: sempre use [copyWith] para gerar novas instâncias.
/// O step reflete em qual tela o wizard se encontra (1 = Escola … 6 = Respostas).
class WizardState {
  const WizardState({
    this.escolaId,
    this.turmaId,
    this.avaliacaoId,
    this.gabaritoConfirmado,
    this.step = 1,
  });

  /// ID da escola selecionada no step 1.
  final String? escolaId;

  /// ID da turma selecionada no step 2.
  final String? turmaId;

  /// ID da avaliação selecionada no step 3.
  final String? avaliacaoId;

  /// Gabarito confirmado pelo professor no step 5.
  /// Sobrepõe o gabarito padrão da avaliação para cálculo de notas.
  final List<String>? gabaritoConfirmado;

  /// Passo atual do wizard (1–6).
  final int step;

  WizardState copyWith({
    String? escolaId,
    String? turmaId,
    String? avaliacaoId,
    Object? gabaritoConfirmado = _sentinel,
    int? step,
  }) {
    return WizardState(
      escolaId: escolaId ?? this.escolaId,
      turmaId: turmaId ?? this.turmaId,
      avaliacaoId: avaliacaoId ?? this.avaliacaoId,
      gabaritoConfirmado: identical(gabaritoConfirmado, _sentinel)
          ? this.gabaritoConfirmado
          : gabaritoConfirmado as List<String>?,
      step: step ?? this.step,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WizardState &&
          runtimeType == other.runtimeType &&
          escolaId == other.escolaId &&
          turmaId == other.turmaId &&
          avaliacaoId == other.avaliacaoId &&
          step == other.step;

  @override
  int get hashCode =>
      Object.hash(escolaId, turmaId, avaliacaoId, step);
}

const _sentinel = Object();

/// ViewModel do wizard.
///
/// Gerencia o estado compartilhado entre todos os steps:
/// Escola → Turma → Avaliação → Gabarito → Resultado.
///
/// Uso nos steps:
/// ```dart
/// // Avançar para turma após selecionar escola:
/// ref.read(wizardViewModelProvider.notifier).setEscola(escolaId);
/// context.go(AppRoutes.wizardTurma);
/// ```
class WizardViewModel extends Notifier<WizardState> {
  @override
  WizardState build() => const WizardState();

  /// Registra a escola selecionada e avança para o step 2.
  ///
  /// Limpa os campos de turma e avaliação para evitar estado inconsistente
  /// caso o usuário volte e selecione uma escola diferente.
  void setEscola(String escolaId) {
    state = WizardState(escolaId: escolaId, step: 2);
  }

  /// Registra a turma selecionada e avança para o step 3.
  void setTurma(String turmaId) {
    state = state.copyWith(turmaId: turmaId, step: 3);
  }

  /// Registra a avaliação selecionada e avança para o step 4.
  void setAvaliacao(String avaliacaoId) {
    state = state.copyWith(avaliacaoId: avaliacaoId, step: 4);
  }

  /// Armazena o gabarito confirmado pelo professor (step 5) e avança para step 6.
  void setGabarito(List<String> gabarito) {
    state = state.copyWith(gabaritoConfirmado: gabarito, step: 6);
  }

  /// Avança ou retrocede manualmente o step.
  void advanceToStep(int step) {
    assert(step >= 1 && step <= 6, 'Step deve estar entre 1 e 6.');
    state = state.copyWith(step: step);
  }

  /// Reinicia o wizard — retorna ao estado inicial.
  ///
  /// Chamado ao concluir o fluxo completo ou ao pressionar "Nova avaliação".
  void reset() {
    state = const WizardState();
  }
}

/// Provedor global do [WizardViewModel].
///
/// Usando [NotifierProvider] manual (sem codegen) — estado síncrono, sem
/// necessidade de [AsyncNotifier]. Consistente com o padrão do projeto.
final wizardViewModelProvider =
    NotifierProvider<WizardViewModel, WizardState>(WizardViewModel.new);
