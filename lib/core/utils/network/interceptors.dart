import 'dart:convert';

import 'package:base_project/core/core.dart' hide Response;
import 'package:base_project/core/utils/logging/app_log.dart';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class LoggingInterceptor implements InterceptorsWrapper {
  String _getLastPath(String? url) {
    final List<String>? parts = url?.split('/');
    final String? lastPart = parts?.last;
    return lastPart ?? '';
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final String lastPart = _getLastPath(err.requestOptions.path);

    final String keyResponse = err.requestOptions.extra['key'] ?? 'Unknown';
    if (err.response?.data is Map || err.response?.data is List) {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${jsonEncode(err.response?.data)} -- [Key = $keyResponse] -- [STATUS = 2]',
      );
    } else {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${err.response?.data} -- [Key = $keyResponse] -- [STATUS = 2]',
      );
    }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String lastPart = _getLastPath(options.path);

    final String key = Uuid().v4();
    options.extra['key'] = key;

    AppLog.log.info(
      '$lastPart ===> [URL]: ${options.method} ${options.baseUrl}${options.path} -- [Key = $key] -- [STATUS = 0]',
    );

    if (options.data != null) {
      AppLog.log.info(
        '$lastPart ===> [REQUEST DATA]: ${options.data} -- [Key = $key]',
      );
    } else if (options.queryParameters.isNotEmpty) {
      if (!options.path.contains('login')) {
        AppLog.log.info(
          '$lastPart ===> [REQUEST queryParameters]: ${options.queryParameters} -- [Key = $key] -- [STATUS = 0]',
        );
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final String lastPart = _getLastPath(response.requestOptions.path);

    final String key = response.requestOptions.extra['key'] ?? 'Unknown';
    if (response.data is Map || response.data is List) {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${jsonEncode(response.data)} -- [Key = $key] -- [STATUS = 0]',
      );
    } else {
      AppLog.log.info(
        '$lastPart <=== [RESPONSE DATA]:${response.data} -- [Key = $key] -- [STATUS = 0]',
      );
    }

    return handler.next(response);
  }
}

class SessionInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(<String, dynamic>{
      'deviceId': DeviceManager().deviceInfo.deviceId,
      'User-Agent': jsonEncode(DeviceManager().deviceInfo.deviceInfo),
      'x-client-request-id': Uuid().v4(),
      'channel': 'App',
      'Mac-Address': '',
      'ClientTime': DateTime.now().formatDDMMYYYHHMMSS,
      'Platform': DevicePlatformManager().devicePlatform.value,
    });
    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.data is String) {
      response.data = jsonDecode(response.data as String);
    }

    if (response.data is Map) {
      switch (response.data['errorCode']) {}
    }
    return handler.next(response);
  }
}

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this.dio);
  final Dio dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode ?? 0) {
      case 401:
        // TODO: Handle session expired here.
        break;
      default:
        break;
    }
    return handler.next(err);
  }
}
