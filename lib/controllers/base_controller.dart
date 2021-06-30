import 'package:compound/controllers/home_controller.dart';
import 'package:compound/ui/widgets/login_bottomsheet.dart';
import 'package:compound/ui/widgets/size_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

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
import '../services/navigation_service.dart';

class BaseController extends GetxController {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final CartLocalStoreService _cartLocalStoreService =
      locator<CartLocalStoreService>();
  User get currentUser => _authenticationService.currentUser;
  bool _busy = false;
  bool get busy => _busy;
  static const num deliveryCharge = 35.40;
  num get deliveryCharges => deliveryCharge;

  void setBusy(bool value) {
    _busy = value;
    update();
  }

  // For local cart items persistance
  Future<void> setCartList(List<String> list) =>
      _cartLocalStoreService.setCartList(list);

  Future<int> addToCartLocalStore(String productId) async => locator<HomeController>().isLoggedIn ?
      _cartLocalStoreService.addToCartLocalStore(productId) : await showLoginPopup(
          nextView: CartViewRoute,
          shouldNavigateToNextScreen: true,
        );

  Future<void> removeFromCartLocalStore(String productId) =>
      _cartLocalStoreService.removeFromCartLocalStore(productId);

  //static methods

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Authtoken);
    await prefs.remove(PhoneNo);
    await prefs.remove(AddressList);
    await NavigationService.offAll(LoginViewRoute);
  }

  static Future<void> launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static Future vibrate(
          {int duration = 500,
          List<int> pattern = const [],
          int repeat = -1,
          List<int> intensities = const [],
          int amplitude = -1}) =>
      Vibration.vibrate(
          duration: duration,
          pattern: pattern,
          repeat: repeat,
          intensities: intensities,
          amplitude: amplitude);

  // Goto Pages
  static Future<void> search() async =>
      await NavigationService.to(SearchViewRoute);
  static Future<dynamic> cart() async => locator<HomeController>().isLoggedIn
      ? await NavigationService.to(CartViewRoute)
      : await showLoginPopup(
          nextView: CartViewRoute,
          shouldNavigateToNextScreen: true,
        );
  static Future<void> category() async =>
      await NavigationService.to(CategoriesRoute);
  static Future<dynamic> gotoSettingsPage() async =>
      await NavigationService.to(SettingsRoute);
  static Future<dynamic> gotoWishlist() async =>
      locator<HomeController>().isLoggedIn
          ? await NavigationService.to(WishListRoute)
          : await showLoginPopup(
              nextView: WishListRoute,
              shouldNavigateToNextScreen: true,
            );
  static Future<dynamic> goToProductPage(Product data) =>
      NavigationService.to(ProductIndividualRoute, arguments: data);
  static Future<dynamic> goToProductListPage(ProductPageArg arg) =>
      NavigationService.to(ProductsListRoute, arguments: arg);

  static Future<dynamic> goToSellerPage(String sellerId) async {
    Seller seller = await locator<APIService>().getSellerByID(sellerId);
    if (locator<HomeController>().isLoggedIn) {
      return NavigationService.to(SellerIndiViewRoute, arguments: seller);
    } else {
      await showLoginPopup(
        nextView: SellerIndiViewRoute,
        shouldNavigateToNextScreen: true,
        arguments: seller,
      );
    }
  }

  static showLoginPopup(
      {String nextView,
      bool shouldNavigateToNextScreen,
      dynamic arguments}) async {
    await Get.bottomSheet(
      LoginBottomsheet(
        nextView: nextView,
        shouldNavigateToNextScreen: shouldNavigateToNextScreen,
        arguments: arguments,
      ),
      isScrollControlled: true,
    );
  }

  static showSizePopup() async {
    await Get.bottomSheet(
      SizeBottomsheet(),
      isScrollControlled: true,
    );
  }

  static Future<dynamic> goToAddressInputPage() =>
      NavigationService.to(AddressInputPageRoute);
  static Future openmap() async {
    var status = await Location().requestPermission();
    if (status == PermissionStatus.GRANTED) {
      await NavigationService.to(MapViewRoute);
    }
    return;
  }

  static Future<dynamic> shareApp() async =>
      await Share.share("https://dzor.page.link/App");

  static String formatPrice(n) {
    return NumberFormat.simpleCurrency(name: 'INR').format(n);
  }
}
