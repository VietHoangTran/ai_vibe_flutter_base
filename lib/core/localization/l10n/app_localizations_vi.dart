// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'AI Vibe Flutter Base';

  @override
  String get homeTitle => 'Trang chủ';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get emailHint => 'ban@example.com';

  @override
  String get passwordHint => 'Nhập mật khẩu của bạn';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String welcomeUser(String name) {
    return 'Xin chào, $name';
  }

  @override
  String get baseReady =>
      'Base project đã sẵn sàng. Hãy xây dựng các module tính năng trong lib/features.';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get notFound => 'Không tìm thấy';

  @override
  String get routeNotFound => 'Không tìm thấy route';

  @override
  String get loginWelcome => 'Chào mừng trở lại';

  @override
  String get loginSubtitle => 'Đăng nhập để tiếp tục vào workspace của bạn';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get demoHint => 'Demo: demo@example.com / password';

  @override
  String get validationEmailRequired => 'Vui lòng nhập email';

  @override
  String get validationEmailInvalid => 'Nhập địa chỉ email hợp lệ';

  @override
  String get validationPasswordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String homeGreeting(String name) {
    return 'Chào $name';
  }

  @override
  String get homeWelcomeSubtitle => 'Chào mừng trở lại với base của bạn';

  @override
  String get homeQuickActions => 'Truy cập nhanh';

  @override
  String get homeActionFeatures => 'Tính năng';

  @override
  String get homeActionFeaturesDesc => 'Xem các module';

  @override
  String get homeActionDocs => 'Tài liệu';

  @override
  String get homeActionDocsDesc => 'Đọc hướng dẫn';

  @override
  String get homeActionComponents => 'Thành phần';

  @override
  String get homeActionComponentsDesc => 'Widget dùng chung';

  @override
  String get homeActionSettings => 'Cài đặt';

  @override
  String get homeActionSettingsDesc => 'Giao diện & ngôn ngữ';

  @override
  String get homeTipTitle => 'Bắt đầu';

  @override
  String get homeTipBody =>
      'Tạo module tính năng mới bằng feature CLI, sau đó xây dựng UI trong lib/features.';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsAppearance => 'Giao diện';

  @override
  String get settingsThemeMode => 'Chủ đề';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Mặc định hệ thống';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageJapanese => '日本語';

  @override
  String get settingsAccount => 'Tài khoản';

  @override
  String get settingsAbout => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get signOutConfirmTitle => 'Đăng xuất?';

  @override
  String get signOutConfirmBody => 'Bạn sẽ cần đăng nhập lại để tiếp tục.';

  @override
  String get cancel => 'Hủy';
}
