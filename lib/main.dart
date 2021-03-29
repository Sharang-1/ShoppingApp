// import 'package:compound/services/analytics_service.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:compound/services/error_handling_service.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'locator.dart';
import 'logger.dart';
import 'managers/dialog_manager.dart';
import 'models/CartCountSetUp.dart';
import 'models/LookupSetUp.dart';
import 'models/WhishListSetUp.dart';
import 'services/dialog_service.dart';
import 'services/navigation_service.dart';
import 'ui/router.dart';
// import 'package:catcher/catcher.dart';

void main() {
  // Setup logger level
  setupLogger();
  // Register all the models and services before the app starts
  setupLocator();
  // Running flutter app
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  loadImgs();

  runApp(OverlaySupport(child: MyApp()));

  // Catcher(
  //   runAppFunction: () => runApp(OverlaySupport(child: MyApp())),
  //   debugConfig: debugOptions,
  //   releaseConfig: releaseOptions,
  //   navigatorKey: locator<NavigationService>().navigationKey
  // );
}

class CustomScrollOverlayBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backgroundWhiteCreamColor,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartCountSetUp>(
            create: (context) => CartCountSetUp(count: 0)),
        ChangeNotifierProvider<WhishListSetUp>(
            create: (context) => WhishListSetUp(list: [])),
        ChangeNotifierProvider<LookupSetUp>(create: (context) => LookupSetUp()),
      ],
      child: GetMaterialApp(
        title: 'DZOR',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [],
        builder: (context, child) => ScrollConfiguration(
          behavior: CustomScrollOverlayBehaviour(),
          child: Navigator(
            key: locator<DialogService>().dialogNavigationKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(child: child),
            ),
          ),
        ),
        // navigatorKey: Catcher.navigatorKey,
        navigatorKey: locator<NavigationService>().navigationKey,
        theme: ThemeData(
          primaryColor: primaryColor,
          appBarTheme: AppBarTheme(brightness: Brightness.light),
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Raleway',
              ),
        ),
        home: StartUpView(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

loadImgs() async {
  return Future.wait([
    precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, "assets/svg/logo.svg"),
      null,
    ),
  ]);
}
