import 'package:fresh_base_project/core/base/base_controller.dart';
import 'package:fresh_base_project/core/errors/failure.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/domain/usecases/get_users_use_case.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_state.dart';

/// GetX controller that maps domain results into UI state.
class UsersController extends BaseController {
  UsersController({required GetUsersUseCase getUsersUseCase})
    : _getUsersUseCase = getUsersUseCase;

  final GetUsersUseCase _getUsersUseCase;

  final Rx<UsersState> state = const UsersState().obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fetches users and updates loading/success/failure states.
  Future<void> fetchUsers() async {
    showLoading();
    state.value = state.value.copyWith(
      status: UsersStatus.loading,
      clearErrorMessage: true,
    );

    final result = await _getUsersUseCase();
    result.fold(_handleFailure, _handleSuccess);

    hideLoading();
  }

  /// Pull-to-refresh entry point.
  Future<void> refreshUsers() => fetchUsers();

  /// Handles a user item click event.
  void onUserTap(UserEntity user) {
    Get.snackbar(
      'User selected',
      'You selected: ${user.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleFailure(Failure failure) {
    state.value = state.value.copyWith(
      status: UsersStatus.failure,
      users: const <UserEntity>[],
      errorMessage: failure.message,
    );
  }

  void _handleSuccess(List<UserEntity> users) {
    state.value = state.value.copyWith(
      status: UsersStatus.success,
      users: users,
      clearErrorMessage: true,
    );
  }
}
