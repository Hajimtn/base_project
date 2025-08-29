import 'base_mixin.dart';

export 'package:flutter/material.dart';
export 'package:get/get.dart';

abstract class BaseWidget<T extends GetxController> extends StatelessWidget
    with BaseMixin {
  BaseWidget({this.tag, super.key}) {
    if (Get.isRegistered<T>(tag: tag)) {
      controller = GetInstance().find<T>(tag: tag);
    }
  }

  final String? tag;
  late final T controller;

  String? screenName() => '';

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  Widget builder(BuildContext context);

}
