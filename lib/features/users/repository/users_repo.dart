import '../models/user_model.dart';

abstract class UsersRepository {
  Future<List<UserModel>> getUsers();
}
