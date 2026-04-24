import 'package:fresh_base_project/features/main_tabs/presentation/controllers/main_tabs_controller.dart';

/// Dependency factory for main tabs feature.
class MainTabsBinding {
  const MainTabsBinding._();

  static MainTabsController createController() {
    return MainTabsController();
  }
}
