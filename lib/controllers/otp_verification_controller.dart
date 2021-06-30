import 'dart:async';

import 'package:compound/models/user_details.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/route_names.dart';
import '../constants/server_urls.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/route_argument.dart';
import '../services/address_service.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import 'base_controller.dart';

class OtpVerificationController extends BaseController {
  final otpController = TextEditingController();
  Timer _timer;
  final oneSec = const Duration(seconds: 1);
  bool otpSendButtonEnabled = false;
  int timerCountDownSeconds = 30;
  int ageId;
  int genderId;

  OtpVerificationController({this.ageId, this.genderId});

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final APIService _apiService = locator<APIService>();
  final AddressService _addressService = locator<AddressService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String otpValidationMessage = "";
  String phoneNo = "";
  String name = "";

  String get otpValidation => otpValidationMessage;

  @override
  void onInit() async {
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString(PhoneNo);
    name = prefs.getString(Name);
    updateTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer.cancel();
    super.onClose();
  }

  void updateTimer() {
    _timer = Timer.periodic(
      oneSec,
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

  openTermsAndConditions() async {
    const url = TERMS_AND_CONDITIONS_URL;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> resendOTP() async {
    // resend otp here.
    setBusy(true);
    final result = await _authenticationService.loginWithPhoneNo(
        phoneNo: phoneNo, name: name, resend: true);
    print("Reset OTP Results : ");
    print(result);
    setBusy(false);
    return;
  }

  void changePhoneNo() {
    NavigationService.to(LoginViewRoute,
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
    update();
  }

  Future verifyOTP({
    @required String otp,
  }) async {
    setBusy(true);

    var result = await _authenticationService.verifyOTP(otp: otp);

    setBusy(false);

    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Authtoken, result["token"]);

      var mUserDetails = await _apiService.getUserData();
      mUserDetails.name = prefs.getString(Name);
      mUserDetails.age = Age(id: ageId);
      mUserDetails.gender = Gender(id: genderId);
      await _addressService.setUpAddress(mUserDetails.contact);
      await _apiService.updateUserData(mUserDetails);

      try {
        await _analyticsService.sendAnalyticsEvent(eventName: "login");
      } catch (e) {}

      NavigationService.off(OtpVerifiedRoute);
    } else {
      await DialogService.showDialog(
        title: 'Incorrect OTP',
        description:
            'The OTP, you have entered is incorrect. Please try again.',
      );
    }
  }
}
