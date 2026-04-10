import 'package:flutter/material.dart';
import 'package:fresh_base_project/core/base/base_page.dart';
import 'package:fresh_base_project/core/themes/common/app_theme_type.dart';
import 'package:fresh_base_project/core/themes/core/app_theme_manager.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_state.dart';
import 'package:fresh_base_project/features/users/presentation/widgets/user_card.dart';
import 'package:fresh_base_project/l10n/app_localizations.dart';
import 'package:get/get.dart';

/// Users page that renders loading, empty, error and data states.
class UsersPage extends BaseScreen<UsersController> {
  UsersPage({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  UsersController? putController() => Get.find<UsersController>();

  @override
  Widget builder(BuildContext context) {
    final Widget body = Obx(() {
      final UsersState state = controller.state.value;
      return _UsersBody(
        state: state,
        onRefresh: controller.refreshUsers,
        onUserTap: controller.onUserTap,
      );
    });

    if (!showAppBar) {
      return SafeArea(child: body);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.usersTitle,
          style: textStyle.regular(color: Colors.white),
        ),
        backgroundColor: color.primary,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.color_lens_outlined, color: Colors.white),
            tooltip: 'Theme',
            onPressed: _toggleTheme,
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Colors.white),
            onSelected: Get.updateLocale,
            itemBuilder:
                (BuildContext context) => const <PopupMenuEntry<Locale>>[
                  PopupMenuItem<Locale>(
                    value: Locale('vi'),
                    child: Text('Tieng Viet'),
                  ),
                  PopupMenuItem<Locale>(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshUsers,
          ),
        ],
      ),
      body: body,
    );
  }

  void _toggleTheme() {
    final AppThemeType currentTheme = AppThemeManger().appTheme;
    final AppThemeType nextTheme =
        currentTheme == AppThemeType.light
            ? AppThemeType.dark
            : AppThemeType.light;

    AppThemeManger().changeAppTheme(nextTheme);
  }
}

class _UsersBody extends StatelessWidget {
  const _UsersBody({
    required this.state,
    required this.onRefresh,
    required this.onUserTap,
  });

  final UsersState state;
  final Future<void> Function() onRefresh;
  final void Function(UserEntity user) onUserTap;

  @override
  Widget build(BuildContext context) {
    if (!state.hasData) {
      return _UsersEmptyState(errorMessage: state.errorMessage);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.users.length,
        itemBuilder: (BuildContext context, int index) {
          final UserEntity user = state.users[index];
          return UserCard(user: user, onTap: () => onUserTap(user));
        },
      ),
    );
  }
}

class _UsersEmptyState extends StatelessWidget {
  const _UsersEmptyState({required this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.people_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(errorMessage ?? l10n.noUsers(0), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
