import 'dart:async';

import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/app_title.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/ui/widgets/text_link.dart';
import 'package:compound/viewmodels/verify_otp_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class VerifyOTPView extends StatefulWidget {
  @override
  _VerifyOTPViewState createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  final otpController = TextEditingController();

  final oneSec = const Duration(seconds: 1);
  bool otpSendButtonEnabled = false;
  int timerCountDownSeconds = 30;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    updateTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String getFormatedCountDowndTimer() {
    return "00:${(timerCountDownSeconds < 10 ? '0' : '') + timerCountDownSeconds.toString()}";
  }

  void updateTimer() {
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if(timerCountDownSeconds < 1) {
          timer.cancel();
          enableSendOTP();
        } else {
          timerCountDownSeconds--;
        }
      });
    });
  }

  void enableSendOTP() {
    setState(() {
      otpSendButtonEnabled = true;
    });
  }

  FutureOr<dynamic> resetTimer(void value) {
    setState(() {
      _timer.cancel();
      otpSendButtonEnabled = false;
      timerCountDownSeconds = 30;
      updateTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
      viewModel: VerifyOTPViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 100, child: AppTitle()),
                verticalSpaceSmall,
                Text("SMS containing OTP is sent to ${model.phoneNo}"),
                verticalSpaceSmall,
                TextLink("Change Mobile Number",
                    onPressed: model.changePhoneNo),
                verticalSpaceMedium,
                InputField(
                  placeholder: 'OTP',
                  controller: otpController,
                  textInputType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: model.validateOtp,
                  validationMessage: model.otpValidationMessage,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BusyButton(
                      enabled: model.otpValidationMessage == "" &&
                          otpController.text != "",
                      title: 'Verify',
                      busy: model.busy,
                      onPressed: () {
                        model.verifyOTP(
                          otp: otpController.text,
                        );
                      },
                    )
                  ],
                ),
                verticalSpaceMedium,
                Text(getFormatedCountDowndTimer()),
                verticalSpaceSmall,
                TextLink(
                  'RESEND OTP',
                  onPressed: () {
                    model.resendOTP().then(resetTimer);
                  },
                  enabled: otpSendButtonEnabled,
                ),
              ],
            ),
          )),
    );
  }
}
