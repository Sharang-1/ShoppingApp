import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/error_handling_service.dart';
import '../services/navigation_service.dart';
import '../services/push_notification_service.dart';
import '../services/remote_config_service.dart';
import 'base_controller.dart';

class StartUpController extends BaseController {
  final _authenticationService = locator<AuthenticationService>();
  final _apiService = locator<APIService>();

  @override
  void onInit() async {
    super.onInit();
    final updateDetails = await _apiService.getAppUpdate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    await Future.wait([
      locator<ErrorHandlingService>().init(),
      locator<AnalyticsService>().setup(),
      locator<PushNotificationService>().initialise(),
      locator<DynamicLinkService>().handleDynamicLink(),
      locator<RemoteConfigService>().init(),
    ]);

    if (kReleaseMode && (updateDetails.version != version)) {
      await DialogService.showCustomDialog(
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
        barrierDismissible: false,
      );
    } else {
      Future.delayed(
        Duration(milliseconds: 1500),
        () async {
          var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
          await NavigationService.off(
              hasLoggedInUser ? HomeViewRoute : IntroPageRoute);
        },
      );
    }
  }
}
