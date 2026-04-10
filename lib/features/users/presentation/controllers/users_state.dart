import 'package:equatable/equatable.dart';
import 'package:fresh_base_project/features/users/domain/entities/user_entity.dart';

/// UI status for users screen.
enum UsersStatus { initial, loading, success, failure }

/// Immutable view state for users screen.
class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const <UserEntity>[],
    this.errorMessage,
  });

  final UsersStatus status;
  final List<UserEntity> users;
  final String? errorMessage;

  bool get hasData => users.isNotEmpty;

  UsersState copyWith({
    UsersStatus? status,
    List<UserEntity>? users,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[status, users, errorMessage];
}
