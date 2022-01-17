import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/cart.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import 'base_controller.dart';
import 'home_controller.dart';

class CartController extends BaseController {
  final APIService _apiService = locator<APIService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  final prductId;
  String userName;
  bool isCartEmpty = true;
  bool showPairItWith = true;

  CartController({this.prductId = "", this.userName = ""});

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(Name)!;
    update();
    return;
  }

  Future<void> removeProductFromCartEvent(Product product) async {
    await _analyticsService.sendAnalyticsEvent(
        eventName: "remove_from_cart",
        parameters: <String, dynamic>{
          "product_id": product.key,
          "product_name": product.name,
          "category_id": product.category?.id?.toString(),
          "category_name": product.category?.name,
          "user_id": locator<HomeController>().details?.key,
          "user_name": locator<HomeController>().details?.name,
        });
    var products = await _apiService.getCartProductItemList();
    isCartEmpty = products?.isEmpty ?? false;
    update();
    return;
  }

  Future<bool> hasProducts() async {
    var products = await _apiService.getCartProductItemList();
    isCartEmpty = products?.isEmpty ?? false;
    return !isCartEmpty;
  }

  void hidePairItWith() {
    showPairItWith = false;
    update();
  }
}
