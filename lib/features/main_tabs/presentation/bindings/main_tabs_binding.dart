import 'package:fresh_base_project/features/main_tabs/presentation/controllers/main_tabs_controller.dart';
import 'package:fresh_base_project/features/users/presentation/bindings/users_binding.dart';
import 'package:get/get.dart';

/// Dependency graph for bottom-tab shell feature.
class MainTabsBinding extends Bindings {
  @override
  void dependencies() {
    // Reuse users feature as one tab in shell.
    UsersBinding().dependencies();

    Get.lazyPut<MainTabsController>(MainTabsController.new);
  }
}
