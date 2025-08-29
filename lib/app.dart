import 'core/base/base_controller.dart';
import 'core/base/base_widget.dart';
import 'features/users/view/pages/users_screen.dart';



class App extends StatelessWidget {
  const App({super.key});

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
