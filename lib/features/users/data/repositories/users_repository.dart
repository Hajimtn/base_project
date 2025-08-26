import 'package:common/data/source/api_response.dart';
import 'package:common/data/source/rest_client.dart';
import '../models/user_model.dart';

class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? message;

  ApiResult({
    required this.isSuccess,
    this.data,
    this.message,
  });
}

class UsersRepository {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  late final RestClient _client;

  UsersRepository() {
    _client = RestClient(_baseUrl, null);
  }

  Future<ApiResult<List<UserModel>>> getUsers() async {
    try {
      final response = await _client.get('/users');
      
      if (response is List) {
        final List<UserModel> users = response
            .map((userJson) => UserModel.fromJson(userJson))
            .toList();
        
        return ApiResult<List<UserModel>>(
          isSuccess: true,
          data: users,
          message: 'Lấy danh sách người dùng thành công',
        );
      } else {
        return ApiResult<List<UserModel>>(
          isSuccess: false,
          data: [],
          message: 'Dữ liệu không đúng định dạng',
        );
      }
    } catch (e) {
      return ApiResult<List<UserModel>>(
        isSuccess: false,
        data: [],
        message: 'Lỗi: $e',
      );
    }
  }

  Future<ApiResult<UserModel>> getUserById(int id) async {
    try {
      final response = await _client.get('/users/$id');
      
      if (response is Map<String, dynamic>) {
        final user = UserModel.fromJson(response);
        
        return ApiResult<UserModel>(
          isSuccess: true,
          data: user,
          message: 'Lấy thông tin người dùng thành công',
        );
      } else {
        return ApiResult<UserModel>(
          isSuccess: false,
          data: null,
          message: 'Dữ liệu không đúng định dạng',
        );
      }
    } catch (e) {
      return ApiResult<UserModel>(
        isSuccess: false,
        data: null,
        message: 'Lỗi: $e',
      );
    }
  }
}
