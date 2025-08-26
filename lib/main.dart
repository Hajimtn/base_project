import 'package:common/base/base_controller.dart';
import 'package:common/base/base_widget.dart';
import 'package:common/controller/device_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/users/users_screen.dart';

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
