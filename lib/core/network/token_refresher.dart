import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Exchanges a refresh token for a fresh access token.
///
/// This is the extension point for token refresh. The base ships a
/// [NoopTokenRefresher] so the starter app (which has no backend) behaves
/// unchanged: a `401` simply propagates. Override [tokenRefresherProvider]
/// with a real implementation that calls your `/auth/refresh` endpoint, and
/// `RefreshTokenInterceptor` will transparently retry the failed request.
abstract interface class TokenRefresher {
  /// Returns a new access token, or `null` when refresh is impossible
  /// (no refresh token, expired session, endpoint not wired yet).
  Future<String?> refresh(String? refreshToken);
}

/// Default refresher that never refreshes. Replace via [tokenRefresherProvider].
class NoopTokenRefresher implements TokenRefresher {
  const NoopTokenRefresher();

  @override
  Future<String?> refresh(String? refreshToken) async => null;
}

final tokenRefresherProvider = Provider<TokenRefresher>((ref) {
  return const NoopTokenRefresher();
});
