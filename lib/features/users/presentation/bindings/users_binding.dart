import 'package:fresh_base_project/core/utils/network/rest_service.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_api_client.dart';
import 'package:fresh_base_project/features/users/data/datasources/users_remote_data_source.dart';
import 'package:fresh_base_project/features/users/data/repositories/users_repository_impl.dart';
import 'package:fresh_base_project/features/users/domain/repositories/users_repository.dart';
import 'package:fresh_base_project/features/users/domain/usecases/get_users_use_case.dart';
import 'package:fresh_base_project/features/users/presentation/controllers/users_controller.dart';
import 'package:get/get.dart';

/// Dependency graph for users feature.
class UsersBinding extends Bindings {
  @override
  void dependencies() {
    final UsersApiClient usersApiClient = UsersApiClient(RestService().dio);

    if (!Get.isRegistered<UsersApiClient>()) {
      Get.put<UsersApiClient>(usersApiClient, permanent: true);
    }

    if (!Get.isRegistered<UsersRemoteDataSource>()) {
      Get.lazyPut<UsersRemoteDataSource>(
        () => UsersRemoteDataSourceImpl(apiClient: usersApiClient),
        fenix: true,
      );
    }

    if (!Get.isRegistered<UsersRepository>()) {
      Get.lazyPut<UsersRepository>(
        () => UsersRepositoryImpl(remoteDataSource: Get.find()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<GetUsersUseCase>()) {
      Get.lazyPut<GetUsersUseCase>(
        () => GetUsersUseCase(Get.find()),
        fenix: true,
      );
    }

    if (!Get.isRegistered<UsersController>()) {
      Get.lazyPut<UsersController>(
        () => UsersController(getUsersUseCase: Get.find()),
      );
    }
  }
}
