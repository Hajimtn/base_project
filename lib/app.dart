import 'package:base_project/core/utils/logging/alice.dart';
import 'package:base_project/core/utils/ui/app_router.dart';
import 'package:base_project/core/utils/ui/loading/loading_wrapper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/base/base_controller.dart';
import 'core/base/base_widget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        AliceUtils().alice!.showInspector();
      },
      child: GetMaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi'), Locale('en')],
        navigatorKey: AliceUtils().getNavigatorKey,
        locale: Get.locale,
        initialRoute: AppRouter.routerUsers,
        getPages: AppRouter.getPages,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return LoadingWrapper(child: child!);
        },
      ),
    );
  }
}
