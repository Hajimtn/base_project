import 'package:base_project/features/users/models/user_model.dart';
import 'package:base_project/features/users/repository/users_repo.dart';
import 'package:base_project/features/users/repository/users_repo_impl.dart';

class UserUsecase {
  final UsersRepository _repository = UserRepositoryImpl();

  Future<void> getUsers({
    required Function(List<UserModel>) onSuccess,
    required Function(dynamic) onFailure,
  }) async {
    try {
      final List<UserModel> value = await _repository.getUsers();
      onSuccess(value);
    } catch (error) {
      onFailure(error);
    }
  }
}
