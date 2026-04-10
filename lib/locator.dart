import 'package:fresh_base_project/core/base/loading_controller.dart';
import 'package:fresh_base_project/core/themes/core/app_theme_manager.dart';
import 'package:fresh_base_project/core/utils/device/device_manager.dart';
import 'package:fresh_base_project/core/utils/logging/app_log.dart';
import 'package:fresh_base_project/core/utils/network/auth_token_store.dart';
import 'package:fresh_base_project/core/utils/network/connectivity_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> setupLocator() async {
  await GetStorage.init();

  await DeviceManager().init();
  await AppLog().init();
  await AuthTokenStore().init();

  Get.put<LoadingController>(LoadingController(), permanent: true);
  Get.put<GetStorage>(GetStorage(), permanent: true);
  Get.put<AppThemeManger>(AppThemeManger(), permanent: true);
  Get.put<ConnectivityService>(
    await ConnectivityService().init(),
    permanent: true,
  );
}
