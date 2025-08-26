import 'package:base_project/core/themes/common/app_theme_type.dart';
import 'package:base_project/core/themes/core/app_theme_manager.dart';

import '../../../../core/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/users_controller.dart';
import '../widgets/user_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsersScreen extends BaseScreen<UsersController> {
  UsersScreen({super.key});

  @override
  UsersController? putController() => UsersController();

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.usersTitle,
          style: textStyle.regular(color: Colors.white),
        ),
        backgroundColor: color.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens_outlined, color: Colors.white),
            tooltip: 'Theme',
            onPressed: () {
              AppThemeManger().changeAppTheme(
                AppThemeManger().appTheme == AppThemeType.light
                    ? AppThemeType.dark
                    : AppThemeType.light,
              );
            },
          ),
          PopupMenuButton<Locale>(
            icon: Icon(Icons.language, color: Colors.white),
            onSelected: (locale) {
              Get.updateLocale(locale);
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: const Locale('vi'),
                    child: Text('Tiếng Việt'),
                  ),
                  PopupMenuItem(
                    value: const Locale('en'),
                    child: Text('English'),
                  ),
                ],
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshUsers,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Text(
                      l10n.noUsers(0),
                      style: textStyle.regular(color: Colors.grey),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshUsers,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return UserCard(
                user: user,
                onTap: () => controller.onUserTap(user),
              );
            },
          ),
        );
      }),
    );
  }
}
