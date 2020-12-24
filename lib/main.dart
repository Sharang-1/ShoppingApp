import 'package:compound/logger.dart';
import 'package:compound/models/CartCountSetUp.dart';
import 'package:compound/models/LookupSetUp.dart';
import 'package:compound/models/WhishListSetUp.dart';
// import 'package:compound/services/analytics_service.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/views/startup_view.dart';
import 'package:compound/ui/views/intro.dart';
import 'package:flutter/material.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';
import 'package:flutter/services.dart';

void main() {
  // Setup logger level
  setupLogger();
  // Register all the models and services before the app starts
  setupLocator();
  // Running flutter app
  runApp(MyApp());
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
