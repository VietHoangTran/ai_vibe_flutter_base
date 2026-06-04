import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage_repository.dart';

/// Persists and reads the bearer tokens used to authenticate requests.
///
/// The auth flow writes tokens with [saveTokens] after a successful sign-in
/// and clears them with [clear] on sign-out. `AuthInterceptor` reads the
/// access token to attach the `Authorization` header, and the refresh seam
/// reads the refresh token to obtain a new access token on `401`.
abstract interface class AuthTokenStore {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> saveTokens({required String accessToken, String? refreshToken});
  Future<void> clear();
}

/// Secure-storage backed [AuthTokenStore].
class SecureStorageAuthTokenStore implements AuthTokenStore {
  const SecureStorageAuthTokenStore(this._storage);

  static const accessTokenKey = 'auth.access_token';
  static const refreshTokenKey = 'auth.refresh_token';

  final SecureStorageRepository _storage;

  @override
  Future<String?> readAccessToken() => _storage.read(accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(refreshTokenKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _storage.write(refreshTokenKey, refreshToken);
    }
  }

  @override
  Future<void> clear() async {
    await _storage.delete(accessTokenKey);
    await _storage.delete(refreshTokenKey);
  }
}

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return SecureStorageAuthTokenStore(
    ref.watch(secureStorageRepositoryProvider),
  );
});
