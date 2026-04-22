import 'package:fresh_base_project/base_run_main.dart';
import 'package:fresh_base_project/core/config/uat.config.dart';

Future<void> main() async {
  //todo3
  await BaseRunMain.runMainApp(config: UatConfig());
}
