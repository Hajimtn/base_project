import 'package:dio/dio.dart';
import 'api_response.dart';

class SimpleRestClient {
  final String baseUrl;
  late Dio _dio;

  SimpleRestClient(this.baseUrl) {
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
  }

  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );

      return ApiResponse(
        statusCode: 0,
        data: response.data,
        message: 'Success',
      );
    } catch (e) {
      return ApiResponse(statusCode: 1, data: null, message: e.toString());
    }
  }

  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse(
        statusCode: 0,
        data: response.data,
        message: 'Success',
      );
    } catch (e) {
      return ApiResponse(statusCode: 1, data: null, message: e.toString());
    }
  }
}
