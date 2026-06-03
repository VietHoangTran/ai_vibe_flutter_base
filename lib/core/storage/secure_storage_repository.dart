import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'secure_storage_provider.dart';

abstract interface class SecureStorageRepository {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

final class FlutterSecureStorageRepository implements SecureStorageRepository {
  const FlutterSecureStorageRepository(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

final secureStorageRepositoryProvider = Provider<SecureStorageRepository>((
  ref,
) {
  return FlutterSecureStorageRepository(ref.watch(secureStorageProvider));
});
