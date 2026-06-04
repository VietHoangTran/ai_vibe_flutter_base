import '../../../../core/network/auth_token_store.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
    required AuthTokenStore tokenStore,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _tokenStore = tokenStore;

  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final AuthTokenStore _tokenStore;

  @override
  Future<AppUser?> currentUser() async =>
      (await _localDataSource.readUser())?.toEntity();

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );
    await _tokenStore.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    await _localDataSource.saveUser(result.user);
    return result.user.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _localDataSource.clearUser();
    await _tokenStore.clear();
  }
}
