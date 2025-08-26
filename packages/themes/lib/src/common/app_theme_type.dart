import 'package:flutter/material.dart';
import 'package:themes/src/app_theme/app_theme_black.dart';
import 'package:themes/src/app_theme/app_theme_light.dart';
import 'package:themes/src/common/font/base_font.dart';
import 'package:themes/src/common/logo/app_logo.dart';
import 'package:themes/src/core/app_theme_result.dart';

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
