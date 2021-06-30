import 'package:compound/controllers/home_controller.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/payment_service.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/address_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import 'base_controller.dart';

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

  void validatePhoneNo(String textFieldValue) {
    bool isValid = RegExp(r'^\d{10}$').hasMatch(textFieldValue);
    if (!isValid) {
      phoneNoValidationMessage =
          "Please enter valid phone number of 10 digits only";
    } else {
      phoneNoValidationMessage = "";
    }
    update();
  }

  void validateName(String textFieldValue) {
    bool isValid = RegExp(r'^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$')
        .hasMatch(textFieldValue);
    if (!isValid) {
      nameValidationMessage = "Please enter valid name";
    } else {
      nameValidationMessage = "";
    }
    update();
  }

  void validateOtp(String textFieldValue) {
    bool isValid = RegExp(r'^\d{4}$').hasMatch(textFieldValue);
    if (!isValid) {
      otpValidationMessage = "Please enter valid otp of 4 digits only";
    } else {
      otpValidationMessage = "";
    }
    update();
  }

  login() async {
    if (nameController.text.isEmpty ||
        phoneNoController.text.trim().replaceAll(" ", "").length < 10) {
      await DialogService.showDialog(
        title: 'Invalid Details',
        description: 'Enter Valid Name or Mobile Number !!!',
      );
      return;
    }
    setBusy(true);
    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNoController.text.trim().replaceAll(" ", ""),
        name: (nameController.text).trim(),
        resend: false);
    Fimber.d("---> login " + result.toString());
    setBusy(false);
    if (result != null) isOTPScreen = true;
    update();
  }

  Future verifyOTP(
      {String nextScreen, bool shouldNavigateToNextScreen = false}) async {
    if (otpController.text.length < 4) {
      await DialogService.showDialog(
        title: 'Invalid OTP',
        description: 'Enter Valid OTP !!!',
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
      mUserDetails.name = prefs.getString(Name);
      await locator<AddressService>().setUpAddress(mUserDetails.contact);
      await locator<APIService>().updateUserData(mUserDetails);

      try {
        await locator<AnalyticsService>()
            .sendAnalyticsEvent(eventName: "bottomsheet login");
      } catch (e) {}

      await locator<PaymentService>().getApiKey();
      locator<HomeController>().onRefresh();

      NavigationService.back();
      if (shouldNavigateToNextScreen) {
        NavigationService.to(nextScreen);
      }
    } else {
      await DialogService.showDialog(
        title: 'Incorrect OTP',
        description:
            'The OTP, you have entered is incorrect. Please try again.',
      );
    }
  }
}
