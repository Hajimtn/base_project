import 'package:base_project/features/users/models/user_model.dart';
import 'package:base_project/features/users/repository/users_repo.dart';
import '../../../../core/utils/simple_rest_client.dart';
import '../../../../core/utils/api_response.dart';

class UserRepositoryImpl extends UsersRepository {
  final SimpleRestClient _client = SimpleRestClient(
    'https://jsonplaceholder.typicode.com',
  );

  @override
  Future<List<UserModel>> getUsers() async {
    final ApiResponse response = await _client.get('/users');
    if (response.statusCode == 0 && response.data != null) {
      return (response.data as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList();
    }
    throw response;
  }
}
