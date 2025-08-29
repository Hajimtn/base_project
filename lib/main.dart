import 'core/base/base_controller.dart';
import 'core/base/base_widget.dart';
import 'core/utils/device_manager.dart';
import 'features/users/view/pages/users_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeviceManager().init();
  
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Base Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: UsersScreen(),
    );
  }
}
