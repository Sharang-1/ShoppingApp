import 'dart:async';

// import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/address_service.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../services/payment_service.dart';
import '../utils/lang/translation_keys.dart';
import 'base_controller.dart';
import 'home_controller.dart';

class BottomsheetLoginController extends BaseController {
  final _authenticationService = locator<AuthenticationService>();

  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = TextEditingController();

  final nameFocus = FocusNode();
  final mobileFocus = FocusNode();

  String phoneNoValidationMessage = "";
  String nameValidationMessage = "";
  String otpValidationMessage = "";
  bool isOTPScreen = false;

  late Timer _timer;
  bool otpSendButtonEnabled = false;
  int timerCountDownSeconds = 30;

  void validatePhoneNo(String textFieldValue) {
    bool isValid = RegExp(r'^\d{10}$').hasMatch(textFieldValue);
    if (!isValid) {
      phoneNoValidationMessage = LOGIN_PHONE_NO_VALIDATION_MSG.tr;
    } else {
      phoneNoValidationMessage = "";
    }
    update();
  }

  void validateName(String textFieldValue) {
    bool isValid = RegExp(r'^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$')
        .hasMatch(textFieldValue);
    if (!isValid) {
      nameValidationMessage = LOGIN_NAME_VALIDATION_MSG.tr;
    } else {
      nameValidationMessage = "";
    }
    update();
  }

  void validateOtp(String textFieldValue) {
    bool isValid = RegExp(r'^\d{4}$').hasMatch(textFieldValue);
    if (!isValid) {
      otpValidationMessage = LOGIN_OTP_VALIDATION_MSG.tr;
    } else {
      otpValidationMessage = "";
    }
    update();
  }

  login() async {
    if (nameController.text.isEmpty ||
        phoneNoController.text.trim().replaceAll(" ", "").length < 10) {
      await DialogService.showDialog(
        title: LOGIN_INVALID_DETAILS_TITLE.tr,
        description: LOGIN_INVALID_DETAILS_DESCRIPTION.tr,
      );
      return;
    }
    setBusy(true);
    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNoController.text.trim().replaceAll(" ", ""),
        name: (nameController.text).trim(),
        resend: false);

    // Fimber.d("---> login " + result.toString());
    setBusy(false);
    if (result != null) {
      isOTPScreen = true;
      updateTimer();
    }
    update();
  }

  Future verifyOTP(
      {required String nextScreen,
      bool shouldNavigateToNextScreen = false}) async {
    if (otpController.text.length < 4) {
      await DialogService.showDialog(
        title: LOGIN_INVALID_OTP_TITLE.tr,
        description: LOGIN_INVALID_OTP_DESCRIPTION.tr,
      );
      return;
    }
    setBusy(true);

    var result =
        await _authenticationService.verifyOTP(otp: otpController.text.trim());

    setBusy(false);

    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Authtoken, result["token"]);

      var mUserDetails = await locator<APIService>().getUserData();
      mUserDetails!.name = prefs.getString(Name);
      await locator<AddressService>().setUpAddress(mUserDetails.contact!);
      await locator<APIService>().updateUserData(mUserDetails);

      try {
        await locator<AnalyticsService>()
            .sendAnalyticsEvent(eventName: "bottomsheet_login", parameters: {});
      } catch (e) {}

      await locator<PaymentService>().getApiKey();
      locator<HomeController>().onRefresh();

      NavigationService.back();
      if (shouldNavigateToNextScreen) {
        NavigationService.to(nextScreen);
      }
    } else {
      await DialogService.showDialog(
        title: LOGIN_INCORRECT_OTP_TITLE.tr,
        description: LOGIN_INCORRECT_OTP_DESCRIPTION.tr,
      );
    }
  }

  //OTP verification screen
  Future<void> resendOTP() async {
    // resend otp here.
    setBusy(true);
    final result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNoController.text.trim().replaceAll(" ", ""),
        name: (nameController.text).trim(),
        resend: true);
    print("Reset OTP Results : ");
    print(result);
    setBusy(false);
    return;
  }

  void updateTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (timerCountDownSeconds < 1) {
          timer.cancel();
          otpSendButtonEnabled = true;
          update();
        } else {
          timerCountDownSeconds--;
          update();
        }
      },
    );
  }

  FutureOr<dynamic> resetTimer(void value) {
    _timer.cancel();
    otpSendButtonEnabled = false;
    timerCountDownSeconds = 30;
    updateTimer();
  }

  String getFormatedCountDowndTimer() =>
      "00:${(timerCountDownSeconds < 10 ? '0' : '') + timerCountDownSeconds.toString()}";
}
