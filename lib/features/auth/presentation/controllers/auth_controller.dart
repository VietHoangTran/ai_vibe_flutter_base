import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository_provider.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AppUser?> build() {
    return ref.watch(authRepositoryProvider).currentUser();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = SignInUseCase(ref.read(authRepositoryProvider));
      return useCase(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await SignOutUseCase(ref.read(authRepositoryProvider))();
    state = const AsyncData(null);
  }
}
