import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';

class CartLocalStoreService {
  CartLocalStoreService() {
    setUpCartList();
  }

  Future<void> setUpCartList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final count = prefs.getStringList(CartItemList);

    if (count == null) {
      prefs.setStringList(CartItemList, []);
    }
  }

  Future<int> getCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(CartItemList).length;
  }

  @deprecated
  Future<bool> setCartCount(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(CartItemList, value);
  }

  Future<void> setCartList(List<String> list) async {
    print("CartLocalStoreService Service : setCartList");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(CartItemList, list);
  }

  Future<int> addToCartLocalStore(String productId) async {
    print("CartLocalStoreService Service : addToCartLocalStore");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(CartItemList);
    if (list != null) {
      final isProductAlreadyExists = list.indexOf(productId) != -1;
      if (isProductAlreadyExists) {
        return -1;
      }
      list.add(productId);
      prefs.setStringList(CartItemList, list);
      return 1;
    } else {
      prefs.setStringList(CartItemList, [productId]);
      return 0;
    }
  }

  Future<void> removeFromCartLocalStore(String productId) async {
    print("CartLocalStoreService Service : removeFromCartLocalStore");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(CartItemList);
    if (list != null && list != []) {
      list.remove(productId);
      prefs.setStringList(CartItemList, list);
    } else {
      prefs.setStringList(CartItemList, []);
    }
  }
}
