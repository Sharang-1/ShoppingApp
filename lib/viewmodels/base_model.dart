import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/user.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

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

  // Goto Pages

  Future<void> search() async {
    await _navigationService.navigateTo(SearchViewRoute);
  }

  Future<void> cart() async {
    await _navigationService.navigateTo(CartViewRoute);
  }

  Future<void> category() async {
    await _navigationService.navigateTo(CategoriesRoute);
  }

  Future<dynamic> goToProductPage(Product data) {
    return _navigationService.navigateTo(ProductIndividualRoute, arguments: data);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Authtoken);
    prefs.remove(PhoneNo);
    await _navigationService.navigateReplaceTo(LoginViewRoute);
  }

  Future openmap() async {
    await _navigationService.navigateTo(MapViewRoute);
  }  
}
