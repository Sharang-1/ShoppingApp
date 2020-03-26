import 'package:compound/logger.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/views/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'managers/dialog_manager.dart';
import 'ui/router.dart';
import 'locator.dart';

void main() {
  // Setup logger level
  setupLogger();  
  // Register all the models and services before the app starts
  setupLocator();
  // Running flutter app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compound',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        locator<AnalyticsService>().getAnalyticsObserver(),
      ],
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: primaryColor,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
      ),
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
