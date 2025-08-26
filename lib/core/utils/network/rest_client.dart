import 'dart:convert';

import 'package:base_project/core/utils/logging/alice.dart';
import 'package:base_project/core/utils/network/api_error.dart';
import 'package:base_project/core/utils/ui/app_const.dart';
import 'package:base_project/core/utils/network/interceptors.dart';
import 'package:base_project/core/utils/network/api_response.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class BaseRestClient {
  BaseRestClient(this.baseUrl, List<Interceptor>? interceptors) {
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: AppConst.connectTimeout),
      receiveTimeout: Duration(seconds: AppConst.receiveTimeout),
      contentType: formUrlEncodedContentType,
      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    //  _dio.httpClientAdapter = NativeAdapter();
    final CookieJar cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));
    _dio.interceptors.addAll(<Interceptor>[
      SessionInterceptor(),
      LoggingInterceptor(),
      RefreshTokenInterceptor(_dio),
      AliceUtils().aliceDioAdapter,
      ...interceptors ?? <Interceptor>[],
    ]);
    // _dio.interceptors.add(RefreshTokenInterceptor(_dio));
  }

  // static const Duration defaultTimeout = Duration(seconds: AppConfig.config.isBroker? 1800 : 30);
  static const String formUrlEncodedContentType =
      'application/x-www-form-urlencoded;charset=UTF-8';
  final String baseUrl;
  late Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> getDataChart(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> getFullResponse(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response<dynamic> response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  ApiError _mapError(dynamic e) {
    if (e is DioException) {
      String? code = e.response?.statusCode.toString();

      switch (e.type) {
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiError(message: '$errorString} ${_getCode(code)}');
        case DioExceptionType.badResponse:
          if (code!.isNotEmpty) {
            code.replaceAll('-', '_');
          }
          // Bắt riêng lỗi 500 - Internal Server Error
          if (code == '500' ||
              code == '501' ||
              code == '502' ||
              code == '503') {
            return ApiError(
              errorCode: code,
              message: '$errorString} ${_getCode(code)}',
            );
          }

          if (code == '400' &&
              e.response?.data != null &&
              e.response?.data is Map) {
            final ApiResponse apiResponse = ApiResponse.fromJson(
              e.response?.data as Map<String, dynamic>,
            );
            return ApiError(
              errorCode: apiResponse.errorCode,
              message: apiResponse.message,
              extraData: apiResponse.data,
              params: apiResponse.params,
            );
          }

          String? msg = 'ERROR$code'.tr;
          List<String> params = <String>[];
          if (e.response?.data != null && e.response?.data is Map) {
            try {
              final dynamic errorData = e.response!.data;
              code = (errorData['code']?.toString() ?? code).replaceAll(
                '-',
                '_',
              );

              msg = 'ERROR$code'.tr;

              if (msg.startsWith('ERROR')) {
                msg = '';
              }

              if (msg.isEmpty) {
                msg = '$errorString} ${_getCode(code)}';
              }
              params = List<String>.from(e.response?.data['params']);
            } catch (error) {
              /// Không cần print ở đây trong intercepter đã log rồi
            }
          }

          return ApiError(
            errorCode: code,
            message: msg,
            extraData: e.response?.data,
            params: params,
          );
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
        default:
          return ApiError(
            errorCode: '${e.error}',
            message: '$errorString} ${e.error}',
            extraData: e.response?.data,
          );
      }
    }

    if (e is ApiError) {
      return ApiError(
        errorCode: e.errorCode,
        message: e.message ?? '$errorString ${_getCode(e.errorCode)}',
        params: e.params,
      );
    }

    return ApiError(
      errorCode: '${e.errorCode}',
      message: e.message ?? errorString,
      extraData: e?.dataRequest,
    );
  }

  dynamic _mapResponse(dynamic response) {
    dynamic res;
    if (response is String) {
      res = jsonDecode(response);
      final ApiResponse apiResponse = ApiResponse.fromJson(
        res as Map<String, dynamic>,
      );
      return apiResponse;
    } else if (response is List) {
      return ApiResponse.fromJson(<String, dynamic>{
        'statusCode': 0,
        'data': response,
      });
    } else if (response is Map) {
      if (response.containsKey('access_token')) {
        return response;
      }
      final ApiResponse apiResponse = ApiResponse.fromJson(
        response as Map<String, dynamic>,
      );

      if (apiResponse.statusCode == 1) {
        throw ApiError.fromResponse(apiResponse);
      }
      return apiResponse;
    }

    // if (apiResponse.statusCode != 0) {
    throw ApiError(extraData: response);
  }

  String _getCode(String? code) =>
      (code != null && code.isNotEmpty && !code.contains('null'))
          ? '[$code]'
          : '';

  String get errorString =>
      'There is an error connecting to the server, please try again.';
}
