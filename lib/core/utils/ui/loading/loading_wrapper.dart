import 'package:base_project/core/base/base_controller.dart';
import 'package:base_project/core/base/base_page.dart';
import 'package:base_project/core/base/loading_controller.dart';
import 'package:base_project/core/utils/ui/loading/app_loading.dart';


class LoadingWrapper extends BaseScreen<LoadingController> {
  LoadingWrapper({super.key, this.child});

  final Widget? child;
  @override
  Widget builder(BuildContext context) {
    return Stack(children: <Widget>[
      child ?? SizedBox(),
      Obx(() => Visibility(
          visible: controller.loadingCtrl.value,
          child: ColoredBox(
              color: Color(0xFF131615).withValues(alpha: 0.5), child: appLoading)))
    ]);
  }

  @override
  LoadingController? putController() {
    return LoadingController();
  }
}
