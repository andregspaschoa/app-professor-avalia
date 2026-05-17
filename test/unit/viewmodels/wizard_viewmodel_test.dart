import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/features/wizard/wizard_viewmodel.dart';

ProviderContainer _makeContainer() => ProviderContainer();

void main() {
  group('WizardViewModel — estado inicial', () {
    test('step inicial é 1 e todos os IDs são null', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(wizardViewModelProvider);

      expect(state.step, 1);
      expect(state.escolaId, isNull);
      expect(state.turmaId, isNull);
      expect(state.avaliacaoId, isNull);
    });
  });

  group('WizardViewModel.setEscola()', () {
    test('define escolaId e avança para step 2', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      container.read(wizardViewModelProvider.notifier).setEscola('esc_01');
      final state = container.read(wizardViewModelProvider);

      expect(state.escolaId, 'esc_01');
      expect(state.step, 2);
    });

    test('trocar escola limpa turmaId e avaliacaoId', () {
      final container = _makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(wizardViewModelProvider.notifier);

      notifier.setEscola('esc_01');
      notifier.setTurma('tur_01');
      notifier.setAvaliacao('ava_01');
      notifier.setEscola('esc_02'); // troca de escola

      final state = container.read(wizardViewModelProvider);
      expect(state.escolaId, 'esc_02');
      expect(state.turmaId, isNull);
      expect(state.avaliacaoId, isNull);
      expect(state.step, 2);
    });
  });

  group('WizardViewModel.setTurma()', () {
    test('define turmaId e avança para step 3, preserva escolaId', () {
      final container = _makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(wizardViewModelProvider.notifier);

      notifier.setEscola('esc_01');
      notifier.setTurma('tur_01');
      final state = container.read(wizardViewModelProvider);

      expect(state.turmaId, 'tur_01');
      expect(state.escolaId, 'esc_01');
      expect(state.step, 3);
    });
  });

  group('WizardViewModel.setAvaliacao()', () {
    test('define avaliacaoId e avança para step 4, preserva campos anteriores', () {
      final container = _makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(wizardViewModelProvider.notifier);

      notifier.setEscola('esc_01');
      notifier.setTurma('tur_01');
      notifier.setAvaliacao('ava_01');
      final state = container.read(wizardViewModelProvider);

      expect(state.avaliacaoId, 'ava_01');
      expect(state.turmaId, 'tur_01');
      expect(state.escolaId, 'esc_01');
      expect(state.step, 4);
    });
  });

  group('WizardViewModel.advanceToStep()', () {
    test('avança step sem modificar os IDs', () {
      final container = _makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(wizardViewModelProvider.notifier);

      notifier.setEscola('esc_01');
      notifier.setTurma('tur_01');
      notifier.advanceToStep(5);
      final state = container.read(wizardViewModelProvider);

      expect(state.step, 5);
      expect(state.escolaId, 'esc_01');
      expect(state.turmaId, 'tur_01');
    });
  });

  group('WizardViewModel.reset()', () {
    test('restaura estado inicial completo após fluxo completo', () {
      final container = _makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(wizardViewModelProvider.notifier);

      notifier.setEscola('esc_01');
      notifier.setTurma('tur_01');
      notifier.setAvaliacao('ava_01');
      notifier.reset();
      final state = container.read(wizardViewModelProvider);

      expect(state.step, 1);
      expect(state.escolaId, isNull);
      expect(state.turmaId, isNull);
      expect(state.avaliacaoId, isNull);
    });
  });

  group('WizardViewModel — fluxo completo Escola → Turma → Avaliação', () {
    test('transitions de step seguem a sequência 1 → 2 → 3 → 4', () {
      final container = _makeContainer();
      addTearDown(container.dispose);
      final notifier = container.read(wizardViewModelProvider.notifier);

      expect(container.read(wizardViewModelProvider).step, 1);
      notifier.setEscola('esc_01');
      expect(container.read(wizardViewModelProvider).step, 2);
      notifier.setTurma('tur_01');
      expect(container.read(wizardViewModelProvider).step, 3);
      notifier.setAvaliacao('ava_01');
      expect(container.read(wizardViewModelProvider).step, 4);
    });
  });
}
