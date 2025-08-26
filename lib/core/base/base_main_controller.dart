import 'package:base_project/core/utils/device/device_platform.dart';

import 'base_controller.dart';

abstract class BaseMainController<T> extends BaseController {
  BaseMainController({
    this.currentPageDesktop,
    required this.currentPage,
    required this.indexPageChange,
  });

  Worker? worker;
  final T currentPage;
  final T? currentPageDesktop;
  final Rx<T>? indexPageChange;
  T? get currentPageValue =>
      (DevicePlatformManager().typePlatform == TypePlatform.mobile) 
          ? currentPage
          : currentPageDesktop;

  @override
  void onInit() {
    if (indexPageChange != null) {
      worker = ever(
        indexPageChange!,
        (T pageChange) {
          if (DevicePlatformManager().typePlatform != TypePlatform.mobile) {
            if (pageChange == currentPageDesktop) {
              initPage();
            }
          } else {
            if (pageChange == currentPage) {
              initPage();
            }
          }
        },
      );
      if (indexPageChange!.value ==
          (DevicePlatformManager().typePlatform != TypePlatform.mobile
              ? currentPageDesktop
              : currentPage)) {
        initPage(onInit: true);
      }
    }

    super.onInit();
  }

  void initPage({bool onInit = false}) {
    worker?.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    worker?.dispose();
  }

  @override
  void onClose() {
    worker?.dispose();
    super.onClose();
  }

  bool get isCurrentPage => currentPageValue == indexPageChange?.value;
}
