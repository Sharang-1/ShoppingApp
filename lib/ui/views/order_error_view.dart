import 'package:flutter/material.dart';

import '../../controllers/orders_controller.dart';

class OrderErrorView extends StatelessWidget {
  final OrderError error;
  const OrderErrorView({this.error = OrderError.ORDER_NOT_PLACED});

  @override
  Widget build(BuildContext context) {
    OrdersController.orderError(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Image.asset(
                error == OrderError.ORDER_NOT_PLACED
                    ? "assets/images/order_error.gif"
                    : "assets/images/payment_error.gif",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum OrderError {
  ORDER_NOT_PLACED,
  PAYMENT_ERROR,
}
