import 'base_mixin.dart';

abstract class BaseScreen extends StatelessWidget with BaseMixin {
  const BaseScreen({super.key});

  Widget builder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

abstract class BaseScreenStateful<SF extends StatefulWidget>
    extends State<SF>
    with BaseMixin {
  Widget builder(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
