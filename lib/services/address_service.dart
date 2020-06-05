import 'package:compound/constants/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressService {
  AddressService() {
    setUpAddresses();
  }

  Future<void> setUpAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AddressList);

    if (list == null) {
      prefs.setStringList(AddressList, [
        "103 /, First Floor, Royal Bldg, Janjikar Street, Masjid Bunder (w), Mumbai, Maharashtra-400003"
      ]);
    }
  }

  Future<List<String>> getAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AddressList);
  }

  Future<bool> addAddresses(String address) async {
    print("Address Service : addAddresses");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AddressList);
    print(list);
    print("Index of : " + list.indexOf(address).toString());
    if (list.indexOf(address) == -1) {
      list.add(address);
      print(list);
      prefs.setStringList(AddressList, list);
      return true;
    }
    return false;
  }

  Future<bool> removeAddresses(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(AddressList);
    return list.remove(address);
  }
}
