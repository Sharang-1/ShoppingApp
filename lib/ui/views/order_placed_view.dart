import 'package:compound/ui/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../viewmodels/orders_view_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class OrderPlacedView extends StatelessWidget {
  final String productName, sellerName;

  //dummy data passed
  OrderPlacedView(
      {this.productName = "Product Name", this.sellerName = "Seller Name"});

  @override
  Widget build(BuildContext context) {
    const double subtitleFontSize = subtitleFontSizeStyle - 1;
    return ViewModelProvider<OrdersViewModel>.withConsumer(
      viewModel: OrdersViewModel(),
      onModelReady: (model) => model.orderPlaced(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/svg/logo.svg",
                    color: logoRed,
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5,
                  ),
                  CircularProgressIndicatorWidget(
                    fromCart: false,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
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
                  SizedBox(
                    height: 5,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
