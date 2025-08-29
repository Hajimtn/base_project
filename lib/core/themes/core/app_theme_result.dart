import 'package:flutter/material.dart';
import '../common/font/base_font.dart';
import '../common/logo/app_logo.dart';
import 'app_theme.dart';

class AppThemeResult {
  AppThemeResult(
      {required this.appTheme, required this.appFont, required this.appLogo,this.statusBarBrightness, this.statusBarIconBrightness, });

  final AppTheme appTheme;
  final BaseFont appFont;
  final BaseAppLogo appLogo;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
}

