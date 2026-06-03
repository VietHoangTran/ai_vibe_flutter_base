import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'network_exception_mapper.dart';
import '../utils/app_logger.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(tokenStore: ref.watch(authTokenStoreProvider)),
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
