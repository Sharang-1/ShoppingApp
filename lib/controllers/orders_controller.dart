import 'package:compound/app/app.dart';
import 'package:compound/models/ordersV2.dart' as ov2;
import 'package:flutter/material.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/orders.dart';
import '../services/api/api_service.dart';
import '../services/navigation_service.dart';
import '../ui/views/home_view.dart';
import '../ui/views/myorders_details_view.dart';
import 'base_controller.dart';
import 'cart_controller.dart';

class OrdersController extends BaseController {
  final APIService _apiService = locator<APIService>();

 late ov2.OrdersV2 mOrders;
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

      List<ov2.Order> allOrders = (await locator<APIService>().getAllOrders())!.orders!;
      late ov2.Order o;
      if (appVar.previousOrders.length != 0) {
        for (int i = 0; i < appVar.previousOrders.length; i++) {
          if (allOrders[i].key == appVar.previousOrders[i].key) {
            print(i);
            continue;
          } else {
            o = allOrders[i];
            break;
          }
        }
      }
      else{
        o = allOrders.first;
      }
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          // builder: (context) => MyOrdersDetailsView(o),
          builder: (context) => HomeView(),

        ),
        ModalRoute.withName(HomeViewRoute),
      );
      if (await CartController().hasProducts())
        await NavigationService.to(CartViewRoute);
    });
  }

  static Future orderError(context) async {
    Future.delayed(Duration(milliseconds: 3500), () async {
      await NavigationService.offAll(HomeViewRoute);
    });
  }
}
