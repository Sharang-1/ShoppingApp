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
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/svg/dzor_logo.svg",
                  color: logoRed,
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("India Ke Home Grown Brands ka Apna App")
              ),
            ],
          ),
        ),
      );
}
