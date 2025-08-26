import 'package:base_project/features/users/view/pages/users_screen.dart';
import 'package:get/get.dart';

class AppRouter {
  // Define all app routers here
  static const String routerUsers = '/users';

  static List<GetPage<dynamic>> getPages = <GetPage<dynamic>>[
    GetPage<UsersScreen>(name: routerUsers, page: () => UsersScreen()),
  ];
}
