import 'package:compound/models/app_info.dart';
import 'package:compound/models/orderV2.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/payment_service.dart';

import '../locator.dart';
import 'base_controller.dart';

class GroupOrderPaymentController extends BaseController {
  final APIService _apiService = locator<APIService>();
  final PaymentService _paymentService = locator<PaymentService>();
  final Map<int, String> paymentOptions = {};
  final String city;

  GroupOrderPaymentController({required this.city});

  Future<void> onInit() async {
    super.onInit();
    paymentOptions.addAll(
      {
        1: "Pay Online on Delivery",
        2: "Pay Now",
      },
    );
    print("city122: $city");
    update();

    return null;
  }

  Future<Order2?> createGroupOrder() async {
    setBusy(true);
    final order = await _apiService.createGroupOrder();
    if (order != null) {
      setBusy(false);
      return order;
    }
    
    setBusy(false);
    return null;
  }
}
