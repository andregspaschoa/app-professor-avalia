import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:professor_avalia/core/error/failures.dart';
import 'package:professor_avalia/core/error/result.dart';
import 'package:professor_avalia/features/auth/auth_repository.dart';
import 'package:professor_avalia/features/auth/login_credentials.dart';
import 'package:professor_avalia/features/auth/model/auth_model.dart';

// Fixture reutilizável — espelha `assets/mock/professores.json`.
const _validProfMap = {
  'id': 'prof_01',
  'nome': 'Carlos Alcântara',
  'email': 'professor_alcantara@demo.com',
  'senha_hash': 'teste@1234',
  'disciplinas': ['Matemática', 'Física'],
  'escola_ids': ['esc_01', 'esc_02'],
  'turma_ids': ['tur_01', 'tur_02'],
  'foto_url': null,
  'ativo': true,
  'created_at': '2025-01-10T08:00:00Z',
};

AuthRepository _repoWith(List<Map<String, dynamic>> data) =>
    AuthRepository(jsonLoader: (_) async => jsonEncode(data));

void main() {
  group('AuthRepository.login()', () {
    late AuthRepository sut;

    setUp(() => sut = _repoWith([_validProfMap]));

    test('credenciais válidas → Ok com campos corretos', () async {
      final result = await sut.login(
        const LoginCredentials(
          email: 'professor_alcantara@demo.com',
          senha: 'teste@1234',
        ),
      );

      expect(result, isA<Ok<ProfessorModel, Failure>>());
      final professor = (result as Ok<ProfessorModel, Failure>).value;
      expect(professor.id, 'prof_01');
      expect(professor.nome, 'Carlos Alcântara');
      expect(professor.escolaIds, containsAll(['esc_01', 'esc_02']));
    });

    test('e-mail em maiúsculas é aceito (case-insensitive)', () async {
      final result = await sut.login(
        const LoginCredentials(
          email: 'PROFESSOR_ALCANTARA@DEMO.COM',
          senha: 'teste@1234',
        ),
      );
      expect(result, isA<Ok<ProfessorModel, Failure>>());
    });

    test('e-mail com espaços extras é aceito (trim)', () async {
      final result = await sut.login(
        const LoginCredentials(
          email: '  professor_alcantara@demo.com  ',
          senha: 'teste@1234',
        ),
      );
      expect(result, isA<Ok<ProfessorModel, Failure>>());
    });

    test('e-mail não encontrado → Err(AuthFailure)', () async {
      final result = await sut.login(
        const LoginCredentials(
          email: 'naoexiste@demo.com',
          senha: 'teste@1234',
        ),
      );
      expect(result, isA<Err<ProfessorModel, Failure>>());
      expect((result as Err<ProfessorModel, Failure>).error, isA<AuthFailure>());
    });

    test('senha incorreta → Err(AuthFailure)', () async {
      final result = await sut.login(
        const LoginCredentials(
          email: 'professor_alcantara@demo.com',
          senha: 'senhaErrada',
        ),
      );
      expect(result, isA<Err<ProfessorModel, Failure>>());
      expect((result as Err<ProfessorModel, Failure>).error, isA<AuthFailure>());
    });

    test('conta inativa → Err(AuthFailure)', () async {
      sut = _repoWith([{..._validProfMap, 'ativo': false}]);
      final result = await sut.login(
        const LoginCredentials(
          email: 'professor_alcantara@demo.com',
          senha: 'teste@1234',
        ),
      );
      expect(result, isA<Err<ProfessorModel, Failure>>());
      expect((result as Err<ProfessorModel, Failure>).error, isA<AuthFailure>());
    });

    test('JSON malformado → Err(ParseFailure)', () async {
      sut = AuthRepository(jsonLoader: (_) async => '{{ json inválido }}');
      final result = await sut.login(
        const LoginCredentials(email: 'qualquer@test.com', senha: 'qualquer'),
      );
      expect(result, isA<Err<ProfessorModel, Failure>>());
      expect((result as Err<ProfessorModel, Failure>).error, isA<ParseFailure>());
    });
  });

  group('AuthRepository.findById()', () {
    late AuthRepository sut;

    setUp(() => sut = _repoWith([_validProfMap]));

    test('id válido → Ok com ProfessorModel correto', () async {
      final result = await sut.findById('prof_01');
      expect(result, isA<Ok<ProfessorModel, Failure>>());
      expect((result as Ok<ProfessorModel, Failure>).value.id, 'prof_01');
    });

    test('id inexistente → Err(NotFoundFailure)', () async {
      final result = await sut.findById('prof_99');
      expect(result, isA<Err<ProfessorModel, Failure>>());
      expect((result as Err<ProfessorModel, Failure>).error, isA<NotFoundFailure>());
    });

    test('JSON malformado → Err(ParseFailure)', () async {
      sut = AuthRepository(jsonLoader: (_) async => 'não é json');
      final result = await sut.findById('prof_01');
      expect(result, isA<Err<ProfessorModel, Failure>>());
      expect((result as Err<ProfessorModel, Failure>).error, isA<ParseFailure>());
    });
  });
}
