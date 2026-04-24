import 'package:fresh_base_project/core/base/loading_controller.dart';
import 'package:fresh_base_project/core/themes/core/app_theme_manager.dart';
import 'package:fresh_base_project/core/utils/device/device_manager.dart';
import 'package:fresh_base_project/core/utils/logging/app_log.dart';
import 'package:fresh_base_project/core/utils/network/auth_token_store.dart';
import 'package:fresh_base_project/core/utils/network/connectivity_service.dart';
import 'package:fresh_base_project/core/utils/ui/app_locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppLocator {
  AppLocator._();

  static final Map<Type, Object> _singletons = <Type, Object>{};

  static void put<T extends Object>(T instance) {
    _singletons[T] = instance;
  }

  static T get<T extends Object>() {
    final Object? instance = _singletons[T];
    if (instance == null) {
      throw StateError('Service $T is not registered.');
    }
    return instance as T;
  }

  static bool isRegistered<T extends Object>() {
    return _singletons.containsKey(T);
  }
}

Future<void> setupLocator() async {
  await DeviceManager().init();
  await AppLog().init();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final AuthTokenStore authTokenStore = AuthTokenStore(preferences: prefs);
  await authTokenStore.init();

  AppLocator.put<SharedPreferences>(prefs);
  AppLocator.put<AuthTokenStore>(authTokenStore);
  AppLocator.put<LoadingController>(LoadingController());
  AppLocator.put<AppThemeManger>(AppThemeManger(preferences: prefs));
  AppLocator.put<AppLocaleController>(
    AppLocaleController(preferences: prefs),
  );
  AppLocator.put<ConnectivityService>(await ConnectivityService().init());
}
