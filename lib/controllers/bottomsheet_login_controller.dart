import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../services/authentication_service.dart';
import 'base_controller.dart';

class BottomsheetLoginController extends BaseController {
  final _authenticationService = locator<AuthenticationService>();

  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();

  final nameFocus = FocusNode();
  final mobileFocus = FocusNode();

  String phoneNoValidationMessage = "";
  String nameValidationMessage = "";
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

  Future login() async {
    setBusy(true);
    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: (phoneNoController.text).trim(),
        name: (nameController.text),
        resend: false);
    Fimber.d("---> login " + result.toString());
    setBusy(false);

    if (result != null) isOTPScreen = true;
    update();
  }
}
