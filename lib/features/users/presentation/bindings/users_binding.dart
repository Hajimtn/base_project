import 'package:fresh_base_project/core/utils/network/rest_service.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_api_client.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_remote_data_source.dart';
import 'package:fresh_base_project/features/users/data/repositories/users_repository_impl.dart';
import 'package:fresh_base_project/features/users/domain/usecases/get_users_use_case.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart';

/// Dependency factory for users feature.
class UsersBinding {
  const UsersBinding._();

  static UsersController createController() {
    final UsersApiClient usersApiClient = UsersApiClient(RestService().dio);
    final UsersRemoteDataSource remoteDataSource = UsersRemoteDataSourceImpl(
      apiClient: usersApiClient,
    );
    final UsersRepositoryImpl usersRepository = UsersRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final GetUsersUseCase getUsersUseCase = GetUsersUseCase(usersRepository);

    return UsersController(getUsersUseCase: getUsersUseCase);
  }
}
