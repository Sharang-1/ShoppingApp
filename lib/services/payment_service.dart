import 'dart:developer';
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
  String? razorPayAPIKey;
  Razorpay? _razorpay;
  AppInfo? appInfo;

  Future init() async {
    if (kDebugMode) log("Payment Init called");
    _razorpay = Razorpay();
    await getApiKey();
  }

  Future<String?> getApiKey() async {
    log("fetch api key");
    if (kDebugMode) log("in Payment Service Api");
    if (locator<HomeController>().isLoggedIn) {
      if (kDebugMode) log("Get API Key in Razor Pay");
      appInfo = (await locator<APIService>().getAppInfo())!;
    }
    if (appInfo != null) razorPayAPIKey = appInfo!.payment.apiKey!;
    if (kDebugMode) log("Razor pay API Key $appInfo");
    return razorPayAPIKey;
  }

  Future makePayment(
      {required num amount,
      required String contactNo,
      required String orderId,
      required String receiptId,
      required String dzorOrderId,
      required String groupId,
      String? email,
      String name = 'Dzor Infotech Pvt Ltd',
      String currency = 'INR',
      String description = ''}) async {
    log("inside payment api");
    // if (razorPayAPIKey == null) {
    razorPayAPIKey = await getApiKey();
    // }
    if (razorPayAPIKey != null) {
      var options = {
        'key': razorPayAPIKey,
        'amount': int.parse(amount.toStringAsFixed(2).replaceAll(".", "")),
        'currency': currency,
        'order_id': orderId,
        'receipt': receiptId,
        'name': appInfo?.payment.merchantName ?? name,
        'description': description,
        'prefill': {
          'contact': contactNo,
          'email': email ?? (appInfo?.payment.email ?? "info@dzor.in")
        },
        'theme': {
          'color': '#bE505F',
        }
      };

      if (kDebugMode)
        log("Order Cost: $amount ${int.parse(amount.toStringAsFixed(2).replaceAll(".", ""))}");

      _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) async {
        if (kDebugMode) log("OrderId: " + response.orderId!);
        if (kDebugMode) log("Payment Id: " + response.paymentId!);
        if (kDebugMode) log("Signature: " + response.signature!);

        await locator<APIService>().verifyGroupPayment(
          // orderId: dzorOrderId,
          groupId: groupId,
          paymentId: response.paymentId,
          signature: response.signature,
          success: true,
        );
        // await locator<APIService>().verifyPayment(
        //   orderId: dzorOrderId,
        //   paymentId: response.paymentId,
        //   signature: response.signature,
        //   msg: "Success",
        //   success: true,
        // );

        await NavigationService.off(PaymentFinishedScreenRoute);
      });

      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) async {
        await locator<APIService>().verifyGroupPayment(
          // orderId: dzorOrderId,
          groupId: groupId,
          success: false,
        );
        // await locator<APIService>().verifyPayment(
        //   orderId: dzorOrderId,
        //   msg: response.message,
        //   success: false,
        // );

        if (kDebugMode) log("RazorPay Error: Code: ${response.code} Msg: ${response.message}");
        locator<ErrorHandlingService>().showError(Errors.CouldNotPlaceAnOrder);
        await NavigationService.off(
          PaymentErrorScreenRoute,
          arguments: OrderError.PAYMENT_ERROR,
        );
      });
      _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
        if (kDebugMode) log("RazorPay External Wallet: " + response.walletName!);
      });

      try {
        _razorpay?.open(options);
      } catch (e) {
        if (kDebugMode) log("RazorPay : ${e.toString()}");
        await NavigationService.off(
          PaymentFinishedScreenRoute,
          arguments: OrderError.PAYMENT_ERROR,
        );
        return null;
      }
    }
  }
}
