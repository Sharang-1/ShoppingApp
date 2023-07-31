import 'package:compound/app/app.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/controllers/home_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/shared_pref.dart';
import 'controllers/lookup_controller.dart';
import 'locator.dart';
import 'logger.dart';
import 'services/api/api_service.dart';
import 'services/authentication_service.dart';
import 'services/localization_service.dart';
import 'ui/router.dart';
import 'ui/shared/app_colors.dart';
import 'ui/views/login_view.dart';
import 'ui/views/startup_view.dart';
import '../services/analytics_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/error_handling_service.dart';
import '../services/payment_service.dart';
import '../services/push_notification_service.dart';
import '../services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setup();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lang =
      prefs.getString(CurrentLanguage) ?? LocalizationService.langs[0];

  runApp(
    OverlaySupport(
      child: MyApp(lang: lang),
    ),
  );
}

final _authenticationService = locator<AuthenticationService>();
late var hasLoggedInUser;
late bool skipLogin;
final _apiService = locator<APIService>();

setup() async {
// Setup logger level
  appVar = App();
  setupLogger();
  // Register all the models and services before the app starts
  setupLocator();
  releaseMode
      ? appVar.currentUrl = appVar.liveUrl
      : appVar.currentUrl = appVar.devUrl;
  // Running flutter app
  // WidgetsFlutterBinding.ensureInitialized();

  //precache
  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    getDynamicKeys(),
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder, "assets/svg/logo.svg"),
      null,
    ),
  ]);

  print("Startup INIT");

  await Future.wait([
    locator<ErrorHandlingService>().init(),
    locator<PaymentService>().init(),
    locator<AnalyticsService>().setup(),
    locator<PushNotificationService>().initialise(),
    locator<RemoteConfigService>().init(),
    locator<DynamicLinkService>().handleDynamicLink(),
  ]);

  locator<LookupController>().setUpLookups(await _apiService.getLookups());

  hasLoggedInUser = await _authenticationService.isUserLoggedIn();
  var pref = await SharedPreferences.getInstance();
  skipLogin = pref.getBool(SkipLogin) ?? false;
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
          statusBarColor: logoRed, statusBarIconBrightness: Brightness.light),
    );

    return GetMaterialApp(
      title: 'host',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [],
      builder: (context, child) => ScrollConfiguration(
        behavior: CustomScrollOverlayBehaviour(),
        child: MediaQuery(
          child: child ?? Container(),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        ),
      ),
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
            //color: logoRed,
            //backgroundColor: logoRed,
            systemOverlayStyle: SystemUiOverlayStyle.light),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Poppins',
            ),
      ),
      home: (hasLoggedInUser || skipLogin) ? StartUpView() : LoginView(),
      onGenerateRoute: generateRoute,
      locale: LocalizationService.getLocaleFromLanguage(
          (lang.isEmpty) ? LocalizationService.langs[0] : lang),
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
    );
  }
}
