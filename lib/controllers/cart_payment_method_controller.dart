import 'package:compound/services/payment_service.dart';

import '../locator.dart';
import '../models/order.dart';
import '../services/api/api_service.dart';
import 'base_controller.dart';

class CartPaymentMethodController extends BaseController {
  final APIService _apiService = locator<APIService>();
  final PaymentService _paymentService = locator<PaymentService>();

  final Map<int, String> paymentOptions = {};

  Future<void> onInit() async {
    super.onInit();
    // locator<LookupController>()
    //     .lookups
    //     .firstWhere((e) => e.sectionName == 'Order')
    //     .sections
    //     .firstWhere((e) => e.option == "paymentOptions")
    //     .values
    //     .forEach((e) {
    //   paymentOptions.addAll({e.id: e.name});
    // });

    paymentOptions.addAll({1: "Cash On Delivery", 2: "Pay Online"});
    update();

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
    final order = await _apiService.createOrder(billingAddress, productId,
        promoCode, promoCodeId, size, color, qty, paymentOptionId);
    if (order != null) {
      if (order.payment.option.id != 2) return order;

      //TODO: static email
      await _paymentService.makePayment(
        amount: order.orderCost.cost,
        contactNo: order.billingPhone.mobile,
        orderId: order.payment.orderId,
        receiptId: order.payment.receiptId,
        dzorOrderId: order.key,
        email: 'abc@gmail.com',
      );
    }
    return null;
  }
}
