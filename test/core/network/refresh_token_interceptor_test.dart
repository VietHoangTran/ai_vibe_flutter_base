import 'dart:typed_data';

import 'package:ai_vibe_flutter_base/core/network/auth_token_store.dart';
import 'package:ai_vibe_flutter_base/core/network/refresh_token_interceptor.dart';
import 'package:ai_vibe_flutter_base/core/network/token_refresher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTokenStore implements AuthTokenStore {
  _FakeTokenStore({this.refreshToken});

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

class _FakeRefresher implements TokenRefresher {
  _FakeRefresher(this._token);

  final String? _token;
  int calls = 0;
  String? receivedRefreshToken;

  @override
  Future<String?> refresh(String? refreshToken) async {
    calls++;
    receivedRefreshToken = refreshToken;
    return _token;
  }
}

class _StatusAdapter implements HttpClientAdapter {
  _StatusAdapter(this.statusCode);

  final int statusCode;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString('{}', statusCode);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _StatusAdapter mainAdapter;
  late _StatusAdapter retryAdapter;
  late Dio mainDio;
  late Dio retryDio;

  setUp(() {
    mainAdapter = _StatusAdapter(401);
    retryAdapter = _StatusAdapter(200);
    mainDio = Dio()..httpClientAdapter = mainAdapter;
    retryDio = Dio()..httpClientAdapter = retryAdapter;
  });

  Dio buildClient({required String? refreshedToken}) {
    mainDio.interceptors.add(
      RefreshTokenInterceptor(
        tokenStore: _FakeTokenStore(refreshToken: 'refresh-1'),
        refresher: _FakeRefresher(refreshedToken),
        retryClient: retryDio,
      ),
    );
    return mainDio;
  }

  test('refreshes the token and retries the request on 401', () async {
    final dio = buildClient(refreshedToken: 'new-access');

    final response = await dio.get<dynamic>('/me');

    expect(response.statusCode, 200);
    expect(retryAdapter.lastRequest, isNotNull);
    expect(
      retryAdapter.lastRequest!.headers['Authorization'],
      'Bearer new-access',
    );
    expect(retryAdapter.lastRequest!.extra['auth.retried'], isTrue);
  });

  test('propagates the 401 when refresh yields no token', () async {
    final dio = buildClient(refreshedToken: null);

    await expectLater(
      dio.get<dynamic>('/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
    expect(retryAdapter.lastRequest, isNull);
  });
}
