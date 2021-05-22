import '../locator.dart';
import '../models/order.dart';
import '../services/api/api_service.dart';
import 'base_controller.dart';
import 'lookup_controller.dart';
// import 'package:fimber/fimber.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPaymentMethodController extends BaseController {
  // static const String RAZOR_PAY_API_KEY_ID = 'rzp_test_0plCuiiDvrasf9';

  final APIService _apiService = locator<APIService>();
  // Razorpay _razorpay;

  final Map<int, String> paymentOptions = {};

  Future<void> onInit() async {
    super.onInit();
    locator<LookupController>()
        .lookups
        .firstWhere((e) => e.sectionName == 'Order')
        .sections
        .firstWhere((e) => e.option == "paymentOptions")
        .values
        .forEach((e) {
      paymentOptions.addAll({e.id: e.name});
    });
    update();
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

    final res = await _apiService.createOrder(billingAddress, productId,
        promoCode, promoCodeId, size, color, qty, paymentOptionId);
    if (res != null) {
      return res;
    }
    return null;
  }

  // _handlePaymentSuccess(PaymentSuccessResponse response) {}

  // _handlePaymentError(PaymentFailureResponse response) {}

  // _handleExternalWallet(ExternalWalletResponse response) {}
}
