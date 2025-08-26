import 'dart:async';
import 'dart:io';

import 'package:base_project/core/config/config.dart';
import 'package:base_project/locator.dart';
import 'package:base_project/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseRunMain {
  static Future<void> runMainApp({required BaseConfig config}) async {
    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await setupLocator(config);
      AppConfig.setEverionment(valueConfig: config);

      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ]);

      HttpOverrides.global = MyHttpOverrides();
      runApp(const App());
    }, (Object error, StackTrace stackTrace) {});
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
