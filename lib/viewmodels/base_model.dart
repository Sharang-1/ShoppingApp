import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/user.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/cart_local_store_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final APIService _apiService = locator<APIService>();
  User get currentUser => _authenticationService.currentUser;
  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  // For local cart items persistance

  Future<void> setCartList(List<String> list) {
    return _cartLocalStoreService.setCartList(list);
  }

  Future<int> addToCartLocalStore(String productId) {
    return _cartLocalStoreService.addToCartLocalStore(productId);
  }

  Future<void> removeFromCartLocalStore(String productId) {
    return _cartLocalStoreService.removeFromCartLocalStore(productId);
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
    return _navigationService.navigateTo(ProductIndividualRoute,
        arguments: data);
  }

  Future<dynamic> goToProductListPage(ProductPageArg arg) {
    return _navigationService.navigateTo(ProductsListRoute, arguments: arg);
  }

  Future<dynamic> goToSellerPage(String sellerId) async {
    Seller seller = await _apiService.getSellerByID(sellerId);
    return _navigationService.navigateTo(SellerIndiViewRoute,
        arguments: seller);
  }

  Future<dynamic> goToAddressInputPage() {
    return _navigationService.navigateTo(AddressInputPageRoute);
  }

  Future openmap() async {
    await _navigationService.navigateTo(MapViewRoute);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Authtoken);
    prefs.remove(PhoneNo);
    await _navigationService.navigateReplaceTo(LoginViewRoute);
  }
}
