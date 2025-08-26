import 'package:flutter/material.dart';
import 'package:themes/src/common/font/base_font.dart';
import 'package:themes/src/common/logo/app_logo.dart';
import 'package:themes/src/core/app_theme.dart';

class AppThemeResult {
  AppThemeResult(
      {required this.appTheme, required this.appFont, required this.appLogo,this.statusBarBrightness, this.statusBarIconBrightness, });

  final AppTheme appTheme;
  final BaseFont appFont;
  final BaseAppLogo appLogo;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
}

