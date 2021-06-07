// import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/controllers/base_controller.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/calculatedPrice.dart';
import 'package:compound/models/promoCode.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    userName = prefs.getString(Name);
    update();
    return;
  }

  Future<void> removeProductFromCartEvent() async {
    await _analyticsService.sendAnalyticsEvent(eventName: "remove_from_cart");
    var products = await _apiService.getCartProductItemList();
    isCartEmpty = products.isEmpty;
    update();
    return;
  }

  Future<bool> hasProducts() async {
    var products = await _apiService.getCartProductItemList();
    isCartEmpty = products.isEmpty;
    return !isCartEmpty;
  }

  void hidePairItWith() {
    showPairItWith = false;
    update();
  }

  static Future<PromoCode> applyPromocode(
      String productId, int qty, String code, String promotion) async {
    return await locator<APIService>()
        .applyPromocode(productId, qty, code, promotion);
  }

  static Future<CalculatedPrice> calculateProductPrice(
      String productId, int qty) async {
    return await locator<APIService>().calculateProductPrice(productId, qty);
  }
}
