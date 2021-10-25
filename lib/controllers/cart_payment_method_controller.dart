import '../locator.dart';
import '../models/order.dart';
import '../services/api/api_service.dart';
import '../services/payment_service.dart';
import 'base_controller.dart';

class CartPaymentMethodController extends BaseController {
  final APIService _apiService = locator<APIService>();
  final PaymentService _paymentService = locator<PaymentService>();
  final Map<int, String> paymentOptions = {};
  final String city;

  CartPaymentMethodController({this.city});

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

    paymentOptions.addAll(
      {
        1: "Cash On Delivery",
        2: "Pay Online",
      },
    );
    if (!<String>["AHMEDABAD"].contains(city.toUpperCase())) {
      paymentOptions.remove(1);
    }
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
      int pincode) async {
    setBusy(true);
    final order = await _apiService.createOrder(billingAddress, productId,
        promoCode, promoCodeId, size, color, qty, paymentOptionId, pincode);
    if (order != null) {
      if (order.payment.option.id != 2) {
        setBusy(false);
        return order;
      }

      await _paymentService.makePayment(
        amount: order.orderCost.cost,
        contactNo: order.billingPhone.mobile,
        orderId: order.payment.orderId,
        receiptId: order.payment.receiptId,
        dzorOrderId: order.key,
      );
    }
    setBusy(false);
    return null;
  }
}
