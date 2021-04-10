import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/productPageArg.dart';
import '../models/products.dart';
import '../models/sellers.dart';
import '../models/user.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/cart_local_store_service.dart';
import '../services/location_service.dart';
import '../services/navigation_service.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  final APIService _apiService = locator<APIService>();
  // ignore: unused_field
  final LocationService _locationService = locator<LocationService>();
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
    var status = await Location().requestPermission();
    if (status == PermissionStatus.GRANTED) {
      await _navigationService.navigateTo(MapViewRoute);
    }
    return;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Authtoken);
    prefs.remove(PhoneNo);
    await _navigationService.navigateReplaceTo(LoginViewRoute);
  }
}
