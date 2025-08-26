import 'package:flutter/material.dart';
import 'package:themes/src/core/app_theme.dart';
import 'package:themes/src/core/app_theme_manager.dart';

class AppThemeBlack extends AppTheme {
  @override
  ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: Colors.black,
      useMaterial3: true,
      primaryColor: Colors.black,
      fontFamily: AppThemeManger().baseFont.fontRegular,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      );

  @override
  Color get primary => Colors.black;
}
