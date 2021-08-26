import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants/route_names.dart';
import '../controllers/home_controller.dart';
import '../locator.dart';
import '../models/app_info.dart';
import '../ui/views/order_error_view.dart';
import 'api/api_service.dart';
import 'error_handling_service.dart';
import 'navigation_service.dart';

class PaymentService {
  String razorPayAPIKey;
  Razorpay _razorpay;
  AppInfo appInfo;

  Future init() async {
    _razorpay = Razorpay();
    await getApiKey();
  }

  Future<String> getApiKey() async {
    if (locator<HomeController>()?.isLoggedIn ?? true)
      appInfo = await locator<APIService>().getAppInfo();
    if (appInfo != null) razorPayAPIKey = appInfo.payment.apiKey;
    return razorPayAPIKey;
  }

  Future makePayment(
      {@required num amount,
      @required String contactNo,
      @required String orderId,
      @required String receiptId,
      @required String dzorOrderId,
      String email,
      String name = 'Dzor Infotech Pvt Ltd',
      String currency = 'INR',
      String description = ''}) async {
    if (razorPayAPIKey == null) {
      razorPayAPIKey = await getApiKey();
    }
    if (razorPayAPIKey != null) {
      var options = {
        'key': razorPayAPIKey,
        'amount': int.parse(amount.toStringAsFixed(2).replaceAll(".", "")),
        'currency': currency,
        'order_id': orderId,
        'receipt': receiptId,
        'name': appInfo?.payment?.merchantName ?? name,
        'description': description,
        'prefill': {
          'contact': contactNo,
          'email': email ?? (appInfo?.payment?.email ?? "info@dzor.in")
        },
        'theme': {
          'color': '#bE505F',
        }
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

        print(
            "RazorPay Error: Code: ${response.code} Msg: ${response.message}");
        locator<ErrorHandlingService>().showError(Errors.CouldNotPlaceAnOrder);
        await NavigationService.off(
          PaymentErrorScreenRoute,
          arguments: OrderError.PAYMENT_ERROR,
        );
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
          (ExternalWalletResponse response) {
        print("RazorPay External Wallet: " + response.walletName);
      });

      try {
        _razorpay.open(options);
      } catch (e) {
        print("RazorPay : ${e.toString()}");
        await NavigationService.off(
          PaymentFinishedScreenRoute,
          arguments: OrderError.PAYMENT_ERROR,
        );
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
