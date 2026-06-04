import 'package:ai_vibe_flutter_base/core/network/auth_interceptor.dart';
import 'package:ai_vibe_flutter_base/core/network/auth_token_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTokenStore implements AuthTokenStore {
  _FakeTokenStore({this.accessToken});

  String? accessToken;
  String? refreshToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}

void main() {
  RequestOptions runOnRequest(AuthInterceptor interceptor) {
    final options = RequestOptions(path: '/me');
    interceptor.onRequest(options, RequestInterceptorHandler());
    return options;
  }

  group('AuthInterceptor', () {
    test('attaches a Bearer header when a token exists', () async {
      final interceptor = AuthInterceptor(
        tokenStore: _FakeTokenStore(accessToken: 'abc123'),
      );

      final options = runOnRequest(interceptor);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers['Authorization'], 'Bearer abc123');
    });

    test('does not add a header when the token is null', () async {
      final interceptor = AuthInterceptor(tokenStore: _FakeTokenStore());

      final options = runOnRequest(interceptor);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('does not add a header when the token is empty', () async {
      final interceptor = AuthInterceptor(
        tokenStore: _FakeTokenStore(accessToken: ''),
      );

      final options = runOnRequest(interceptor);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers.containsKey('Authorization'), isFalse);
    });
  });
}
