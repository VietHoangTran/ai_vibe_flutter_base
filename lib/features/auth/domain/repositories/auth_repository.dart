import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Future<AppUser?> currentUser();
  Future<AppUser> signIn({required String email, required String password});
  Future<void> signOut();
}
