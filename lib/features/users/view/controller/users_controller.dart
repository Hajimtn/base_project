import 'package:base_project/features/users/models/user_model.dart';
import 'package:base_project/features/users/usecase/user_usecase.dart';
import '../../../../core/base/base_controller.dart';

class UsersController extends BaseController {
  final UserUsecase _usecase = UserUsecase();

  final RxList<UserModel> users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    showLoading();
    await _usecase.getUsers(
      onSuccess: (List<UserModel> value) {
        users.value = value;
        hideLoading();
      },
      onFailure: (error) {
        hideLoading();
      },
    );
  }

  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  void onUserTap(UserModel user) {
    Get.snackbar(
      'Thông tin người dùng',
      'Bạn đã chọn: ${user.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
