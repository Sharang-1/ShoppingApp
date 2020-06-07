import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_model.dart';

class ProductIndividualViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final APIService _apiService = locator<APIService>();

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

  Future<bool> addToCart(
      Product product, int qty, String size, String color) async {
    print("Cart added");
    print(product.key);
    final res = await _apiService.addToCart(product.key, qty, size, color);
    if (res != null) {
      _dialogService.showDialog(
          title: "Product added to cart",
          description: "You can check it in cart");
      return true;
    }
    return false;
  }

  Future<void> cart() async {
    await _navigationService.navigateTo(CartViewRoute);
  }
}
