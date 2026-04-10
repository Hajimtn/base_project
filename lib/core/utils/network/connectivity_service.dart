import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Tracks network transport availability for API guard checks.
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool _isOnline = true.obs;

  StreamSubscription<dynamic>? _subscription;

  bool get isOnline => _isOnline.value;

  Future<ConnectivityService> init() async {
    await refreshStatus();
    _subscription = _connectivity.onConnectivityChanged.listen((dynamic event) {
      _isOnline.value = _hasConnectivity(event);
    });
    return this;
  }

  Future<bool> hasConnection() async {
    await refreshStatus();
    return _isOnline.value;
  }

  Future<void> refreshStatus() async {
    final dynamic result = await _connectivity.checkConnectivity();
    _isOnline.value = _hasConnectivity(result);
  }

  bool _hasConnectivity(dynamic result) {
    if (result is List<ConnectivityResult>) {
      return result.any(
        (ConnectivityResult item) => item != ConnectivityResult.none,
      );
    }

    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }

    return false;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
