import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/error_handling_service.dart';
import '../services/navigation_service.dart';
import '../services/push_notification_service.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final APIService _apiService = locator<APIService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final PushNotificationService _notificationService =
      locator<PushNotificationService>();
  final DynamicLinkService _linkService = locator<DynamicLinkService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final productSearchHistoryList =
        prefs.getStringList(ProductSearchHistoryList);
    final sellerSearchHistoryList =
        prefs.getStringList(SellerSearchHistoryList);

    if (productSearchHistoryList == null)
      prefs.setStringList(ProductSearchHistoryList, []);
    if (sellerSearchHistoryList == null)
      prefs.setStringList(SellerSearchHistoryList, []);

    var updateDetails = await _apiService.getAppUpdate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    await Future.wait([
      _errorHandlingService.init(),
      _analyticsService.setup(),
      _notificationService.initialise(),
      _linkService.handleDynamicLink(),
    ]);

    if (kReleaseMode && (updateDetails.version != version)) {
      await Get.dialog(
          AlertDialog(
            title: Text(
              "New Version Available!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text("Please, update app to new version to continue."),
            actions: [
              TextButton(
                child: Text("Update App"),
                onPressed: () async {
                  await LaunchReview.launch(
                      androidAppId: "in.dzor.dzor_app", iOSAppId: "1562083632");
                },
              )
            ],
          ),
          barrierDismissible: false);
    } else {
      Future.delayed(Duration(milliseconds: 2000), () async {
        var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
        if (hasLoggedInUser) {
          _navigationService.navigateReplaceTo(HomeViewRoute);
        } else {
          _navigationService.navigateReplaceTo(MyHomePageRoute);
        }
      });
    }
  }
}
