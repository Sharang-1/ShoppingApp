import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/app_info.dart';
import 'api/api_service.dart';
import 'error_handling_service.dart';
import 'navigation_service.dart';

class PaymentService {
  String razorPayAPIKey;
  Razorpay _razorpay;

  Future init() async {
    _razorpay = Razorpay();
    await getApiKey();
  }

  Future<String> getApiKey() async {
    AppInfo _appInfo = await locator<APIService>().getAppInfo();
    if (_appInfo != null) razorPayAPIKey = _appInfo.payment.apiKey;
    return razorPayAPIKey;
  }

  Future makePayment(
      {@required num amount,
      @required String contactNo,
      @required String email,
      @required String orderId,
      @required String receiptId,
      @required String dzorOrderId,
      String name = 'Dzor Infotech Pvt Ltd',
      String currency = 'INR',
      String description = ''}) async {
    if (razorPayAPIKey != null) {
      var options = {
        'key': razorPayAPIKey,
        'amount': int.parse(amount.toStringAsFixed(2).replaceAll(".", "")),
        'currency': currency,
        'order_id': orderId,
        'receipt': receiptId,
        'name': name,
        'description': description,
        'prefill': {'contact': contactNo, 'email': email},
        'theme': {
          'color': '#bE505F',
        },
        'external': {'wallets': []}
      };

      print(
          "Order Cost: $amount ${int.parse(amount.toStringAsFixed(2).replaceAll(".", ""))}");

      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) async {
        print("OrderId: " + response.orderId);
        print("Payment Id: " + response.paymentId);
        print("Signature: " + response.signature);

        await locator<APIService>().verifyPayment(
          orderId: dzorOrderId,
          paymentId: response.paymentId,
          signature: response.signature,
          msg: "Success",
          success: true,
        );

        await NavigationService.off(PaymentFinishedScreenRoute);
      });

      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
          (PaymentFailureResponse response) async {
        await locator<APIService>().verifyPayment(
          orderId: dzorOrderId,
          msg: response.message,
          success: false,
        );

        print("RazorPay Error: " + response.message);
        locator<ErrorHandlingService>().showError(Errors.CouldNotPlaceAnOrder);
        NavigationService.offAll(HomeViewRoute);
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse response) {
        print("RazorPay External Wallet: " + response.walletName);
      });

      try {
        _razorpay.open(options);
      } catch (e) {
        return null;
      }
    }
  }

  // _handlePaymentSuccess(PaymentSuccessResponse response) async {
  // print("OrderId: " + response.orderId);
  // print("Payment Id: " + response.paymentId);
  // print("Signature: " + response.signature);
  // }

  // _handlePaymentError(PaymentFailureResponse response) {
  //   print("RazorPay Error: " + response.message);
  // }

  // _handleExternalWallet(ExternalWalletResponse response) {
  //   print("RazorPay External Wallet: " + response.walletName);
  // }
}
