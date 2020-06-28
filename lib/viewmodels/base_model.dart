import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();      
  final WhishListService _whishListService = locator<WhishListService>();

  int cartCount = 0;

  User get currentUser => _authenticationService.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  Future<void> setUpCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartCount = prefs.getInt(CartCount);
    notifyListeners();
    return;
  }

  Future<void> incrementCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartCount = prefs.getInt(CartCount);
    if(cartCount != null)
      cartCount += 1;
    else 
      cartCount = 1;
    
    prefs.setInt(CartCount, cartCount);
    notifyListeners();
    return;
  }

  Future<void> decrementCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartCount = prefs.getInt(CartCount);
    if(cartCount != null && cartCount != 0)
      cartCount -= 1;
    else 
      cartCount = 0;
    
    prefs.setInt(CartCount, cartCount);
    notifyListeners();
    return;
  }

  
}
