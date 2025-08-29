import 'package:flutter/material.dart';
import '../app_theme/app_theme_black.dart';
import '../app_theme/app_theme_light.dart';
import 'font/base_font.dart';
import 'logo/app_logo.dart';
import '../core/app_theme_result.dart';

enum AppThemeType {
  dark,
  light;

  AppThemeResult appThemeMobile() {
    switch (this) {
      case AppThemeType.dark:
        return AppThemeResult(
            appTheme: AppThemeBlack(),
            appFont: BaseFont(),
            appLogo: BaseAppLogo(),
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light);

      case AppThemeType.light:
        return AppThemeResult(
            appTheme: AppThemeLight(),
            appFont: BaseFont(),
            appLogo: BaseAppLogo(),
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark);
    }
  }
}
