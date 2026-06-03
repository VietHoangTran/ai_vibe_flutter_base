import 'package:ai_vibe_flutter_base/features/auth/domain/entities/app_user.dart';
import 'package:ai_vibe_flutter_base/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('mocktail repository example', () async {
    final repository = MockAuthRepository();

    when(repository.currentUser).thenAnswer(
      (_) async =>
          const AppUser(id: '1', email: 'demo@example.com', name: 'Demo'),
    );

    final user = await repository.currentUser();

    expect(user?.email, 'demo@example.com');
    verify(repository.currentUser).called(1);
  });
}
