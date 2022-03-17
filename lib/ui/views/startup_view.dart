import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/startup_controller.dart';
import '../shared/app_colors.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder(
        init: StartUpController(),
        builder: (controller) => Scaffold(
          backgroundColor: newBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/svg/dzor_logo.svg",
                    color: logoRed,
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("India ke Home-Grown brands",
                    style: TextStyle(color: textIconBlue, fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                    Text("ka apna App",
                      style: TextStyle(color: textIconBlue, fontWeight: FontWeight.w700, fontSize: 20),
                    ),]
                  ,
                ),
              ),

            ],
          ),
        ),
      );
}
