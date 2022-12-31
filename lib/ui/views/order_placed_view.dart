import 'package:compound/app/groupOrderData.dart';
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
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/images/order_placed.gif",
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Your order has been received \n Thank You for shopping with us!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: headingFont,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: titleFontSize + 2,
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: 50,
            //   child: Container(
            //     constraints : BoxConstraints(maxWidth : MediaQuery.of(context).size.width - 20),
            //     padding: const EdgeInsets.all(20),
            //     child: Text(
            //       "Thanks for making ${GroupOrderData.sellersList[0]}, ${GroupOrderData.sellersList[0]}'s day!",
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         fontFamily: headingFont,
            //         color: Colors.black,
            //         fontWeight: FontWeight.w500,
            //         fontSize: titleFontSize + 1,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
