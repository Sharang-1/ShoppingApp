import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../controllers/otp_verification_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/busy_button_circular.dart';
import '../widgets/text_link.dart';

class VerifyOTPView extends StatefulWidget {
  final int genderId;
  final int ageId;
  const VerifyOTPView({required this.ageId, required this.genderId});
  @override
  _VerifyOTPViewState createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  Widget genericWelcomeText(String txt, headingFontSize) {
    return Text(
      txt,
      maxLines :2,
      style:
          TextStyle(fontSize: headingFontSize - 3, fontWeight: FontWeight.w600),
    );
  }

  Widget welcomeText(context, controller, headingFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        genericWelcomeText(
          "Enter the OTP sent to ${controller.phoneNo} via sms",
          headingFontSize,
        ),
      ],
    );
  }

  Widget bottomBar(controller, headingFontSize) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: controller.changePhoneNo,
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
                    fontSize: headingFontSize, fontWeight: FontWeight.w300),
              ),
              horizontalSpaceMedium,
              BusyButtonCicular(
                enabled: controller.otpValidationMessage == "" &&
                    controller.otpController.text != "",
                title: 'Verify',
                busy: controller.busy,
                onPressed: () async {
                  await controller.verifyOTP(
                    otp: controller.otpController.text,
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
    return Image.asset(
      "assets/images/logo.png",
      // color: logoRed,
      width: MediaQuery.of(context).size.width / 3,
    );
  }

  Widget inputFields(OtpVerificationController controller, BuildContext context,
      double headingFontSize) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            welcomeText(context, controller, headingFontSize)
          ]),
          verticalSpaceMedium,
          PinCodeTextField(
            pinBoxHeight: 40,
            pinBoxWidth: 40,
            pinBoxBorderWidth: 1,
            autofocus: false,
            controller: controller.otpController,
            hideCharacter: false,
            hasTextBorderColor: Colors.black45,
            defaultBorderColor: Colors.grey[300]!,
            pinBoxColor: Colors.white,
            maxLength: 4,
            onTextChanged: controller.validateOtp,
            onDone: (text) => controller.verifyOTP(otp: text),
            wrapAlignment: WrapAlignment.center,
            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
            pinTextStyle: TextStyle(fontSize: titleFontSizeStyle),
            pinBoxRadius: 3,
            pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
          ),
          Text(
            controller.getFormatedCountDowndTimer(),
            style: TextStyle(fontSize: titleFontSizeStyle),
          ),
          verticalSpaceSmall,
          TextLink(
            'RESEND OTP',
            onPressed: () {
              controller.resendOTP().then(controller.resetTimer);
            },
            enabled: controller.otpSendButtonEnabled,
          ),
          verticalSpaceSmall,
          InkWell(
            onTap: () => controller.openTermsAndConditions(),
            child: Text(
              "When you enter \"OTP\", You agree to Dzor's terms and conditions",
              style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                  fontSize: subtitleFontSizeStyle - 3),
              textAlign: TextAlign.center,
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double headingFontSize = headingFontSizeStyle + 5;

    return GetBuilder<OtpVerificationController>(
      init: OtpVerificationController(
        ageId: widget.ageId,
        genderId: widget.genderId,
      ),
      builder: (controller) => Scaffold(
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: bottomBar(controller, headingFontSize),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: image(context)),
                Container(
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.width / 3) -
                      20 -
                      20 -
                      100,
                  child: inputFields(controller, context, headingFontSize),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
