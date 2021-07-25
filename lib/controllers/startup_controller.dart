import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version/version.dart';

import '../constants/route_names.dart';
import '../constants/server_urls.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/error_handling_service.dart';
import '../services/navigation_service.dart';
import '../services/payment_service.dart';
import '../services/push_notification_service.dart';
import '../services/remote_config_service.dart';
import 'base_controller.dart';
import 'lookup_controller.dart';

class StartUpController extends BaseController {
  final _authenticationService = locator<AuthenticationService>();
  final _apiService = locator<APIService>();

  @override
  void onInit() async {
    super.onInit();
    final updateDetails = await _apiService.getAppUpdate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Version currentVersion = Version.parse(packageInfo.version);
    Version latestVersion = Version.parse(updateDetails.version);

    await Future.wait([
      locator<ErrorHandlingService>().init(),
      locator<PaymentService>().init(),
      locator<AnalyticsService>().setup(),
      locator<PushNotificationService>().initialise(),
      locator<DynamicLinkService>().handleDynamicLink(),
      locator<RemoteConfigService>().init(),
    ]);

    locator<LookupController>().setUpLookups(await _apiService.getLookups());

    if (releaseMode && (latestVersion > currentVersion)) {
      await DialogService.showCustomDialog(
        AlertDialog(
          title: Text(
            "New Version Available!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Please, Update App to New Version."),
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
        barrierDismissible:
            !(((updateDetails?.priority?.priority ?? 0) > 0) ?? false),
      );
      if (((updateDetails?.priority?.priority ?? 0) > 0) ?? false) return;
    }

    Future.delayed(
      Duration(milliseconds: 1500),
      () async {
        var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
        var pref = await SharedPreferences.getInstance();
        bool skipLogin = pref.getBool(SkipLogin) ?? false;
        await NavigationService.off(
            (hasLoggedInUser || skipLogin) ? HomeViewRoute : IntroPageRoute);
      },
    );
  }
}
