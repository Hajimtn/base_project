import 'package:base_project/core/base/loading_controller.dart';
import 'package:base_project/core/config/config.dart';
import 'package:base_project/core/utils/device_manager.dart';
import 'package:get/get.dart';


Future<void> setupLocator(BaseConfig config) async {
  await DeviceManager().init();
  Get.put<LoadingController>(LoadingController());
}
