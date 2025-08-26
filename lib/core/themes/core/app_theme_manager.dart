import 'package:base_project/core/utils/device/device_platform.dart';
import 'package:base_project/core/utils/ui/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../app_theme/app_theme_dark.dart';
import '../common/app_theme_type.dart';
import '../common/font/base_font.dart';
import 'app_theme.dart';
import 'app_theme_result.dart';
import '../text_style/app_text_style.dart';

class AppThemeManger {
  factory AppThemeManger() {
    return _singleton;
  }

  AppThemeManger._internal() {
    _initThemeModeFromSharedPrefs();

    ever(_appThemeType, (AppThemeType type) {
      updateTheme();
      Get.changeTheme(theme.theme);
      Get.forceAppUpdate();
    });
  }

  AppTheme theme = AppThemeDark();

  AppTextStyle textStyle = AppTextStyle();

  BaseFont baseFont = BaseFont();

  static final AppThemeManger _singleton = AppThemeManger._internal();

  late final Rx<AppThemeType> _appThemeType;

  void updateTheme() {
    late AppThemeResult appThemeCompanyResult;

    switch (DevicePlatformManager().typePlatform) {
      case TypePlatform.mobile:
        appThemeCompanyResult = _appThemeType.value.appThemeMobile();

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            // ios
            statusBarBrightness: appThemeCompanyResult.statusBarBrightness,
            // Android
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                appThemeCompanyResult.statusBarIconBrightness,
          ),
        );
        break;
    }

    theme = appThemeCompanyResult.appTheme;
    baseFont = appThemeCompanyResult.appFont;
  }

  AppThemeType get appTheme => _appThemeType.value;

  ThemeData get themeData => theme.theme;

  Future<void> _initThemeModeFromSharedPrefs() async {
    _appThemeType = getAppThemType('light').obs;
  }

  Future<void> changeAppTheme(AppThemeType type) async {
    if (_appThemeType.value != type) {
      _appThemeType.value = type;
      Get.find<GetStorage>().write(AppConst.keyThemeMode, type.toString());
    }
  }

  AppThemeType getAppThemType(String? key) {
    if (key == AppThemeType.light.toString()) {
      return AppThemeType.light;
    }
    return AppThemeType.dark;
  }
}
