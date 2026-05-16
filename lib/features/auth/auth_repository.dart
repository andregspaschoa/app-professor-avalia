import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../core/error/result.dart';
import 'login_credentials.dart';
import 'model/auth_model.dart';

/// Função de carregamento de asset JSON — injetável para facilitar testes
/// unitários sem depender de [rootBundle] (plataforma Flutter).
typedef JsonLoader = Future<String> Function(String path);

/// Fonte de dados de autenticação para o MVP.
///
/// Lê `assets/mock/professores.json`, valida as credenciais e retorna
/// o [ProfessorModel] do professor autenticado — sem expor senha ou
/// dados sensíveis ao restante do app.
///
/// Contrato de retorno:
/// - [Ok<ProfessorModel>]       → operação bem-sucedida.
/// - [Err<AuthFailure>]         → e-mail não encontrado, senha inválida ou conta inativa.
/// - [Err<NotFoundFailure>]     → id de sessão não encontrado no mock.
/// - [Err<ParseFailure>]        → JSON malformado.
/// - [Err<UnexpectedFailure>]   → qualquer outro erro interno.
///
/// TODO(2.x): substituir por chamada real à API quando o backend estiver pronto.
/// A assinatura pública permanece idêntica — apenas a implementação muda.
class AuthRepository {
  const AuthRepository({this.jsonLoader});

  /// Injetável para testes — usa [rootBundle.loadString] por padrão em produção.
  final JsonLoader? jsonLoader;

  static const String _mockAssetPath = 'assets/mock/professores.json';

  Future<String> _load(String path) =>
      jsonLoader != null ? jsonLoader!(path) : rootBundle.loadString(path);

  /// Autentica o professor com as [credentials] fornecidas.
  ///
  /// Simula um delay de rede realista definido em [AppConstants.fakeNetworkDelay].
  ///
  /// Nota MVP: a comparação é feita diretamente contra `senha_hash`
  /// (armazena a senha em texto no demo). Em produção, seria bcrypt.verify().
  Future<Result<ProfessorModel, Failure>> login(
    LoginCredentials credentials,
  ) async {
    await Future.delayed(AppConstants.fakeNetworkDelay);

    try {
      final professores = await _loadAll();

      final match = professores
          .where(
            (p) =>
                (p['email'] as String).toLowerCase() ==
                credentials.email.trim().toLowerCase(),
          )
          .firstOrNull;

      if (match == null) return const Err(AuthFailure('E-mail não encontrado.'));
      if (match['senha_hash'] != credentials.senha) return const Err(AuthFailure('Senha incorreta.'));
      if (match['ativo'] == false) {
        return const Err(AuthFailure('Conta inativa. Entre em contato com a escola.'));
      }

      return Ok(ProfessorModel.fromJson(match));
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }

  /// Busca professor pelo [id] — usado pelo [AuthViewModel] para restaurar
  /// uma sessão persistida no [FlutterSecureStorage] sem novo login.
  Future<Result<ProfessorModel, Failure>> findById(String id) async {
    try {
      final professores = await _loadAll();

      final match = professores.where((p) => p['id'] == id).firstOrNull;
      if (match == null) return const Err(NotFoundFailure('Sessão inválida.'));

      return Ok(ProfessorModel.fromJson(match));
    } on FormatException {
      return const Err(ParseFailure());
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }

  Future<List<Map<String, dynamic>>> _loadAll() async {
    final raw = await _load(_mockAssetPath);
    final data = json.decode(raw) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }
}
