import 'package:fimber/fimber_base.dart';
import 'package:flutter/foundation.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../services/authentication_service.dart';
import '../services/navigation_service.dart';
import 'base_controller.dart';

class LoginController extends BaseController {
  final _authenticationService = locator<AuthenticationService>();

  String phoneNoValidationMessage = "";
  String nameValidationMessage = "";

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

  Future login({
    @required String phoneNo,
    @required String name,
  }) async {
    setBusy(true);
    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNo, name: name, resend: false);
    Fimber.d("---> login " + result.toString());
    setBusy(false);

    if (result != null) await NavigationService.to(VerifyOTPViewRoute);
  }
}
