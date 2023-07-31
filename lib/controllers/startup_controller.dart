import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

import '../constants/route_names.dart';
import '../constants/server_urls.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import 'base_controller.dart';

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
              onPressed: () {
                Platform.isAndroid
                    ? launchUrlString(
                        "https://play.google.com/store/apps/details?id=in.host.host_app&hl=en_IN&gl=US")
                    : launchUrlString(
                        "https://apps.apple.com/in/app/host/id1562083632");
              },
            )
          ],
        ),
        barrierDismissible: !(((updateDetails.priority?.priority ?? 0) > 0)),
      );
      if (((updateDetails.priority?.priority ?? 0) > 0)) return;
    }

    Future.delayed(
      Duration(milliseconds: 0),
      () async {
        var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
        var pref = await SharedPreferences.getInstance();
        bool skipLogin = pref.getBool(SkipLogin) ?? false;
        await NavigationService.off(
            // (hasLoggedInUser || skipLogin) ? HomeViewRoute : IntroPageRoute,
            (hasLoggedInUser || skipLogin) ? HomeViewRoute : LoginViewRoute,
            preventDuplicates: true);
      },
    );
  }
}
