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
  String get emailLabel => 'メールアドレス';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordHint => 'パスワードを入力';

  @override
  String get signIn => 'ログイン';

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

  @override
  String get loginWelcome => 'おかえりなさい';

  @override
  String get loginSubtitle => 'ワークスペースに続けるにはログインしてください';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get demoHint => 'デモ: demo@example.com / password';

  @override
  String get validationEmailRequired => 'メールアドレスを入力してください';

  @override
  String get validationEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get validationPasswordRequired => 'パスワードを入力してください';

  @override
  String homeGreeting(String name) {
    return 'こんにちは、$name';
  }

  @override
  String get homeWelcomeSubtitle => 'ベースへおかえりなさい';

  @override
  String get homeQuickActions => 'クイックアクション';

  @override
  String get homeActionFeatures => '機能';

  @override
  String get homeActionFeaturesDesc => 'モジュールを見る';

  @override
  String get homeActionDocs => 'ドキュメント';

  @override
  String get homeActionDocsDesc => 'ガイドを読む';

  @override
  String get homeActionComponents => 'コンポーネント';

  @override
  String get homeActionComponentsDesc => '共有ウィジェット';

  @override
  String get homeActionSettings => '設定';

  @override
  String get homeActionSettingsDesc => 'テーマと言語';

  @override
  String get homeTipTitle => 'はじめに';

  @override
  String get homeTipBody =>
      'feature CLI で新しい機能モジュールを生成し、lib/features 内で UI を構築してください。';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsThemeMode => 'テーマ';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get settingsLanguage => '言語';

  @override
  String get languageSystem => 'システム既定';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageJapanese => '日本語';

  @override
  String get settingsAccount => 'アカウント';

  @override
  String get settingsAbout => 'アプリについて';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get signOutConfirmTitle => 'サインアウトしますか？';

  @override
  String get signOutConfirmBody => '続けるには再度ログインが必要です。';

  @override
  String get cancel => 'キャンセル';
}
