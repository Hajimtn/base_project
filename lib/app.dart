import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fresh_base_project/core/config/config.dart';
import 'package:fresh_base_project/core/utils/logging/alice.dart';
import 'package:fresh_base_project/core/utils/ui/app_router.dart';
import 'package:fresh_base_project/core/utils/ui/loading/loading_wrapper.dart';
import 'package:fresh_base_project/l10n/app_localizations.dart';
import 'package:get/get.dart';

/// Root app widget.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress:
          AppConfig.config.enableAlice
              ? () => AliceUtils().alice?.showInspector()
              : null,
      child: GetMaterialApp(
        onGenerateTitle: (BuildContext context) => AppConfig.config.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[Locale('vi'), Locale('en')],
        navigatorKey:
            AppConfig.config.enableAlice ? AliceUtils().getNavigatorKey : null,
        locale: Get.locale,
        initialRoute: AppRouter.routerMainTabs,
        getPages: AppRouter.getPages,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? child) {
          return LoadingWrapper(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
