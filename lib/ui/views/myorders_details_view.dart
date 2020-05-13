import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/dashed_line.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';

import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_view_model.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider_architecture/provider_architecture.dart';

class MyOrdersDetailsView extends StatelessWidget {
  Map<String, String> orderSummaryDetails = {
    "Deliver To": "Ahmedabad",
    "Delivery Address": "ABC appartment,Naranpura-380013",
    "Placed On": "02/05/2020",
    "Delivery On": "08/05/2020",
    "Pay Via": "Cash",
    "Price": rupeeUnicode + "300",
    "Discount": "30%",
    "Order Total": rupeeUnicode + "270",
    "Delivery Charges": rupeeUnicode + "40",
    "Total": rupeeUnicode + "310"
  };

  @override
  Widget build(BuildContext context) {
    double subtitleFontSize = 18;
    double titleFontSize = 20;
    double headingFontSize = 24;
    return ViewModelProvider<CartViewModel>.withConsumer(
        viewModel: CartViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backgroundWhiteCreamColor,
                centerTitle: true,
                iconTheme: IconThemeData(color: appBarIconColor),
              ),
              backgroundColor: backgroundWhiteCreamColor,
              body: SafeArea(
                top: true,
                left: false,
                right: false,
                child: SingleChildScrollView(
                    child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        verticalSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CustomText(
                              "Order Details",
                              isTitle: true,
                              fontWeight: FontWeight.w700,
                              fontSize: headingFontSize,
                            ),
                            CustomText(
                              "Order ID: #3874608",
                              fontSize: 16,
                              isTitle: true,
                              color: lightRedSmooth,
                              isBold: true,
                            ),
                          ],
                        ),
                        verticalSpace(10),
                        SizedBox(
                            height: 150,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    width: 100,
                                                    fadeInCurve: Curves.easeIn,
                                                    placeholder:
                                                        "assets/images/placeholder.png",
                                                    image:
                                                        "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                                    fit: BoxFit.cover,
                                                  )),
                                              horizontalSpaceSmall,
                                              Expanded(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  verticalSpaceTiny,
                                                  CustomText(
                                                    "Nike T-Shirt",
                                                    isBold: true,
                                                    fontSize: titleFontSize,
                                                  ),
                                                  verticalSpaceSmall,
                                                  CustomText(
                                                      rupeeUnicode + '100',
                                                      fontSize:
                                                          subtitleFontSize),
                                                  verticalSpaceSmall,
                                                  CustomText("XL",
                                                      color: Colors.grey,
                                                      fontSize:
                                                          subtitleFontSize),
                                                ],
                                              )),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            CustomText(
                                              "Shipping",
                                              fontSize: subtitleFontSize,
                                              isBold: true,
                                              color: Colors.grey,
                                            ),
                                            horizontalSpaceSmall
                                          ],
                                        )
                                      ],
                                    )))),
                        verticalSpaceSmall,
                        spaceDividerExtraThin,
                        verticalSpaceSmall,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              "Delivery Status",
                              fontSize: headingFontSize,
                              isTitle: true,
                              isBold: true,
                            ),
                            verticalSpaceSmall,
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: LinearPercentIndicator(
                                lineHeight: 15.0,
                                percent: 0.4,
                                padding: EdgeInsets.zero,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                linearGradient: LinearGradient(
                                    colors: [textIconOrange, logoRed]),
                              ),
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(
                                  "Estimated Delivery:",
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey,
                                ),
                                CustomText(
                                  "2 June 2020",
                                  fontSize: subtitleFontSize,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        spaceDividerExtraThin,
                        verticalSpaceSmall,

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              "Payment Information",
                              fontSize: headingFontSize,
                              isTitle: true,
                              isBold: true,
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(
                                  "Price",
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey,
                                ),
                                CustomText(
                                  rupeeUnicode + "300",
                                  fontSize: subtitleFontSize,
                                  isBold: true,
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(
                                  "Order Total",
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey,
                                ),
                                CustomText(
                                  rupeeUnicode + "270",
                                  fontSize: subtitleFontSize,
                                  isBold: true,
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(
                                  "Shipping Charges",
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey,
                                ),
                                CustomText(
                                  "Free",
                                  color: Colors.green,
                                  fontSize: subtitleFontSize,
                                  isBold: true,
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                            DashedLine(
                              color: Colors.grey[300],
                            ),
                            verticalSpaceSmall,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomText(
                                  "Total",
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey,
                                ),
                                CustomText(
                                  rupeeUnicode + "270",
                                  fontSize: subtitleFontSize,
                                  isBold: true,
                                ),
                              ],
                            ),
                            verticalSpaceSmall,
                            RaisedButton(
                                elevation: 0,
                                onPressed: () {},
                                color: backgroundWhiteCreamColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side:
                                        BorderSide(color: logoRed, width: 1.5)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    "Cancel Order",
                                    style: TextStyle(color: logoRed),
                                  ),
                                )),
                          ],
                        )

                        // spaceDividerExtraThin,
                        // verticalSpaceTiny,
                      ]),
                )),
              ),
              // ),
              // )
            ));
  }

  Widget orderSummary(
      headingFontSize, titleFontSize, subtitleFontSize, priceFontSize) {
    return Column(
      children: <Widget>[
        CustomText(
          "Order Summary",
          fontSize: headingFontSize,
          isTitle: true,
          isBold: true,
        ),
        verticalSpaceSmall,
        Container(
            child: bottomSheetDetailsTable(headingFontSize, titleFontSize,
                subtitleFontSize, priceFontSize)),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: RaisedButton(
                  onPressed: () {},
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Help",
                    style: TextStyle(color: Colors.white),
                  )),
              // )
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: RaisedButton(
                  onPressed: () {},
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Customer Service ",
                    style: TextStyle(color: Colors.white),
                  )),
              // )
            ),
          ],
        ),
        verticalSpaceMedium,
        Row(
          children: <Widget>[
            Opacity(
                opacity: 0.8,
                child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset("assets/images/DZOR_full_logo.png"))),
            Spacer(),
            CustomText(
              "\"Quote\"",
              fontSize: titleFontSize,
            ),
            horizontalSpaceTiny
          ],
        )
      ],
    );
  }

  Widget bottomSheetDetailsTable(
      headingFontSize, titleFontSize, subtitleFontSize, priceFontSize) {
    return Table(
        children: orderSummaryDetails.keys
            .map((String key) {
              return key == "Total"
                  ? <TableRow>[
                      TableRow(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      style: BorderStyle.solid, width: 0.15),
                                  bottom: BorderSide(
                                      style: BorderStyle.solid, width: 0.15))),
                          children: [
                            CustomText(key,
                                isBold: true, fontSize: titleFontSize),
                            CustomText(orderSummaryDetails[key],
                                fontSize: titleFontSize, isBold: true)
                          ]),
                      TableRow(children: [
                        verticalSpaceTiny,
                        verticalSpaceTiny,
                      ]),
                    ]
                  : <TableRow>[
                      TableRow(children: [
                        CustomText(
                          key,
                          fontSize: titleFontSize,
                        ),
                        CustomText(
                          orderSummaryDetails[key],
                          fontSize: subtitleFontSize,
                        )
                      ]),
                      TableRow(children: [
                        verticalSpaceTiny,
                        verticalSpaceTiny,
                      ]),
                    ];
            })
            .expand((element) => element)
            .toList());
  }
}

/*

***************** GridListView for cart *****************************

    viewModel: CartViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: GridListWidget<Cart, Item>(
            // key: key,
            context: context,
            filter: filter,
            gridCount: 1,
            disablePagination: true,
            viewModel: CartGridViewBuilderViewModel(),
            childAspectRatio: 3,
            tileBuilder: (BuildContext context, data, index) {
              Fimber.d("test");
              print((data as Item).toJson());
              final Item dItem = data as Item;
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("ID : " + dItem.productId.toString()),
                    Text("Name : " + dItem.product.name),
                    Text("Price : " + dItem.product.price.toString()),
                    Text("Qty : " + dItem.quantity.toString()),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Remove Item"),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

*/
