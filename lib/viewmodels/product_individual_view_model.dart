import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/whishlist_service.dart';

import 'base_model.dart';

class ProductIndividualViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final APIService _apiService = locator<APIService>();
  final WhishListService _whishListService = locator<WhishListService>();

  bool isProductInWhishlist = false;

  ProductIndividualViewModel() {
    super.setUpCartCount();
  }

  Future<void> init(String productId) async {
    setUpCartCount();
    isProductInWhishlist =
        await _whishListService.isProductInWhishList(productId);
    return;
  }

  Future<bool> addToCart(
      Product product, int qty, String size, String color) async {
    print("Cart added");
    print(product.key);
    final res = await _apiService.addToCart(product.key, qty, size, color);
    if (res != null) {
      incrementCartCount();
      return true;
    }
    return false;
  }

  Future<bool> buyNow(Product product, int qty, String size, String color) async {
    var res = await addToCart(product, qty, size, color);
    if(res != null) {
      return true;
    }
    return false;
  }

  Future<dynamic> cart() async {
    return await _navigationService.navigateTo(CartViewRoute);
  }

  Future<dynamic> buyNowView(String productId) async {
    return await _navigationService.navigateTo(CartViewRoute, arguments: productId);
  }

  Future<bool> addToWhishList(String id) async {
    final res = await _whishListService.addWhishList(id);
    if (res) {
      isProductInWhishlist = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeFromWhishList(String id) async {
    final res = await _whishListService.removeWhishList(id);
    if (res) {
      isProductInWhishlist = false;
      notifyListeners();
      return true;
    }
    return false;
  }
}
