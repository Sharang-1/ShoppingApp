import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/route_argument.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/location_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/foundation.dart';
import 'package:page_transition/page_transition.dart';

import 'base_model.dart';

class MapViewModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String phoneNoValidationMessage = "";
  String get phoneNoValidation => phoneNoValidationMessage;

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

  Future login({
    @required String phoneNo,
  }) async {
    setBusy(true);

    var result =
        await _locationService.getLocation();
    Fimber.d("---> login " + result.toString());
    setBusy(false);

    // if (result is bool) {
      if (result!=null) {   
        // Successfully sent otp
        await _analyticsService.logLogin();
        // Navigate to verify otp
        _navigationService.navigateReplaceTo(VerifyOTPViewRoute,
            arguments: CustomRouteArgument(
              type: PageTransitionType.rightToLeft,
            ));
      }
  }
}
