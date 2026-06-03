import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/app_exception.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._secureStorage);

  static const _userKey = 'auth.user';

  final FlutterSecureStorage _secureStorage;

  Future<UserModel?> readUser() async {
    try {
      final raw = await _secureStorage.read(key: _userKey);
      if (raw == null) return null;
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (error) {
      throw StorageException('Could not read local user', cause: error);
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (error) {
      throw StorageException('Could not save local user', cause: error);
    }
  }

  Future<void> clearUser() => _secureStorage.delete(key: _userKey);
}
