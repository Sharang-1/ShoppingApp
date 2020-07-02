import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/models/grid_view_builder_filter_models/cartFilter.dart';
import 'package:compound/ui/views/cart_select_delivery_view.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/shared_styles.dart';

class myAppointments extends StatelessWidget {
  final searchController = TextEditingController();

  final filter = CartFilter();
  bool clicked = false;
  static double price = 300, discount = 30, deliveryCharges = 0;
  static double discountedPrice = price - (price * discount / 100);

  Map<String, String> orderSummaryDetails = {
    "Product Name": "Nike T-Shirt",
    "Seller": "Nike",
    "Qty": "1",
    "Size": "S",
    "Shipping To": "Rohan Shah",
    "Shipping Address": "ABC appartment,Naranpura-380013",
    "Price": rupeeUnicode + price.toString(),
    "Discount": discount.toString() + "%",
    "Order Total": rupeeUnicode + discountedPrice.toString(),
    "Delivery Charges": deliveryCharges.toString(),
    "Total": rupeeUnicode + (discountedPrice + deliveryCharges).toString()
  };
  Map<String, String> sellerDetails = {
    "name": "Ketan Works",
    "id": "#4324558",
    "date": "22",
    "month": "March",
    "year": "2020",
    "day": "Tuesday",
    "time": "2:40 pm",
    "status": "pending",
  };
  static const orderSummaryDetails1 = ["Product Name", "Seller", "Qty", "Size"];
  static const orderSummaryDetails2 = ["Shipping To", "Shipping Address"];
  static const orderSummaryDetails3 = [
    "Price",
    "Discount",
    "Order Total",
    "Delivery Charges",
    "Total"
  ];

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double priceFontSize = subtitleFontSizeStyle - 2;
    const double titleFontSize = subtitleFontSizeStyle;
    const double headingFontSize = headingFontSizeStyle + 5;
    const double headingSize = 20;
    const double subHeadingSize = 18;

    return ViewModelProvider<CartViewModel>.withConsumer(
        viewModel: CartViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backgroundWhiteCreamColor,
                centerTitle: true,
                title: SvgPicture.asset(
                  "assets/svg/logo.svg",
                  color: logoRed,
                  height: 35,
                  width: 35,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              backgroundColor: backgroundWhiteCreamColor,
              body: SafeArea(
                top: true,
                left: false,
                right: false,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: screenPadding,
                      right: screenPadding,
                      top: 10,
                      bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        verticalSpace(20),
                        Text(
                          "My Appointments",
                          style: TextStyle(
                              fontFamily: headingFont,
                              fontWeight: FontWeight.w700,
                              fontSize: headingFontSize),
                        ),
                        verticalSpace(20),
                        productCard(headingSize, subHeadingSize, context),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                                elevation: 5,
                                onPressed: () {},
                                color: textIconOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  // side: BorderSide(
                                  //     color: Colors.black, width: 0.5)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(children: <Widget>[
                                    Icon(
                                      Icons.directions,
                                      color: Colors.white,
                                    ),
                                    horizontalSpaceTiny,
                                    Text(
                                      "Directions",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                )),
                            RaisedButton(
                                elevation: 0,
                                onPressed: () {},
                                color: backgroundWhiteCreamColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: logoRed, width: 2)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: CustomText(
                                    "Cancel",
                                    fontSize: 16,
                                    isBold: true,
                                    color: logoRed,
                                  ),
                                )),
                          ],
                        ),
                      ]),
                )),
              ),
              // ),
              // )
            ));
  }

  Widget productCard(headingSize, subHeadingSize, context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(curve15),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                verticalSpaceTiny,
                CustomText(
                  sellerDetails["name"],
                  dotsAfterOverFlow: true,
                  isTitle: true,
                  isBold: true,
                  fontSize: headingSize,
                ),
                verticalSpaceTiny,
                Row(
                  children: <Widget>[
                    CustomText(
                      "BOOKING ID",
                      isBold: true,
                      color: logoRed,
                      fontSize: subHeadingSize - 2,
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                        child: CustomText(
                      sellerDetails["id"],
                      dotsAfterOverFlow: true,
                      isBold: true,
                      color: logoRed,
                      fontSize: subHeadingSize - 2,
                    ))
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              sellerDetails["date"] +
                                  " , " +
                                  sellerDetails["month"] +
                                  " , " +
                                  sellerDetails["year"],
                              isBold: true,
                              color: Colors.grey[600],
                              fontSize: subHeadingSize,
                            ),
                            verticalSpaceTiny,
                            CustomText(
                              sellerDetails["time"] +
                                  " , " +
                                  sellerDetails["day"],
                              isBold: true,
                              color: Colors.grey[600],
                              fontSize: subHeadingSize,
                            ),
                          ]),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                          color: textIconOrange,
                          borderRadius: BorderRadius.circular(curve30)),
                      child: CustomText(
                        sellerDetails["status"],
                        color: Colors.white,
                        fontSize: 12,
                        isBold: true,
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
