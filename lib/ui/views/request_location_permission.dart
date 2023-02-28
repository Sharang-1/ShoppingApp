import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../services/location_service.dart';

class RequestLocationPermission extends StatelessWidget {
  const RequestLocationPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newBackgroundColor2,
      body: SafeArea(
        child: Container(
          child: Column(children: [
            Text("Allow location permission to continue using the app"),
            verticalSpaceMedium,
            ElevatedButton(
                onPressed: () {
                  Get.lazyPut(() => LocationService());
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: logoRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Allow")),
            ElevatedButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: logoRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Deny")),
          ]),
        ),
      ),
    );
  }
}
