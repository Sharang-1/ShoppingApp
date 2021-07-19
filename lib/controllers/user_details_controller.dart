// import 'package:fimber/fimber.dart';
import 'dart:io';

import 'package:compound/controllers/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/user_details.dart';
import '../services/address_service.dart';
import '../services/api/api_service.dart';
import '../services/dialog_service.dart';
import 'base_controller.dart';
import 'lookup_controller.dart';

class UserDetailsController extends BaseController {
  final APIService _apiService = locator<APIService>();
  final AddressService _addressService = locator<AddressService>();
  String dateTimeString = DateTime.now().millisecondsSinceEpoch.toString();

  final ageLookup = locator<LookupController>()
      .lookups
      .where((element) => element.sectionName.toLowerCase() == "user")
      .first
      .sections
      .where(
        (e) => e.option == 'age',
      )
      .first
      .values;

  final genderLookup = locator<LookupController>()
      .lookups
      .where((element) => element.sectionName.toLowerCase() == "user")
      .first
      .sections
      .where(
        (e) => e.option == 'gender',
      )
      .first
      .values;

  String token;

  void showNotDeliveringDialog() {
    DialogService.showNotDeliveringDialog();
  }

  UserDetails mUserDetails = locator<HomeController>().details;
  Future getUserDetails() async {
    setBusy(true);
    token = (await SharedPreferences.getInstance()).getString(Authtoken);
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
    update();
  }

  Future updateUserPhoto() async {
    setBusy(true);
    File file;
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      if (await _apiService.updateUserPic(file)) {
        dateTimeString = DateTime.now().millisecondsSinceEpoch.toString();
        update();
      }
    }
    setBusy(false);
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
    update();
  }
}
