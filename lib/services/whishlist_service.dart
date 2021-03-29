import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';

class WhishListService {
  WhishListService() {
    setUpWhishList();
  }

  Future<void> setUpWhishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(WhishList);

    if (list == null) {
      prefs.setStringList(WhishList, []);
    }
  }

  Future<List<String>> getWhishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(WhishList);
  }

  Future<bool> addWhishList(String id) async {
    print("WhishList Service : addWhishList");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(WhishList);
    print(list);
    print("Index of : " + list.indexOf(id).toString());
    if (list.indexOf(id) == -1) {
      list.add(id);
      print(list);
      prefs.setStringList(WhishList, list);
      return true;
    }
    return false;
  }

  Future<bool> removeWhishList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(WhishList);
    final res = list.remove(id);
    prefs.setStringList(WhishList, list);
    return res;
  }

  Future<bool> isProductInWhishList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(WhishList);
    if (list.indexOf(id) == -1) {
      return false;
    }
    return true;
  }
}
