import 'package:compound/viewmodels/orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/shared_styles.dart';
import '../shared/app_colors.dart';

class OrderPlacedView extends StatelessWidget {

  String productName, sellerName;

  //dummy data passed
  OrderPlacedView({this.productName = "Product Name", this.sellerName = "Seller Name"});

  @override
  Widget build(BuildContext context) {
    const double subtitleFontSize = subtitleFontSizeStyle - 1;
    return ViewModelProvider<OrdersViewModel>.withConsumer(
      viewModel: OrdersViewModel(),
      onModelReady: (model) => model.orderPlaced(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(alignment: Alignment.center, children: <Widget>[
                Icon(
                  Icons.check,
                  color: green,
                  size: MediaQuery.of(context).size.width * 0.2,
                )
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                child: Column(children: <Widget>[
                  Text(
                    "Your order has been received.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: headingFont,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: subtitleFontSize),
                  ),
                  // Text(
                  //   "${productName} by ${sellerName}",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       fontFamily: headingFont,
                  //       color: Colors.grey[800],
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: subtitleFontSize),
                  // )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}