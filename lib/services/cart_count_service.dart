import 'package:compound/constants/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';


// This service only sets cart counts for shared preference only.
// It doese not manages current state of cart count.
// For that purpose use CartCountSetup (inherited widget)
class CartCountService {
  CartCountService() {
    setUpCartCount();
  }

  Future<void> setUpCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(CartCount);

    if (count == null) {
      prefs.setInt(CartCount, 0);
    }
  }

  Future<int> getCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(CartCount);
  }

  Future<bool> setCartCount(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(CartCount, value);
  }

  Future<void> incrementCartCount() async {
    print("CartCount Service : incrementCartCount");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(CartCount);
    print("Cart Count : " + count.toString());
    if(count != null) {
      prefs.setInt(CartCount, count + 1);
    } else {
      prefs.setInt(CartCount, 1);
    }
  }

  Future<void> decrementCartCount() async {
    print("CartCount Service : decrementCartCount");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(CartCount);
    print("Cart Count : " + count.toString());
    if(count != null && count <= 0) {
      prefs.setInt(CartCount, 0);
    } else {
      prefs.setInt(CartCount, count - 1);
    }
  }
}
