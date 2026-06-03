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
}
