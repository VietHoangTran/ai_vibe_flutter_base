import 'package:dio/dio.dart';

import 'auth_token_store.dart';
import 'token_refresher.dart';

/// Retries a request once after refreshing the access token on a `401`.
///
/// Uses a [QueuedInterceptor] so that concurrent failures share a single
/// refresh attempt instead of triggering a refresh storm. The retry is sent
/// through [_retryClient] (a Dio instance without this interceptor) to avoid
/// recursive refresh loops.
class RefreshTokenInterceptor extends QueuedInterceptor {
  RefreshTokenInterceptor({
    required AuthTokenStore tokenStore,
    required TokenRefresher refresher,
    required Dio retryClient,
  }) : _tokenStore = tokenStore,
       _refresher = refresher,
       _retryClient = retryClient;

  static const _retriedFlag = 'auth.retried';

  final AuthTokenStore _tokenStore;
  final TokenRefresher _refresher;
  final Dio _retryClient;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra[_retriedFlag] == true;

    if (!isUnauthorized || alreadyRetried) {
      handler.next(err);
      return;
    }

    final refreshToken = await _tokenStore.readRefreshToken();
    final newAccessToken = await _refresher.refresh(refreshToken);

    if (newAccessToken == null || newAccessToken.isEmpty) {
      handler.next(err);
      return;
    }

    await _tokenStore.saveTokens(
      accessToken: newAccessToken,
      refreshToken: refreshToken,
    );

    final options = err.requestOptions
      ..extra[_retriedFlag] = true
      ..headers['Authorization'] = 'Bearer $newAccessToken';

    try {
      final response = await _retryClient.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
