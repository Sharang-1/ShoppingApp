import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/route_argument.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_model.dart';

class VerifyOTPViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String otpValidationMessage = "";
  String phoneNo = "";

  String get otpValidation => otpValidationMessage;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString(PhoneNo);
    notifyListeners();
  }

  Future<void> resendOTP() async {
    // resend otp here.
    setBusy(true);
    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNo, name: "name", resend: true);
    setBusy(false);
    return;
  }

  void changePhoneNo() {
    _navigationService.navigateReplaceTo(LoginViewRoute,
        arguments: CustomRouteArgument(
          type: PageTransitionType.fade,
        ));
  }

  void validateOtp(String textFieldValue) {
    bool isValid = RegExp(r'^\d{4}$').hasMatch(textFieldValue);
    if (!isValid) {
      otpValidationMessage = "Please enter valid otp of 4 digits only";
    } else {
      otpValidationMessage = "";
    }
    notifyListeners();
  }

  Future verifyOTP({
    @required String otp,
  }) async {
    setBusy(true);

    var result = await _authenticationService.verifyOTP(otp: otp);

    setBusy(false);

    if (result != null) {
      await _analyticsService.logLogin();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Authtoken, result["token"]);
      _navigationService.navigateReplaceTo(OtpFinishedScreen1Route);
    } else {
      await _dialogService.showDialog(
        title: 'Login Failure',
        description: 'General login failure. Please try again later',
      );
    }
  }

  // void navigateToSignUp() {
  //   _navigationService.navigateTo(SignUpViewRoute);
  // }
}
