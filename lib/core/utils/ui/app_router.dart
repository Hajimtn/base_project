import 'package:fresh_base_project/features/main_tabs/presentation/bindings/main_tabs_binding.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/pages/main_tabs_page.dart';
import 'package:fresh_base_project/features/users/presentation/bindings/users_binding.dart';
import 'package:fresh_base_project/features/users/presentation/pages/users_page.dart';
import 'package:get/get.dart';

/// Centralized application routes using GetX.
class AppRouter {
  AppRouter._();

  static const String routerMainTabs = '/';
  static const String routerUsers = '/users';

  static final List<GetPage<dynamic>> getPages = <GetPage<dynamic>>[
    GetPage<MainTabsPage>(
      name: routerMainTabs,
      page: MainTabsPage.new,
      binding: MainTabsBinding(),
    ),
    GetPage<UsersPage>(
      name: routerUsers,
      page: UsersPage.new,
      binding: UsersBinding(),
    ),
  ];
}
