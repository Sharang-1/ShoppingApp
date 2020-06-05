import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/route_argument.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/foundation.dart';
import 'package:page_transition/page_transition.dart';

import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String phoneNoValidationMessage = "";
  String get phoneNoValidation => phoneNoValidationMessage;

  String nameValidationMessage = "";
  String get nameValidation => nameValidationMessage;

  Future<void> init() async {
    return;
  }

  void validatePhoneNo(String textFieldValue) {
    bool isValid = RegExp(r'^\d{10}$').hasMatch(textFieldValue);
    if (!isValid) {
      phoneNoValidationMessage =
          "Please enter valid phone number of 10 digits only";
    } else {
      phoneNoValidationMessage = "";
    }
    notifyListeners();
  }

  void validateName(String textFieldValue) {
    bool isValid = RegExp(r'^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$')
        .hasMatch(textFieldValue);
    if (!isValid) {
      nameValidationMessage = "Please enter valid name";
    } else {
      nameValidationMessage = "";
    }
    notifyListeners();
  }

  Future login({
    @required String phoneNo,
    @required String name,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNo, name: name, resend: false);
    Fimber.d("---> login " + result.toString());
    setBusy(false);

    // if (result is bool) {
    if (result != null) {
      // Successfully sent otp
      // await _analyticsService.logLogin();
      // Navigate to verify otp
      _navigationService.navigateReplaceTo(VerifyOTPViewRoute,
          arguments: CustomRouteArgument(
            type: PageTransitionType.rightToLeft,
          ));
    }
  }
}
