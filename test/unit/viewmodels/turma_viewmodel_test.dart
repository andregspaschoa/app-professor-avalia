import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:professor_avalia/core/constants/app_constants.dart';
import 'package:professor_avalia/core/error/failures.dart';
import 'package:professor_avalia/core/error/result.dart';
import 'package:professor_avalia/features/auth/auth_repository.dart';
import 'package:professor_avalia/features/auth/auth_viewmodel.dart';
import 'package:professor_avalia/features/auth/model/auth_model.dart';
import 'package:professor_avalia/features/turma/model/turma_model.dart';
import 'package:professor_avalia/features/turma/turma_repository.dart';
import 'package:professor_avalia/features/turma/turma_viewmodel.dart';
import 'package:professor_avalia/features/wizard/wizard_viewmodel.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockTurmaRepo extends Mock implements TurmaRepository {}

const _professor = ProfessorModel(
  id: 'prof_01',
  nome: 'Carlos',
  email: 'carlos@demo.com',
  escolaIds: ['esc_01'],
  turmaIds: ['tur_01'],
);

const _turma = TurmaModel(
  id: 'tur_01',
  escolaId: 'esc_01',
  nome: '3A',
  serie: '3º Ano',
  turno: 'matutino',
  anoLetivo: 2025,
  totalAlunos: 30,
);

ProviderContainer _makeContainer({
  required _MockAuthRepo authRepo,
  required _MockTurmaRepo turmaRepo,
}) =>
    ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        turmaRepositoryProvider.overrideWithValue(turmaRepo),
      ],
    );

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  setUpAll(() => registerFallbackValue(<String>[]));

  late _MockAuthRepo mockAuth;
  late _MockTurmaRepo mockTurma;

  setUp(() {
    mockAuth = _MockAuthRepo();
    mockTurma = _MockTurmaRepo();
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('TurmaViewModel — guardas de null', () {
    test('escolaId null (wizard inicial) → AsyncData([])', () async {
      // Sem escola no wizard e sem professor.
      final container = _makeContainer(authRepo: mockAuth, turmaRepo: mockTurma);
      addTearDown(container.dispose);

      // Aguarda auth para evitar race condition com wizard vazio.
      await container.read(authViewModelProvider.future);

      final result = await container.read(turmaViewModelProvider.future);
      expect(result, isEmpty);
      verifyNever(() => mockTurma.fetchByEscolaAndProfessor(any(), any()));
    });

    test('escola definida mas professor null → AsyncData([])', () async {
      // Sem sessão → auth resolve null.
      final container = _makeContainer(authRepo: mockAuth, turmaRepo: mockTurma);
      addTearDown(container.dispose);

      // Aguarda auth resolver (null) antes de definir escola.
      await container.read(authViewModelProvider.future);
      container
          .read(wizardViewModelProvider.notifier)
          .setEscola('esc_01', 'Escola 01');

      final result = await container.read(turmaViewModelProvider.future);
      expect(result, isEmpty);
      verifyNever(() => mockTurma.fetchByEscolaAndProfessor(any(), any()));
    });
  });

  group('TurmaViewModel — fluxo com professor autenticado', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.storageKeyProfessorId: 'prof_01',
      });
      when(() => mockAuth.findById('prof_01'))
          .thenAnswer((_) async => const Ok(_professor));
    });

    test('escola + professor com turmaIds → AsyncData(lista)', () async {
      when(
        () => mockTurma.fetchByEscolaAndProfessor('esc_01', ['tur_01']),
      ).thenAnswer((_) async => const Ok([_turma]));

      final container = _makeContainer(authRepo: mockAuth, turmaRepo: mockTurma);
      addTearDown(container.dispose);

      // Garante que auth está resolvido antes de disparar o build da turma.
      await container.read(authViewModelProvider.future);
      container
          .read(wizardViewModelProvider.notifier)
          .setEscola('esc_01', 'Escola 01');

      final result = await container.read(turmaViewModelProvider.future);
      expect(result, [_turma]);
    });

    test('repositório retorna Err → AsyncError com NotFoundFailure', () async {
      when(
        () => mockTurma.fetchByEscolaAndProfessor(any(), any()),
      ).thenAnswer((_) async => const Err(NotFoundFailure()));

      final container = _makeContainer(authRepo: mockAuth, turmaRepo: mockTurma);
      addTearDown(container.dispose);

      await container.read(authViewModelProvider.future);
      container
          .read(wizardViewModelProvider.notifier)
          .setEscola('esc_01', 'Escola 01');

      await expectLater(
        container.read(turmaViewModelProvider.future),
        throwsA(isA<NotFoundFailure>()),
      );
    });
  });
}
