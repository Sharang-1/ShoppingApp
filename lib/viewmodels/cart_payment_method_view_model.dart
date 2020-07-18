// import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/order.dart';
import 'package:compound/services/api/api_service.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class CartPaymentMethodViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();

  final paymentOptions = [
    {"id": 1, "name": "Cash on delivery"},
    {"id": 2, "name": "Paytm"},
    {"id": 3, "name": "PhonePe"},
    {"id": 4, "name": "Google pay - Tez"}
  ];

  Future init() {
    return null;
  }

  Future<Order> createOrder(
    String billingAddress,
    String productId,
    String promoCode,
    String promoCodeId,
    String size,
    String color,
    int qty,
    int paymentOptionId,
  ) async {
    final res = await _apiService.createOrder(billingAddress, productId, promoCode, promoCodeId, size, color, qty, paymentOptionId);
    if(res != null) {
      return res;
    }

    return null;
  }
}
