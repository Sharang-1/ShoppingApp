// import 'package:fimber/fimber_base.dart';
import 'package:flutter/foundation.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/analytics_service.dart';
import '../services/authentication_service.dart';
import '../services/navigation_service.dart';
import '../utils/lang/translation_keys.dart';
import 'base_controller.dart';
import 'lookup_controller.dart';

class LoginController extends BaseController {
  final _authenticationService = locator<AuthenticationService>();

  String phoneNoValidationMessage = "";
  String nameValidationMessage = "";
  Gender selectedGender = Gender.Male;
  int selectedAgeId = -1;
  int selectedGenderId = -1;

  final ageLookup = locator<LookupController>()
      .lookups
      .where((element) => element.sectionName!.toLowerCase() == "user")
      .first
      .sections!
      .where(
        (e) => e.option == 'age',
      )
      .first
      .values;

  final genderLookup = locator<LookupController>()
      .lookups
      .where((element) => element.sectionName!.toLowerCase() == "user")
      .first
      .sections!
      .where(
        (e) => e.option == 'gender',
      )
      .first
      .values;

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

  Future login({
    required String phoneNo,
    required String name,
  }) async {
    setBusy(true);
    var result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNo, name: name, resend: false);
    // Fimber.d("---> login " + result.toString());
    setBusy(false);

    if (result != null)
      await NavigationService.to(VerifyOTPViewRoute, arguments: <String, int>{
        "genderId": selectedGenderId,
        "ageId": selectedAgeId,
      });
  }

  onAgeChanged(int value) {
    selectedAgeId = value;
    update();
  }

  onGenderIdChanged(int value) {
    selectedGenderId = value;
    update();
  }

  skipLogin() async {
    try {
      await locator<AnalyticsService>()
          .sendAnalyticsEvent(eventName: "skip_login", parameters: {});
    } catch (e) {
      // Fimber.e(e.toString());
    }
    var pref = await SharedPreferences.getInstance();
    await pref.setBool(SkipLogin, true);
    await NavigationService.offAll(HomeViewRoute);
  }
}
