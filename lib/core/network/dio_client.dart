import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Cliente DIO configurado e pronto para troca por backend real.
///
/// Em ambiente mock, a [baseUrl] aponta para assets locais via interceptor.
/// Em produção, basta trocar a [baseUrl] no flavor correspondente.
class DioClient {
  DioClient._();

  static Dio create({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      if (kDebugMode) _LogInterceptor(),
      _ErrorInterceptor(),
    ]);

    return dio;
  }
}

/// Loga todas as requisições e respostas em modo debug.
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️  [DIO] ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅  [DIO] ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌  [DIO] ${err.type} ${err.requestOptions.path}: ${err.message}');
    handler.next(err);
  }
}

/// Mapeia erros DIO para exceções de domínio legíveis.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Conversão para DioException customizado — repositórios convertem
    // para Failure na camada de dados.
    handler.next(err);
  }
}
