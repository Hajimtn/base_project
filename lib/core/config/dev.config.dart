
import 'package:base_project/core/config/config.dart';


// DEV
class DEVConfig extends BaseConfig {
  @override
  String get baseUrl => 'https://api.example.com';

  @override
  String get authUrl => 'https://auth.example.com';
}
