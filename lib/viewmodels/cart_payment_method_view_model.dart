import 'package:compound/locator.dart';
import 'package:compound/models/order.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/base_model.dart';
// import 'package:fimber/fimber.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPaymentMethodViewModel extends BaseModel {
  // static const String RAZOR_PAY_API_KEY_ID = 'rzp_test_0plCuiiDvrasf9';

  final APIService _apiService = locator<APIService>();
  // Razorpay _razorpay;

  final paymentOptions = [
    {"id": 1, "name": "Cash on delivery"},
    {"id": 2, "name": "Paytm"},
    {"id": 3, "name": "PhonePe"},
    {"id": 4, "name": "Google pay - Tez"}
  ];

  Future init() {
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
    // var options = {
    //   'key': RAZOR_PAY_API_KEY_ID,
    //   'amount': int.parse('50000'),
    //   'currency': 'INR',
    //   'name': 'Dzor',
    //   'description': 'Dzor Product',
    //   'prefill': {
    //     'contact': '9999999999',
    //     'email': 'dzor@gmail.com'
    //   },
    //   'theme': {
    //     'color': '#bE505F',
    //   }
    // };

    // try {
    //   _razorpay.open(options);
    // } catch (e) {
    //   Fimber.e(e.toString());
    // }

    final res = await _apiService.createOrder(billingAddress, productId, promoCode, promoCodeId, size, color, qty, paymentOptionId);
    if(res != null) {
      return res;
    }
    return null;
  }

  // _handlePaymentSuccess(PaymentSuccessResponse response) {}

  // _handlePaymentError(PaymentFailureResponse response) {}

  // _handleExternalWallet(ExternalWalletResponse response) {}
}
