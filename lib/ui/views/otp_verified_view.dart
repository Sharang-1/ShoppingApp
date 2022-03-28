import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/route_names.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../widgets/circular_progress_indicator.dart';

class OtpVerifiedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(milliseconds: 3000),
      () async {
        NavigationService.off(OtpVerified2Route);
      },
    );
    return Scaffold(
      backgroundColor: newBackgroundColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              // color: logoRed,
              width: MediaQuery.of(context).size.width / 2.5,
              height: MediaQuery.of(context).size.width / 2.5,
            ),
            CircularProgressIndicatorWidget(
              fromCart: false,
            )
          ],
        ),
      ),
    );
  }
}
