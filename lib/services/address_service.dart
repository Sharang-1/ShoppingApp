import 'dart:convert';

import 'package:compound/constants/shared_pref.dart';
import 'package:compound/models/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressService {
  AddressService() {
    // setUpAddress(null);
  }

  // Future<void> setUpAddresses() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final list = prefs.getStringList(AddressList);

  //   if (list == null) {
  //     prefs.setStringList(AddressList, [
  //       // "103 /, First Floor, Royal Bldg, Janjikar Street, Masjid Bunder (w), Mumbai, Maharashtra-400003"
  //     ]);
  //   }
  // }

  Future<void> setUpAddress(UserDetailsContact address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> addArr = [];
    if (address != null && address.googleAddress != null) {
      addArr.add(jsonEncode(address.toJson()));
    }
    prefs.setStringList(AddressList, addArr);
  }

  Future<List<UserDetailsContact>> getAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var addPreds = prefs.getStringList(AddressList);
    return addPreds
        .map((e) => UserDetailsContact.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<bool> addAddresses(UserDetailsContact userAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AddressList);
    print(list);
    var address = jsonEncode(userAddress.toJson());
    print("Index of : " + list.indexOf(address).toString());
    if (list.indexOf(address) == -1) {
      list.add(address);
      print(list);
      prefs.setStringList(AddressList, list);
      return true;
    }
    return false;
  }

  Future<bool> removeAddresses(UserDetailsContact address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AddressList);
    return list.remove(jsonEncode(address.toJson()));
  }
}
