import 'package:compound/app/app.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/controllers/home_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
  await setup();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("promotion_product_share", 0);
  String lang =
      prefs.getString(CurrentLanguage) ?? LocalizationService.langs[0];
  await Firebase.initializeApp();

  runApp(
    OverlaySupport(
      child: MyApp(lang: lang),
    ),
  );
}

 setup() async {
// Setup logger level
  appVar = App();
  setupLogger();
  // Register all the models and services before the app starts
  setupLocator();
  !(releaseMode) ? appVar.currentUrl = appVar.devUrl : appVar.currentUrl = appVar.liveUrl;
  // if (kReleaseMode)
  //   appVar.currentUrl = appVar.liveUrl;
  // else
  //   appVar.currentUrl = appVar.devUrl;
  await getDynamicKeys();
  // Running flutter app
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //precache
  await Future.wait([
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder, "assets/svg/logo.svg"),
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
  MyApp({required this.lang});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: logoRed,
        statusBarIconBrightness: Brightness.light
      ),
    );

    return GetMaterialApp(
      title: 'DZOR',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [],
      builder: (context, child) => ScrollConfiguration(
        behavior: CustomScrollOverlayBehaviour(),
        child: child ?? Container(),
      ),
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
            ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
      locale: LocalizationService.getLocaleFromLanguage(
          (lang.isEmpty) ? LocalizationService.langs[0] : lang),
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
    );
  }
}
