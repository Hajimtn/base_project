import 'package:base_project/core/base/loading_controller.dart';
import 'package:base_project/core/config/config.dart';
import 'package:base_project/core/themes/core/app_theme_manager.dart';
import 'package:base_project/core/utils/logging/app_log.dart';
import 'package:base_project/core/utils/device/device_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> setupLocator(BaseConfig config) async {
  await DeviceManager().init();
  await AppLog().init();
  Get.put<LoadingController>(LoadingController());
  Get.put<AppThemeManger>(AppThemeManger());
  Get.put<GetStorage>(GetStorage());
}
