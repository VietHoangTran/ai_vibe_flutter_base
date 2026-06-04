import 'package:dio/dio.dart';

import '../../../../core/error/app_exception.dart';
import '../models/user_model.dart';

/// The user plus the tokens returned by a successful sign-in.
typedef SignInResult = ({
  UserModel user,
  String accessToken,
  String? refreshToken,
});

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    // Replace this mock with your real endpoint, for example:
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/auth/login',
    //   data: {'email': email, 'password': password},
    // );
    // final data = response.data!;
    // return (
    //   user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    //   accessToken: data['access_token'] as String,
    //   refreshToken: data['refresh_token'] as String?,
    // );

    _dio.options.baseUrl; // Keeps the dependency visible until real API wiring.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email and password are required');
    }
    return (
      user: UserModel(id: 'demo-user', email: email, name: 'Demo User'),
      accessToken: 'demo-access-token',
      refreshToken: 'demo-refresh-token',
    );
  }
}
