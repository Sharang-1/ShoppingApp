import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
    print("Startup INIT");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Version currentVersion = Version.parse(packageInfo.version);
    Version latestVersion = Version.parse(updateDetails!.version);

    await Future.wait([
      locator<ErrorHandlingService>().init(),
      locator<PaymentService>().init(),
      locator<AnalyticsService>().setup(),
      locator<PushNotificationService>().initialise(),
      locator<RemoteConfigService>().init(),
      locator<DynamicLinkService>().handleDynamicLink(),
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
              child : Text("Update App"),
              onPressed: ()  {
                 Platform.isAndroid
                    ? launch(
                        "https://play.google.com/store/apps/details?id=in.dzor.dzor_app&hl=en_IN&gl=US")
                    : launch("https://apps.apple.com/in/app/dzor/id1562083632");
              },
            )
          ],
        ),
        barrierDismissible: !(((updateDetails.priority?.priority ?? 0) > 0)),
      );
      if (((updateDetails.priority?.priority ?? 0) > 0)) return;
    }

    Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
        var pref = await SharedPreferences.getInstance();
        bool skipLogin = pref.getBool(SkipLogin) ?? false;
        await NavigationService.off(
            (hasLoggedInUser || skipLogin) ? HomeViewRoute : IntroPageRoute,
            preventDuplicates: true);
      },
    );
  }
}
