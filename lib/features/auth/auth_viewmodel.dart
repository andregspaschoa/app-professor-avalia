import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/result.dart';
import 'auth_repository.dart';
import 'login_credentials.dart';
import 'model/auth_model.dart';

/// Provedor do [AuthRepository] — substituível em testes via override.
final authRepositoryProvider = Provider<AuthRepository>(
  (_) => const AuthRepository(),
);

/// Provedor do [AuthViewModel].
final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, ProfessorModel?>(AuthViewModel.new);

/// ViewModel de autenticação.
///
/// Estado: [AsyncValue<ProfessorModel?>]
///   - [AsyncLoading]      → verificando sessão / autenticando
///   - [AsyncData(null)]   → não autenticado
///   - [AsyncData(model)]  → autenticado
///   - [AsyncError]        → falha no último login
///
/// Ciclo de vida:
///   1. [build] verifica sessão persistida no [FlutterSecureStorage].
///   2. [login] autentica e persiste o id do professor.
///   3. [logout] limpa o storage e retorna ao estado não autenticado.
class AuthViewModel extends AsyncNotifier<ProfessorModel?> {
  static const _storage = FlutterSecureStorage();

  /// Restaura sessão do [FlutterSecureStorage] na inicialização do app.
  ///
  /// Retorna [null] se não houver sessão ativa ou se a sessão estiver
  /// corrompida (professor não encontrado no mock).
  @override
  Future<ProfessorModel?> build() async {
    final professorId = await _storage.read(
      key: AppConstants.storageKeyProfessorId,
    );
    if (professorId == null) return null;

    final result = await ref.read(authRepositoryProvider).findById(professorId);
    return switch (result) {
      Ok(:final value) => value,
      Err() => _clearCorruptedSession(),
    };
  }

  Future<ProfessorModel?> _clearCorruptedSession() async {
    await _storage.delete(key: AppConstants.storageKeyProfessorId);
    return null;
  }

  /// Autentica o professor com as [credentials] fornecidas.
  ///
  /// Emite [AsyncLoading] durante a tentativa. Em caso de sucesso,
  /// persiste o id e emite [AsyncData(professor)]. Em falha, emite
  /// [AsyncError(failure)] — a UI extrai a mensagem via [Failure.message].
  Future<void> login(LoginCredentials credentials) async {
    state = const AsyncLoading();
    final result = await ref.read(authRepositoryProvider).login(credentials);
    switch (result) {
      case Ok(:final value):
        await _storage.write(
          key: AppConstants.storageKeyProfessorId,
          value: value.id,
        );
        state = AsyncData(value);
      case Err(:final error):
        state = AsyncError(error, StackTrace.current);
    }
  }

  /// Remove a sessão e retorna ao estado não autenticado.
  Future<void> logout() async {
    await _storage.delete(key: AppConstants.storageKeyProfessorId);
    state = const AsyncData(null);
  }
}
