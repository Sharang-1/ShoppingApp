// import 'package:compound/services/navigation_service.dart';
import 'package:compound/controllers/base_controller.dart';
import 'package:compound/controllers/cart_controller.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/orders.dart';
import '../services/api/api_service.dart';
import '../ui/views/myorders_details_view.dart';

class OrdersController extends BaseController {
  final APIService _apiService = locator<APIService>();


  Orders mOrders;
  Future getOrders() async {
    setBusy(true);
    final result = await _apiService.getAllOrders();
    setBusy(false);
    if (result != null) {
      mOrders = result;
    }
    update();
  }

  static Future orderPlaced(context) async {
    Future.delayed(Duration(milliseconds: 2500), () async {
      Order o = (await locator<APIService>().getAllOrders()).orders.first;
      // await NavigationService.offAll()
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyOrdersDetailsView(o),
        ),
        ModalRoute.withName(HomeViewRoute),
      );
      if (await CartController().hasProducts()) await NavigationService.to(CartViewRoute);
    });
  }
}
