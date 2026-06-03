import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage_repository.dart';

abstract interface class AuthTokenStore {
  Future<String?> readAccessToken();
}

/// Reads the bearer access token from secure storage.
///
/// Persist the token under [accessTokenKey] from your auth flow
/// (for example in `AuthLocalDataSource`) so requests are authenticated.
class SecureStorageAuthTokenStore implements AuthTokenStore {
  const SecureStorageAuthTokenStore(this._storage);

  static const accessTokenKey = 'auth.access_token';

  final SecureStorageRepository _storage;

  @override
  Future<String?> readAccessToken() => _storage.read(accessTokenKey);
}

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return SecureStorageAuthTokenStore(
    ref.watch(secureStorageRepositoryProvider),
  );
});

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
