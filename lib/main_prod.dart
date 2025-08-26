import 'package:base_project/base_run_main.dart';
import 'package:base_project/core/config/prod.config.dart';

Future<void> main() async {
  BaseRunMain.runMainApp(config: PRODConfig());
}
