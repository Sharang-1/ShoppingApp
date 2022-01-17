import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';

class WishListService {
  WishListService() {
    setUpWishList();
  }

  Future<void> setUpWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(wishList);

    if (list == null) {
      prefs.setStringList(wishList, []);
    }
  }

  Future<List<String>> getWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(wishList) ?? [];
  }

  Future<bool> addWishList(String id) async {
    print("wishList Service : addwishList");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(wishList);
    print(list);
    print("Index of : " + list!.indexOf(id).toString());
    if (list.indexOf(id) == -1) {
      list.add(id);
      print(list);
      prefs.setStringList(wishList, list);
      return true;
    }
    return false;
  }

  Future<bool> removeWishList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(wishList);
    final res = list!.remove(id);
    prefs.setStringList(wishList, list);
    return res;
  }

  Future<bool> isProductInWishList(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(wishList);
    if (list!.indexOf(id) == -1) {
      return false;
    }
    return true;
  }
}
