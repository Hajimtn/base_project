import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/app_theme_manager.dart';

class AppThemeLight extends AppTheme {

  @override
  ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      primaryColor: Colors.white,
      fontFamily: AppThemeManger().baseFont.fontRegular,
      appBarTheme: AppBarTheme(
        backgroundColor : Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      );

  @override
  Color get primary => Colors.white;

}
