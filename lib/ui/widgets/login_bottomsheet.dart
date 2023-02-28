import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/bottomsheet_login_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';
import 'input_field.dart';
import 'text_link.dart';

class LoginBottomsheet extends StatelessWidget {
  final String nextView;
  final bool shouldNavigateToNextScreen;
  final dynamic arguments;
  const LoginBottomsheet({
    required this.nextView,
    this.shouldNavigateToNextScreen = false,
    this.arguments,
  });
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomsheetLoginController>(
      init: BottomsheetLoginController(),
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!controller.isOTPScreen)
                  Center(
                    child: CustomText(
                      "Login To Continue",
                      fontSize: 20,
                      isBold: true,
                    ),
                  ),
                verticalSpaceSmall,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Center(
                    child: CustomText(
                      getTitle(nextView, controller.isOTPScreen),
                      fontSize: 14.0,
                    ),
                  ),
                ),
                verticalSpaceMedium,
                (!controller.isOTPScreen)
                    ? Column(
                        children: [
                          InputField(
                            fromBottomsheet: true,
                            fieldFocusNode: controller.nameFocus,
                            nextFocusNode: controller.mobileFocus,
                            placeholder: 'Enter your name',
                            controller: controller.nameController,
                            textInputType: TextInputType.text,
                            validationMessage: controller.nameValidationMessage,
                            onChanged: controller.validateName,
                          ),
                          InternationalPhoneNumberInput(
                            focusNode: controller.mobileFocus,
                            onSubmit: () {
                              controller.mobileFocus.unfocus();
                            },
                            onInputValidated: (bool flag) {
                              if (flag) {
                                controller.mobileFocus.unfocus();
                              }
                            },
                            countries: ['IN'],
                            inputDecoration: InputDecoration(
                              hintText: "Mobile Number",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: titleFontSizeStyle,
                              ),
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            errorMessage: controller.phoneNoValidationMessage,
                            textFieldController: controller.phoneNoController,
                            isEnabled: true,
                            onInputChanged: (value) {},
                            // selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            formatInput: true,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "*Enter a valid Indian mobile number to receive a login OTP.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 8.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
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
                            wrapAlignment: WrapAlignment.center,
                            pinBoxDecoration: ProvidedPinBoxDecoration
                                .defaultPinBoxDecoration,
                            pinTextStyle:
                                TextStyle(fontSize: titleFontSizeStyle),
                            pinBoxRadius: 3,
                            pinTextAnimatedSwitcherTransition:
                                ProvidedPinBoxTextAnimation.scalingTransition,
                            pinTextAnimatedSwitcherDuration:
                                Duration(milliseconds: 300),
                          ),
                          verticalSpaceSmall,
                          Text(
                            controller.getFormatedCountDowndTimer(),
                            style: TextStyle(fontSize: titleFontSizeStyle),
                          ),
                          verticalSpaceSmall,
                          TextLink(
                            'RESEND OTP',
                            onPressed: controller.otpSendButtonEnabled
                                ? () {
                                    controller
                                        .resendOTP()
                                        .then(controller.resetTimer);
                                  }
                                : () {},
                            enabled: controller.otpSendButtonEnabled,
                          ),
                          verticalSpaceTiny,
                          InkWell(
                            onTap: () async {
                              const url = TERMS_AND_CONDITIONS_URL;
                              if (await canLaunchUrlString(url)) {
                                await launchUrlString(url);
                              }
                            },
                            child: Text(
                              "When you enter \"OTP\", You agree to our T&C",
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.underline,
                                  fontSize: subtitleFontSizeStyle - 3),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                verticalSpaceSmall,
                ElevatedButton(
                  onPressed: controller.busy
                      ? null
                      : controller.isOTPScreen
                          ? () async => await controller.verifyOTP(
                                nextScreen: nextView,
                                shouldNavigateToNextScreen:
                                    shouldNavigateToNextScreen,
                              )
                          : controller.login,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: lightGreen,
                    elevation: 0,
                  ),
                  child:
                      Text(controller.isOTPScreen ? "Verify OTP" : "Get OTP"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getTitle(String nextView, bool isOTPScreen) {
    String prefix =
        isOTPScreen ? "Enter OTP to" : "Add Name & Mobile Number to";
    switch (nextView.trim()) {
      case MyOrdersRoute:
        return "$prefix see Orders";
      case CartViewRoute:
        return "$prefix see Items in Bag";
      case WishListRoute:
        return "$prefix see Wishlist";
      case MapViewRoute:
        return "$prefix open Dzor Map";
      case SellerIndiViewRoute:
        return "$prefix see Designer's Profile";
      default:
        return "$prefix continue";
    }
  }
}
