// import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/calculatedPrice.dart';
import 'package:compound/models/promoCode.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/api/api_service.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  final prductId;
  String userName;
  bool isCartEmpty = true;

  CartViewModel({this.prductId = "", this.userName = ""});

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(Name);
    notifyListeners();
    return;
  }

  Future<void> removeProductFromCartEvent() async {
    await _analyticsService.sendAnalyticsEvent(eventName: "remove_from_cart");
    var products = await _apiService.getCartProductItemList();
    isCartEmpty = products.isEmpty;
    notifyListeners();
    return;
  }

  Future<PromoCode> applyPromocode(
      String productId, int qty, String code, String promotion) async {
    return await _apiService.applyPromocode(productId, qty, code, promotion);
  }

  Future<CalculatedPrice> calculateProductPrice(
      String productId, int qty) async {
    return await _apiService.calculateProductPrice(productId, qty);
  }

  Future<bool> hasProducts() async {
    var products = await _apiService.getCartProductItemList();
    isCartEmpty = products.isEmpty;
    return !isCartEmpty;
  }
}
