import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../services/api/api_service.dart';
import '../../services/dialog_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class StartUpView extends StatefulWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  State<StartUpView> createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;
  double _position = -1;
  String name = '';
  double headingFontSize = headingFontSizeStyle + 15;
  final _apiService = locator<APIService>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _animationController.forward();
  }

  _versionCheck() async {
    final updateDetails = await _apiService.getAppUpdate();
    print("Startup INIT");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Version currentVersion = Version.parse(packageInfo.version);
    Version latestVersion = Version.parse(updateDetails!.version);

    if (false) {
      // if (releaseMode && (latestVersion > currentVersion)) {
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
  }

  // Widget build(BuildContext context) => GetBuilder(
  //       init: StartUpController(),
  // builder: (controller) => Scaffold(
  //   backgroundColor: newBackgroundColor,
  //   body: Stack(children: [
  //     Image.asset(
  //       "assets/images/product_preloading.jpg",
  //       fit: BoxFit.cover,
  //       alignment: Alignment.center,
  //       height: MediaQuery.of(context).size.height,
  //     ),
  //     Center(
  //       child: Image.asset(
  //         "assets/images/host_logo.png",
  //         // color: logoRed,
  //         width: MediaQuery.of(context).size.width / 2,
  //         fit: BoxFit.contain,
  //       ),
  //     ),
  //   ]),
  //   // Column(
  //   //   mainAxisAlignment: MainAxisAlignment.center,
  //   //   crossAxisAlignment: CrossAxisAlignment.center,
  //   //   children: [

  //   //     Padding(
  //   //       padding: const EdgeInsets.only(bottom: 50),
  //   //       child: Center(
  //   //         child: Image.asset(
  //   //           "assets/images/host_logo.png",
  //   //           // color: logoRed,
  //   //           width: MediaQuery.of(context).size.width / 2,
  //   //           fit: BoxFit.contain,
  //   //         ),
  //   //       ),
  //   //     ),
  //   //     Padding(
  //   //       padding: const EdgeInsets.only(top: 30.0),
  //   //       child: Column(
  //   //         crossAxisAlignment: CrossAxisAlignment.center,
  //   //         children: [Text("India ke Home-Grown brands",
  //   //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
  //   //         ),
  //   //           Text("ka apna App",
  //   //             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
  //   //           ),]
  //   //         ,
  //   //       ),
  //   //     ),
  //   //   ],
  //   // ),
  // ),
  @override
  Widget build(BuildContext context) {
    const double headingFontSize = headingFontSizeStyle + 15;
    return FutureBuilder<String>(
      future: locator<APIService>().updateUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          name = snapshot.data ?? "";
        }
        Future.delayed(Duration(milliseconds: 2000), () async {
          await _versionCheck();
          await Get.toNamed(HomeViewRoute);
        });
        return Scaffold(
          backgroundColor: newBackgroundColor,
          body: AnimatedBuilder(
            animation: _animation,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome Back...",
                    style: TextStyle(
                      fontSize: headingFontSize,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: headingFontSize + 5,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0,
                    MediaQuery.of(context).size.height *
                        _position *
                        (1 - _animation.value)),
                child: AnimatedOpacity(
                  duration: _animationController.duration!,
                  opacity: _animation.value,
                  curve: Curves.ease,
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
