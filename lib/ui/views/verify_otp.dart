import 'dart:async';

import 'package:compound/constants/server_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../viewmodels/verify_otp_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/busy_button_circular.dart';
import '../widgets/text_link.dart';

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
        if (timerCountDownSeconds < 1) {
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

  Widget genericWelcomeText(String txt, headingFontSize) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: "Raleway",
          fontSize: headingFontSize - 3,
          fontWeight: FontWeight.w600),
    );
  }

  Widget welcomeText(context, model, headingFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        genericWelcomeText("Enter the otp", headingFontSize),
        SizedBox(
          height: 5,
        ),
        genericWelcomeText("sent to ${model.phoneNo}", headingFontSize),
        SizedBox(
          height: 5,
        ),
        genericWelcomeText("via sms", headingFontSize)
      ],
    );
  }

  Widget bottomBar(model, headingFontSize) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: model.changePhoneNo,
            elevation: 0,
            backgroundColor: backgroundWhiteCreamColor,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                "Finish",
                style: TextStyle(
                    fontFamily: "Raleway",
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.w300),
              ),
              horizontalSpaceMedium,
              BusyButtonCicular(
                enabled: model.otpValidationMessage == "" &&
                    otpController.text != "",
                title: 'Verify',
                busy: model.busy,
                onPressed: () {
                  model.verifyOTP(
                    otp: otpController.text,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget image(context) {
    return SvgPicture.asset(
      "assets/svg/logo.svg",
      color: logoRed,
      width: MediaQuery.of(context).size.width / 3,
    );
  }

  _launchURL() async {
    const url = TERMS_AND_CONDITIONS_URL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget inputFields(model, context, headingFontSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[welcomeText(context, model, headingFontSize)]),
          verticalSpaceMedium,
          // InputField(
          //   placeholder: 'OTP',
          //   controller: otpController,
          //   textInputType: TextInputType.numberWithOptions(decimal: true),
          //   onChanged: model.validateOtp,
          //   validationMessage: model.otpValidationMessage,
          // ),
          PinCodeTextField(
            pinBoxHeight: 40,
            pinBoxWidth: 40,
            pinBoxBorderWidth: 1,
            autofocus: false,
            controller: otpController,
            hideCharacter: false,
            // highlight: true,
            // highlightColor: Colors.blue,
            hasTextBorderColor: Colors.black45,
            defaultBorderColor: Colors.grey[300],
            pinBoxColor: Colors.white,
            maxLength: 4,
            // hasError: hasError,
            onTextChanged: model.validateOtp,
            onDone: (text) {
              model.verifyOTP(
                otp: text,
              );
            },
            wrapAlignment: WrapAlignment.center,
            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: titleFontSizeStyle),
            pinBoxRadius: 3,
            pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
          ),
          Text(
            getFormatedCountDowndTimer(),
            style: TextStyle(fontSize: titleFontSizeStyle),
          ),
          verticalSpaceSmall,
          TextLink(
            'RESEND OTP',
            onPressed: () {
              model.resendOTP().then(resetTimer);
            },
            enabled: otpSendButtonEnabled,
          ),
          verticalSpaceSmall,
          InkWell(
              onTap: () {
                _launchURL();
              },
              child: Text(
                "When you enter \"OTP\", You agree to Dzor's terms and conditions",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Open Sans",
                    decoration: TextDecoration.underline,
                    fontSize: subtitleFontSizeStyle - 3),
                textAlign: TextAlign.center,
              ))
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double headingFontSize = headingFontSizeStyle + 5;

    return ViewModelProvider<VerifyOTPViewModel>.withConsumer(
        viewModel: VerifyOTPViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              color: Colors.transparent,
              child: bottomBar(model, headingFontSize),
            ),
            backgroundColor: backgroundWhiteCreamColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 70, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    image(context),
                    Container(
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.width / 3) -
                          20 -
                          20 -
                          100,
                      child: inputFields(model, context, headingFontSize),
                    )
                  ],
                ),
              ),
            )));
  }
}
