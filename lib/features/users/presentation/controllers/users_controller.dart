import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fresh_base_project/core/base/base_controller.dart';
import 'package:fresh_base_project/core/errors/failure.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';
import 'package:fresh_base_project/features/users/domain/usecases/get_users_use_case.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_state.dart';

/// Cubit that maps domain results into UI state.
class UsersController extends Cubit<UsersState> with BaseController {
  UsersController({required GetUsersUseCase getUsersUseCase})
    : _getUsersUseCase = getUsersUseCase,
      super(const UsersState()) {
    fetchUsers();
  }

  final GetUsersUseCase _getUsersUseCase;

  /// Fetches users and updates loading/success/failure states.
  Future<void> fetchUsers() async {
    showLoading();
    emit(state.copyWith(status: UsersStatus.loading, clearErrorMessage: true));

    final result = await _getUsersUseCase();
    result.fold(_handleFailure, _handleSuccess);

    hideLoading();
  }

  /// Pull-to-refresh entry point.
  Future<void> refreshUsers() => fetchUsers();

  /// Handles a user item click event.
  void onUserTap(BuildContext context, UserEntity user) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('You selected: ${user.name}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _handleFailure(Failure failure) {
    emit(
      state.copyWith(
        status: UsersStatus.failure,
        users: const <UserEntity>[],
        errorMessage: failure.message,
      ),
    );
  }

  void _handleSuccess(List<UserEntity> users) {
    emit(
      state.copyWith(
        status: UsersStatus.success,
        users: users,
        clearErrorMessage: true,
      ),
    );
  }

  @override
  Future<void> close() {
    onDisposeController();
    return super.close();
  }
}
