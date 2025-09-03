// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Dự án Mẫu';

  @override
  String get usersTitle => 'Người dùng';

  @override
  String noUsers(Object users) {
    return 'Không có dữ liệu người dùng $users';
  }
}
