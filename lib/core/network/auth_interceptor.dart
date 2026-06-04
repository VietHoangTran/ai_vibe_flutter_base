import 'package:dio/dio.dart';

import 'auth_token_store.dart';

/// Attaches the bearer access token from [AuthTokenStore] to every request.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor({required AuthTokenStore tokenStore})
    : _tokenStore = tokenStore;

  final AuthTokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.readAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
