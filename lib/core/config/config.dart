

class AppConfig {
  static late BaseConfig config;

  /// add config theo flavor (UAT, PROD, SIT)
  static void setEverionment({required BaseConfig valueConfig}) {
    config = valueConfig;
  }
}

abstract class BaseConfig {
  String get baseUrl;

  String get authUrl;
}
