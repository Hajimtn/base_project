

class AppConfig {
  static late BaseConfig config;
  static void setConfig({required BaseConfig valueConfig}) {
    config = valueConfig;
  }

}

abstract class BaseConfig {
  String get baseUrl;

  String get webSocketUrl;

  String get prefix;

}
