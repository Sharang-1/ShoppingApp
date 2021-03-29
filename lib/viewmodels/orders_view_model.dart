// import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/orders.dart';
import '../services/api/api_service.dart';
import '../ui/views/myorders_details_view.dart';

class OrdersViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();
  // final DialogService _dialogService = locator<DialogService>();

  Orders mOrders;
  Future getOrders() async {
    setBusy(true);
    final result = await _apiService.getAllOrders();
    setBusy(false);
    if (result != null) {
      mOrders = result;
    }
    notifyListeners();
  }

  Future orderPlaced(context) async {
    Future.delayed(Duration(milliseconds: 2500), () async {
      Order o = (await _apiService.getAllOrders()).orders.first;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyOrdersDetailsView(o),
        ),
        ModalRoute.withName(HomeViewRoute),
      );
    });
  }
}
