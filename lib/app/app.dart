import 'package:flutter/material.dart';
import 'package:ai_vibe_flutter_base/core/localization/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../shared/widgets/offline_banner.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    final settings =
        ref.watch(settingsControllerProvider).value ?? const AppSettings();

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) => Column(
        children: [
          const OfflineBanner(),
          Expanded(child: child ?? const SizedBox.shrink()),
        ],
      ),
    );
  }
}
