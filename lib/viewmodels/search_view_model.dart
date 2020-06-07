import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_model.dart';

class SearchViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  int cartCount = 0;

  Future<void> init() async {
    setUpCartCount();
    return;
  }

  Future<void> setUpCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartCount = prefs.getInt(CartCount);
    notifyListeners();
    return;
  }

  searchProducts(String searchKey) async {
    return;
  }

  searchSellers(String searchKey) async {
    return;
  }

  goToProductPage(Product data) {
    _navigationService.navigateTo(ProductIndividualRoute, arguments: data);
    return;
  }

  Future<void> cart() async {
    // await _navigationService.navigateTo(CartViewRoute);
  }
  
}
