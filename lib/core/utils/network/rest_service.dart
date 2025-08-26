import 'package:base_project/core/config/config.dart';
import 'package:base_project/core/utils/network/rest_client.dart';
import 'package:dio/dio.dart';

class RestService extends BaseRestClient {
  factory RestService() {
    _singleton ??= RestService._internal(
      AppConfig.config.baseUrl,
      interceptors: null,
    );
    return _singleton!;
  }

  RestService._internal(String baseUrl, {List<Interceptor>? interceptors})
    : super(baseUrl, interceptors);

  static RestService? _singleton;
}
