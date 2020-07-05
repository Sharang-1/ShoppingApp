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

  User get currentUser => _authenticationService.currentUser;
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  // Goto Pages

  Future<void> search() async {
    await _navigationService.navigateTo(SearchViewRoute);
  }

  Future<dynamic> cart() async {
    return await _navigationService.navigateTo(CartViewRoute);
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
