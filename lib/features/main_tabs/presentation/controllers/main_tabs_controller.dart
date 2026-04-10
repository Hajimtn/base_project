import 'package:get/get.dart';

/// Controller that handles current index for bottom tabs.
class MainTabsController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// Changes active tab by [index].
  void changeTab(int index) {
    if (index == currentIndex.value) {
      return;
    }
    currentIndex.value = index;
  }
}
