import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/auth_token_store.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/storage/secure_storage_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import 'auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    localDataSource: AuthLocalDataSource(ref.watch(secureStorageProvider)),
    remoteDataSource: AuthRemoteDataSource(ref.watch(dioProvider)),
    tokenStore: ref.watch(authTokenStoreProvider),
  );
}
