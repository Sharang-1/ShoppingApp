import 'package:flutter/foundation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/route_argument.dart';
import '../services/address_service.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import 'base_model.dart';

class VerifyOTPViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();
  final AddressService _addressService = locator<AddressService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String otpValidationMessage = "";
  String phoneNo = "";
  String name = "";

  String get otpValidation => otpValidationMessage;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneNo = prefs.getString(PhoneNo);
    name = prefs.getString(Name);
    notifyListeners();
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Authtoken, result["token"]);

      var mUserDetails = await _apiService.getUserData();
      mUserDetails.name = prefs.getString(Name);
      await _addressService.setUpAddress(mUserDetails.contact);
      await _apiService.updateUserData(mUserDetails);

      try{
         await _analyticsService.sendAnalyticsEvent(eventName: "login");
      } catch(e){}

      _navigationService.navigateReplaceTo(OtpVerifiedRoute);
    } else {
      await _dialogService.showDialog(
        title: 'Incorrect OTP',
        description: 'The OTP, you have entered is incorrect. Please try again.',
      );
    }
  }

  //method, which is called after otp is verified
  Future otpVerified({bool loader = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString(Name);
    notifyListeners();

    Future.delayed(Duration(milliseconds: loader ? 1500 : 3000), () async {
      _navigationService
          .navigateReplaceTo(loader ? LoaderRoute : OtpVerified2Route);
    });
  }
}
