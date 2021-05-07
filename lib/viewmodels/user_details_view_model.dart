// import 'package:fimber/fimber.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/user_details.dart';
import '../services/address_service.dart';
import '../services/api/api_service.dart';
import '../services/dialog_service.dart';
import 'base_model.dart';

class UserDetailsViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();
  final AddressService _addressService = locator<AddressService>();

  void showNotDeliveringDialog() {
    DialogService.showNotDeliveringDialog();
  }

  UserDetails mUserDetails;
  Future getUserDetails() async {
    setBusy(true);
    final result = await _apiService.getUserData();
    setBusy(false);
    if (result != null) {
      mUserDetails = result;
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(Name, mUserDetails.name);
    // prefs.setString(PhoneNo, mUserDetails.contact.phone.mobile);
    // Fimber.e(mUserDetails.firstName);
    // Fimber.e(mUserDetails.contact.phone.mobile);

    // _addressService.setUpAddress(mUserDetails.contact);
    notifyListeners();
  }

  Future updateUserDetails() async {
    setBusy(true);
    final result = await _apiService.updateUserData(mUserDetails);
    setBusy(false);
    if (result != null) {
      mUserDetails = result;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Name, mUserDetails.name);
    await _addressService.setUpAddress(mUserDetails.contact);
    notifyListeners();
  }
}
