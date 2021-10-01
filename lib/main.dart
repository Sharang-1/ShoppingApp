import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/shared_pref.dart';
import 'locator.dart';
import 'logger.dart';
import 'services/localization_service.dart';
import 'ui/router.dart';
import 'ui/shared/app_colors.dart';
import 'ui/views/startup_view.dart';

void main() async {
  setup();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lang = prefs?.getString(CurrentLanguage);
  runApp(
    OverlaySupport(
      child: MyApp(lang: lang),
    ),
  );
}

void setup() async {
// Setup logger level
  setupLogger();
  // Register all the models and services before the app starts
  setupLocator();

  // Running flutter app
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //precache
  await Future.wait([
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, "assets/svg/logo.svg"),
      null,
    ),
  ]);
}

class CustomScrollOverlayBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  final String lang;
  MyApp({this.lang});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
      ),
    );

    return GetMaterialApp(
      title: 'DZOR',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [],
      builder: (context, child) => ScrollConfiguration(
        behavior: CustomScrollOverlayBehaviour(),
        child: child,
      ),
      theme: ThemeData(
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
            ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
      locale: LocalizationService.getLocaleFromLanguage(
          (lang?.isEmpty ?? true) ? LocalizationService.langs[0] : lang),
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
    );
  }
}
