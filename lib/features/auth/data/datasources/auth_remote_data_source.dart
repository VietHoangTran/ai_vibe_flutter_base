import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UserModel> signIn({required String email, required String password}) async {
    // Replace this mock with your real endpoint, for example:
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/auth/login',
    //   data: {'email': email, 'password': password},
    // );
    // return UserModel.fromJson(response.data!['user'] as Map<String, dynamic>);

    _dio.options.baseUrl; // Keeps the dependency visible until real API wiring.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email and password are required');
    }
    return UserModel(id: 'demo-user', email: email, name: 'Demo User');
  }
}
