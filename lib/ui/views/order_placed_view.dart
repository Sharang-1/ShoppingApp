import 'package:flutter/material.dart';

import '../../controllers/orders_controller.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class OrderPlacedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrdersController.orderPlaced(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/images/order_placed.gif",
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Your order has been received.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: headingFont,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: titleFontSize,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
