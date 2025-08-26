import 'package:base_project/core/utils/network/rest_client.dart';
import 'package:base_project/core/utils/network/rest_service.dart';
import 'package:base_project/core/utils/ui/app_url.dart';
import 'package:base_project/features/users/models/user_model.dart';
import 'package:base_project/features/users/repository/users_repo.dart';
import 'package:base_project/core/utils/network/api_response.dart';

class UserRepositoryImpl extends UsersRepository {
  final BaseRestClient _client = RestService();

  @override
  Future<List<UserModel>> getUsers() async {
    final ApiResponse response = await _client.get(AppUrl.users);
    if (response.statusCode == 0 && response.data != null) {
      return (response.data as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList();
    }
    throw response;
  }
}
