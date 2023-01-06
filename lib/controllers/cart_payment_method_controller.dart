import 'dart:developer';

import 'dart:convert';

import 'package:compound/models/orderV2_response.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/groupOrderByGoupId.dart' as gId;
import '../models/order.dart';
import '../models/orderV2.dart';
import '../services/api/api_service.dart';
import '../services/navigation_service.dart';
import '../services/payment_service.dart';
import 'base_controller.dart';

class CartPaymentMethodController extends BaseController {
  final APIService _apiService = locator<APIService>();
  final PaymentService _paymentService = locator<PaymentService>();
  final Map<int, String> paymentOptions = {};
  final String city;

  CartPaymentMethodController({required this.city});

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
        1: "Pay Online on Delivery",
        2: "Pay Now",
      },
    );
    print("city122: $city");
    // if (city == null) {
    //   paymentOptions.remove(1);
    // }
    // if (!<String>["AHMEDABAD"].contains(city.toUpperCase())) {
    //   paymentOptions.remove(1);
    // }
    update();

    return null;
  }

  Future<GroupOrderResponseModel?> createGroupOrder(
    double orderCost,
    CustomerDetails customerDetails,
    List<dynamic> products,
    int paymentOption,
  ) async {
    setBusy(true);
    final GroupOrderResponseModel? order = await _apiService.createGroupOrder(
        customerDetails: customerDetails, products: products, paymentOption: paymentOption);
    if (order != null) {
      // if (order.payment!.option!.id != 2) {
      //   setBusy(false);
      //   return order;
      // }

      if (paymentOption != 2) {
        setBusy(false);
        return order;
      }

      final gId.GroupOrderByGroupId? groupOrderbyId =
          await _apiService.getOrderbyGroupqueueid(groupQueueId: order.groupQueueId);

      for (var i = 0; i < (groupOrderbyId?.records ?? 0); i++ ){
        if(groupOrderbyId?.orders?[i].statusFlow?.id == -1){
          await NavigationService.off(
            PaymentErrorScreenRoute,
            arguments: "One of the items in cart is no longer available",
          );
        }
      }
      
        if (groupOrderbyId != null) {
          log("payment api called");
          log("order id ${groupOrderbyId.orders!.first.commonField!.payment!.orderId!}");
          log("receipt id ${groupOrderbyId.orders!.first.commonField!.payment!.receiptId!}");
          // ? razorpay payment redirect
          await _paymentService.makePayment(
            amount: orderCost,
            groupId: groupOrderbyId.orders![0].commonField!.groupQueueId!,
            contactNo: customerDetails.customerPhone!.mobile.toString(),
            orderId: groupOrderbyId.orders![0].commonField!.payment!.orderId!,
            receiptId: groupOrderbyId.orders![0].commonField!.payment!.receiptId!,
            dzorOrderId: groupOrderbyId.orders![0].commonField!.payment!.orderId!,
          );
        }
    }
    setBusy(false);
    return null;
  }

  // Future<Order?> createOrder(
  //     String billingAddress,
  //     String productId,
  //     String promoCode,
  //     String promoCodeId,
  //     String size,
  //     String color,
  //     int qty,
  //     int paymentOptionId,
  //     int pincode) async {
  //   setBusy(true);
  //   final order = await _apiService.createOrder(billingAddress, productId, promoCode, promoCodeId,
  //       size, color, qty, paymentOptionId, pincode);
  //   if (order != null) {
  //     if (order.payment!.option!.id != 2) {
  //       setBusy(false);
  //       return order;
  //     }

  //     await _paymentService.makePayment(
  //       amount: order.orderCost!.cost!,
  //       contactNo: order.billingPhone!.mobile!,
  //       orderId: order.payment!.orderId!,
  //       receiptId: order.payment!.receiptId!,
  //       dzorOrderId: order.key!,
  //     );
  //   }
  //   setBusy(false);
  //   return null;
  // }
}
