import '../themes/themes.dart';

export 'package:flutter/material.dart';
export 'package:get/get.dart';

mixin BaseMixin {
  AppTheme get color => AppThemeManger().theme;

  AppTextStyle get textStyle => AppThemeManger().textStyle;

}

