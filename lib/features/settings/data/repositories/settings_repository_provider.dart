import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/shared_preferences_provider.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import 'settings_repository_impl.dart';

part 'settings_repository_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepositoryImpl(
    SettingsLocalDataSource(ref.watch(sharedPreferencesProvider.future)),
  );
}
