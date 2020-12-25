import 'package:compound/viewmodels/verify_otp_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/circular_progress_indicator.dart';
import '../shared/app_colors.dart';

class OtpVerifiedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
      viewModel: VerifyOTPViewModel(),
      onModelReady: (model) => model.otpVerified(),
       builder: (context, model, child) => Scaffold(
         backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: CircularProgressIndicatorWidget(),
        ),
       ),
    );
  }
}