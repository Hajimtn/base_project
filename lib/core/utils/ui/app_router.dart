import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/bindings/main_tabs_binding.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/controllers/main_tabs_controller.dart';
import 'package:fresh_base_project/features/main_tabs/presentation/pages/main_tabs_page.dart';
import 'package:fresh_base_project/features/users/presentation/bindings/users_binding.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart';
import 'package:fresh_base_project/features/users/presentation/pages/users_page.dart';

/// Centralized application routes.
class AppRouter {
  AppRouter._();

  static const String routerMainTabs = '/';
  static const String routerUsers = '/users';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routerMainTabs:
        return MaterialPageRoute<void>(
          settings: settings,
          builder:
              (_) => BlocProvider<MainTabsController>(
                create: (_) => MainTabsBinding.createController(),
                child: MainTabsPage(),
              ),
        );
      case routerUsers:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => _buildUsersScreen(showAppBar: true),
        );
      default:
        return null;
    }
  }

  static UsersController createUsersController() {
    return UsersBinding.createController();
  }

  static Widget buildUsersTab({required bool showAppBar}) {
    return _buildUsersScreen(showAppBar: showAppBar);
  }

  static Widget _buildUsersScreen({required bool showAppBar}) {
    return BlocProvider<UsersController>(
      create: (_) => createUsersController(),
      child: UsersPage(showAppBar: showAppBar),
    );
  }
}
