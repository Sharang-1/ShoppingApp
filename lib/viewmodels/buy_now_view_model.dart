import 'package:compound/locator.dart';
import 'package:compound/models/calculatedPrice.dart';
import 'package:compound/models/promoCode.dart';
import 'package:compound/services/api/api_service.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class BuyNowViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();

  Future init() {
    return null;
  }

  Future<PromoCode> applyPromocode(String productId, int qty, String code, String promotion) async {
    return await _apiService.applyPromocode(productId, qty, code, promotion);
  }

  Future<CalculatedPrice> calculateProductPrice(String productId, int qty) async {
    return await _apiService.calculateProductPrice(productId, qty);
  }
}
