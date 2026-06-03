// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Vibe Flutter Base';

  @override
  String get homeTitle => 'Home';

  @override
  String get loginTitle => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get baseReady =>
      'Base project is ready. Build your feature modules inside lib/features.';

  @override
  String get signOut => 'Sign out';

  @override
  String get notFound => 'Not found';

  @override
  String get routeNotFound => 'Route not found';
}
