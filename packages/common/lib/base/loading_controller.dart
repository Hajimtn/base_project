import 'package:get/get.dart';

class LoadingController extends GetxController {
  final Rx<bool> loadingCtrl = Rx<bool>(false);
  int _count = 0;

  void show() {
    _count += 1;

    if (_count == 1) {
      loadingCtrl.value = true;
    }
  }

  void hide() {
    if (_count > 0) {
      _count--;
    }

    if (_count == 0) {
      loadingCtrl.value = false;
    }
  }

  void hideAll() {
    _count = 0;

    loadingCtrl.value = false;
  }
}
