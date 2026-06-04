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
  String get emailHint => 'you@example.com';

  @override
  String get passwordHint => 'Enter your password';

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

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue to your workspace';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get demoHint => 'Demo: demo@example.com / password';

  @override
  String get validationEmailRequired => 'Please enter your email';

  @override
  String get validationEmailInvalid => 'Enter a valid email address';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeWelcomeSubtitle => 'Welcome back to your base';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get homeActionFeatures => 'Features';

  @override
  String get homeActionFeaturesDesc => 'Browse feature modules';

  @override
  String get homeActionDocs => 'Docs';

  @override
  String get homeActionDocsDesc => 'Read the guides';

  @override
  String get homeActionComponents => 'Components';

  @override
  String get homeActionComponentsDesc => 'Shared widgets';

  @override
  String get homeActionSettings => 'Settings';

  @override
  String get homeActionSettingsDesc => 'Theme & language';

  @override
  String get homeTipTitle => 'Getting started';

  @override
  String get homeTipBody =>
      'Generate a new feature module with the feature CLI, then build its UI inside lib/features.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeMode => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageJapanese => '日本語';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody => 'You\'ll need to sign in again to continue.';

  @override
  String get cancel => 'Cancel';

  @override
  String get offlineMessage => 'No internet connection';
}
