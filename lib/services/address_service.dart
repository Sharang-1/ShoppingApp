import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../models/user_details.dart';

class AddressService {
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
    List<UserDetailsContact> addresses = [];
    var addPreds = prefs.getStringList(AddressList);
    addresses = addPreds!
        .map((e) => UserDetailsContact.fromJson(jsonDecode(e)))
        .toList();
    addresses =
        addresses.where((address) => address.address!.isNotEmpty).toList();
    return addresses;
  }

  Future<bool> addAddresses(UserDetailsContact userAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AddressList);
    print(list);
    var address = jsonEncode(userAddress.toJson());
    print("Index of : " + list!.indexOf(address).toString());
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
    return list!.remove(jsonEncode(address.toJson()));
  }
}
