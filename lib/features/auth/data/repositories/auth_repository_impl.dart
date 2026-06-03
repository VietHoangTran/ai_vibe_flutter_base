import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AppUser?> currentUser() async => (await _localDataSource.readUser())?.toEntity();

  @override
  Future<AppUser> signIn({required String email, required String password}) async {
    final user = await _remoteDataSource.signIn(email: email, password: password);
    await _localDataSource.saveUser(user);
    return user.toEntity();
  }

  @override
  Future<void> signOut() => _localDataSource.clearUser();
}
