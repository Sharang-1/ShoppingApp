import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/address_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();
  final AddressService _addressService = locator<AddressService>();
  // final DialogService _dialogService = locator<DialogService>();

  UserDetails mUserDetails;
  Future getUserDetails() async {
    setBusy(true);
    final result = await _apiService.getUserData();
    setBusy(false);
    if (result != null) {
      mUserDetails = result;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Name, mUserDetails.firstName);
    prefs.setString(PhoneNo, mUserDetails.contact.phone.mobile);
    Fimber.e(mUserDetails.firstName);
    Fimber.e(mUserDetails.contact.phone.mobile);

    _addressService.setUpAddress(mUserDetails.contact);
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
    prefs.setString(Name, mUserDetails.firstName);
    Fimber.e(mUserDetails.firstName);
    Fimber.e(mUserDetails.contact.phone.mobile);
    _addressService.setUpAddress(mUserDetails.contact);
    notifyListeners();
  }
}
