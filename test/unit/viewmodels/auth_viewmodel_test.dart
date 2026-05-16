import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:professor_avalia/core/constants/app_constants.dart';
import 'package:professor_avalia/core/error/failures.dart';
import 'package:professor_avalia/core/error/result.dart';
import 'package:professor_avalia/features/auth/auth_repository.dart';
import 'package:professor_avalia/features/auth/auth_viewmodel.dart';
import 'package:professor_avalia/features/auth/login_credentials.dart';
import 'package:professor_avalia/features/auth/model/auth_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

const _fakeProfessor = ProfessorModel(
  id: 'prof_01',
  nome: 'Carlos Alcântara',
  email: 'professor_alcantara@demo.com',
  escolaIds: ['esc_01', 'esc_02'],
  turmaIds: ['tur_01', 'tur_02'],
);

/// Cria um [ProviderContainer] com o repositório mockado.
ProviderContainer _makeContainer(MockAuthRepository repo) =>
    ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );

void main() {
  // Necessário para FlutterSecureStorage usar canais de plataforma em testes.
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  // Registra fallback para any() funcionar com LoginCredentials.
  setUpAll(() {
    registerFallbackValue(
      const LoginCredentials(email: '', senha: ''),
    );
  });

  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    // Reseta o storage mockado antes de cada teste.
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthViewModel.build() — restauração de sessão', () {
    test('sem sessão persistida → AsyncData(null)', () async {
      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      final state = await container.read(authViewModelProvider.future);
      expect(state, isNull);
    });

    test('sessão válida persistida → AsyncData(ProfessorModel)', () async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.storageKeyProfessorId: 'prof_01',
      });
      when(() => mockRepo.findById('prof_01'))
          .thenAnswer((_) async => const Ok(_fakeProfessor));

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      final state = await container.read(authViewModelProvider.future);
      expect(state, equals(_fakeProfessor));
    });

    test('sessão corrompida → limpa storage e retorna null', () async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.storageKeyProfessorId: 'prof_invalido',
      });
      when(() => mockRepo.findById('prof_invalido'))
          .thenAnswer((_) async => const Err(NotFoundFailure()));

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      final state = await container.read(authViewModelProvider.future);
      expect(state, isNull);

      const storage = FlutterSecureStorage();
      final storedId = await storage.read(
        key: AppConstants.storageKeyProfessorId,
      );
      expect(storedId, isNull);
    });
  });

  group('AuthViewModel.login()', () {
    test('credenciais válidas → AsyncData(professor) + id persistido', () async {
      when(() => mockRepo.login(any()))
          .thenAnswer((_) async => const Ok(_fakeProfessor));

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      // Aguarda build() completar.
      await container.read(authViewModelProvider.future);

      await container
          .read(authViewModelProvider.notifier)
          .login(
            const LoginCredentials(
              email: 'professor_alcantara@demo.com',
              senha: 'teste@1234',
            ),
          );

      final state = container.read(authViewModelProvider);
      expect(state.value, equals(_fakeProfessor));

      const storage = FlutterSecureStorage();
      final storedId = await storage.read(
        key: AppConstants.storageKeyProfessorId,
      );
      expect(storedId, 'prof_01');
    });

    test('credenciais inválidas → AsyncError(AuthFailure)', () async {
      when(() => mockRepo.login(any()))
          .thenAnswer(
            (_) async => const Err(AuthFailure('Senha incorreta.')),
          );

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      await container.read(authViewModelProvider.future);

      await container
          .read(authViewModelProvider.notifier)
          .login(const LoginCredentials(email: 'x@x.com', senha: 'errada'));

      final state = container.read(authViewModelProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<AuthFailure>());
    });

    test('falha de parse → AsyncError(ParseFailure)', () async {
      when(() => mockRepo.login(any()))
          .thenAnswer((_) async => const Err(ParseFailure()));

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      await container.read(authViewModelProvider.future);

      await container
          .read(authViewModelProvider.notifier)
          .login(const LoginCredentials(email: 'x@x.com', senha: 'qualquer'));

      final state = container.read(authViewModelProvider);
      expect(state.error, isA<ParseFailure>());
    });
  });

  group('AuthViewModel.logout()', () {
    test('limpa storage e retorna AsyncData(null)', () async {
      when(() => mockRepo.login(any()))
          .thenAnswer((_) async => const Ok(_fakeProfessor));

      final container = _makeContainer(mockRepo);
      addTearDown(container.dispose);

      await container.read(authViewModelProvider.future);

      // Faz login primeiro.
      await container
          .read(authViewModelProvider.notifier)
          .login(const LoginCredentials(email: 'x@x.com', senha: 'x'));
      expect(container.read(authViewModelProvider).value, isNotNull);

      // Faz logout.
      await container.read(authViewModelProvider.notifier).logout();

      expect(container.read(authViewModelProvider).value, isNull);

      const storage = FlutterSecureStorage();
      final storedId = await storage.read(
        key: AppConstants.storageKeyProfessorId,
      );
      expect(storedId, isNull);
    });
  });
}
