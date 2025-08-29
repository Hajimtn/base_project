import '../../../../core/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/users_controller.dart';
import '../widgets/user_card.dart';

class UsersScreen extends BaseScreen<UsersController> {
  UsersScreen({super.key});

  @override
  UsersController? putController() => UsersController();

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách người dùng',
          style: textStyle.regular(color: Colors.white),
        ),
        backgroundColor: color.primary,
        elevation: 0,
        actions: [
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
                Text(
                  'Không có dữ liệu người dùng',
                  style: textStyle.regular(color: Colors.grey),
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
