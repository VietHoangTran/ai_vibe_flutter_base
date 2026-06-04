import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'auth_token_store.dart';
import 'network_exception_mapper.dart';
import 'refresh_token_interceptor.dart';
import 'token_refresher.dart';
import '../utils/app_logger.dart';

part 'dio_provider.g.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: AppConfig.apiBaseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
  sendTimeout: const Duration(seconds: 15),
  headers: {'Content-Type': 'application/json'},
);

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(_baseOptions());
  final tokenStore = ref.watch(authTokenStoreProvider);

  dio.interceptors.add(AuthInterceptor(tokenStore: tokenStore));

  dio.interceptors.add(
    RefreshTokenInterceptor(
      tokenStore: tokenStore,
      refresher: ref.watch(tokenRefresherProvider),
      // Bare client so retried requests skip the refresh interceptor.
      retryClient: Dio(_baseOptions()),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (!AppConfig.isProduction) {
          AppLogger.instance.d('${options.method} ${options.uri}');
        }
        handler.next(options);
      },
      onError: (error, handler) {
        final exception = mapDioException(error);

        if (!AppConfig.isProduction) {
          AppLogger.instance.e(
            'Network error: ${error.requestOptions.uri}',
            error: exception,
            stackTrace: error.stackTrace,
          );
        }

        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: exception,
            stackTrace: error.stackTrace,
            message: exception.message,
          ),
        );
      },
    ),
  );

  return dio;
}
