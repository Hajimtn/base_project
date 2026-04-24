import '../themes/themes.dart';

export 'package:flutter/material.dart';

mixin BaseMixin {
  AppTheme get color => AppThemeManger().theme;

  AppTextStyle get textStyle => AppThemeManger().textStyle;
}
