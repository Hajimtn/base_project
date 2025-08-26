import 'base_mixin.dart';

abstract class BaseScreen<T extends GetxController> extends StatelessWidget
    with BaseMixin {
  BaseScreen({T? screenController, this.tag, bool isKeep = false, super.key}) {
    if (screenController == null) {
      setController(isKeep: isKeep);
    } else {
      setController(screenController: screenController, isKeep: isKeep);
    }
  }

  late final String? tag;
  late final T controller;

  late final BuildContext context = Get.context!;

  T? putController();

  String? get getTag => tag;

  void setController({T? screenController, bool isKeep = false}) {
    T? tempC;
    if (screenController != null) {
      tempC = screenController;
    } else if (!Get.isRegistered<T>(tag: getTag)) {
      tempC = putController();
    }

    if (tempC != null) {
      controller = GetInstance().put<T>(tempC, permanent: isKeep, tag: getTag);
    } else {
      controller = GetInstance().find<T>(tag: getTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  Widget builder(BuildContext context);
}

abstract class BaseScreenStateful<
  SF extends StatefulWidget,
  T extends GetxController
>
    extends State<SF>
    with BaseMixin {
  BaseScreenStateful({this.isKeep = false});

  @override
  void initState() {
    setController(isKeep: isKeep);
    super.initState();
  }

  String? get tagController => null;
  final bool isKeep;

  late T controller;

  T? putController();

  void setController({T? screenController, bool isKeep = false}) {
    T? tempC;
    if (screenController != null) {
      tempC = screenController;
    } else if (!Get.isRegistered<T>(tag: tagController)) {
      tempC = putController();
    }

    if (tempC != null) {
      controller = GetInstance().put<T>(
        tempC,
        permanent: isKeep,
        tag: tagController,
      );
    } else {
      controller = GetInstance().find<T>(tag: tagController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }

  Widget builder(BuildContext context);

  @override
  void dispose() {
    if (!isKeep) {
      Get.delete<T>(tag: tagController);
    }
    super.dispose();
  }
}
