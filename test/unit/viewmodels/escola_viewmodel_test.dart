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
import 'package:professor_avalia/features/escola/escola_repository.dart';
import 'package:professor_avalia/features/escola/escola_viewmodel.dart';
import 'package:professor_avalia/features/escola/model/escola_model.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockEscolaRepo extends Mock implements EscolaRepository {}

const _professor = ProfessorModel(
  id: 'prof_01',
  nome: 'Carlos',
  email: 'carlos@demo.com',
  escolaIds: ['esc_01'],
  turmaIds: ['tur_01'],
);

const _escola = EscolaModel(
  id: 'esc_01',
  nome: 'Escola Teste',
  codigoInep: '12345678',
  municipio: 'São Paulo',
  uf: 'SP',
  tipo: 'municipal',
);

ProviderContainer _makeContainer({
  required _MockAuthRepo authRepo,
  required _MockEscolaRepo escolaRepo,
}) =>
    ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        escolaRepositoryProvider.overrideWithValue(escolaRepo),
      ],
    );

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  setUpAll(() => registerFallbackValue(<String>[]));

  late _MockAuthRepo mockAuth;
  late _MockEscolaRepo mockEscola;

  setUp(() {
    mockAuth = _MockAuthRepo();
    mockEscola = _MockEscolaRepo();
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('EscolaViewModel', () {
    test('professor null (sem sessão) → AsyncData([])', () async {
      // Sem professor_id no storage → auth resolve null → escola retorna [].
      final container = _makeContainer(authRepo: mockAuth, escolaRepo: mockEscola);
      addTearDown(container.dispose);

      // Aguarda auth resolver antes de ler escola para evitar race condition.
      await container.read(authViewModelProvider.future);

      final result = await container.read(escolaViewModelProvider.future);
      expect(result, isEmpty);
      verifyNever(() => mockEscola.fetchByProfessor(any()));
    });

    test('professor com escolaIds → repositório chamado → AsyncData(lista)', () async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.storageKeyProfessorId: 'prof_01',
      });
      when(() => mockAuth.findById('prof_01'))
          .thenAnswer((_) async => const Ok(_professor));
      when(() => mockEscola.fetchByProfessor(['esc_01']))
          .thenAnswer((_) async => const Ok([_escola]));

      final container = _makeContainer(authRepo: mockAuth, escolaRepo: mockEscola);
      addTearDown(container.dispose);

      // Aguarda auth resolver antes de ler escola.
      await container.read(authViewModelProvider.future);

      final result = await container.read(escolaViewModelProvider.future);
      expect(result, [_escola]);
    });

    test('repositório retorna Err → AsyncError com NotFoundFailure', () async {
      FlutterSecureStorage.setMockInitialValues({
        AppConstants.storageKeyProfessorId: 'prof_01',
      });
      when(() => mockAuth.findById('prof_01'))
          .thenAnswer((_) async => const Ok(_professor));
      when(() => mockEscola.fetchByProfessor(any()))
          .thenAnswer((_) async => const Err(NotFoundFailure()));

      final container = _makeContainer(authRepo: mockAuth, escolaRepo: mockEscola);
      addTearDown(container.dispose);

      // Aguarda auth resolver antes de ler escola.
      await container.read(authViewModelProvider.future);

      await expectLater(
        container.read(escolaViewModelProvider.future),
        throwsA(isA<NotFoundFailure>()),
      );
    });
  });
}
