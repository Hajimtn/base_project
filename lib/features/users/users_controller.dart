import 'package:base_project/features/users/data/models/user_model.dart';
import 'package:base_project/features/users/data/repositories/users_repository.dart';
import 'package:common/base/base_controller.dart';


class UsersController extends BaseController {
  final UsersRepository _repository = UsersRepository();
  
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _repository.getUsers();
      
      if (response.isSuccess) {
        users.value = response.data ?? [];
      } else {
        errorMessage.value = response.message ?? 'Có lỗi xảy ra khi tải dữ liệu';
      }
    } catch (e) {
      errorMessage.value = 'Lỗi kết nối: $e';
    } finally {
      isLoading.value = false;
    }
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
