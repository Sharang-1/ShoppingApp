import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../viewmodels/verify_otp_model.dart';
import '../shared/app_colors.dart';
import '../widgets/circular_progress_indicator.dart';

class OtpVerifiedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
      viewModel: VerifyOTPViewModel(),
      onModelReady: (model) => model.otpVerified(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/svg/logo.svg",
                color: logoRed,
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
              CircularProgressIndicatorWidget(
                fromCart: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
