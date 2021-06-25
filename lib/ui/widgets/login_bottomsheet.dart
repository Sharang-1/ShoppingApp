import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import '../../controllers/bottomsheet_login_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';
import 'input_field.dart';

class LoginBottomsheet extends StatelessWidget {
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
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: SingleChildScrollView(
            child: (!controller.isOTPScreen)
                ? Column(
                    children: [
                      Center(
                        child: CustomText(
                          "Add Name & Mobile Number to continue",
                          fontSize: 16.0,
                        ),
                      ),
                      verticalSpaceMedium,
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
                        ),
                        errorMessage: controller.phoneNoValidationMessage,
                        textFieldController: controller.phoneNoController,
                        isEnabled: true,
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        autoValidate: true,
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
                      verticalSpaceSmall,
                      ElevatedButton(
                        onPressed: () async {
                          await controller.login();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: lightGreen,
                          onPrimary: Colors.white,
                          elevation: 0,
                        ),
                        child: Text("Get OTP"),
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
                        // controller: controller.otpController,
                        hideCharacter: false,
                        hasTextBorderColor: Colors.black45,
                        defaultBorderColor: Colors.grey[300],
                        pinBoxColor: Colors.white,
                        maxLength: 4,
                        // onTextChanged: controller.validateOtp,
                        // onDone: (text) => controller.verifyOTP(otp: text),
                        wrapAlignment: WrapAlignment.center,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: titleFontSizeStyle),
                        pinBoxRadius: 3,
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 300),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
