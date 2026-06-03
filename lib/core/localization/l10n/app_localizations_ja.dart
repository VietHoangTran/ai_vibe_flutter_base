// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'AI Vibe Flutter Base';

  @override
  String get homeTitle => 'ホーム';

  @override
  String get loginTitle => 'ログイン';

  @override
  String welcomeUser(String name) {
    return 'ようこそ、$name';
  }

  @override
  String get baseReady => 'ベースプロジェクトの準備ができました。lib/features に機能モジュールを作成してください。';

  @override
  String get signOut => 'サインアウト';

  @override
  String get notFound => '見つかりません';

  @override
  String get routeNotFound => 'ルートが見つかりません';
}
