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
    double priceFontSize = 14.0;
    double subtitleFontSize = 16;
    double titleFontSize = 18;
    double headingFontSize = 20;
    return ViewModelProvider<CartViewModel>.withConsumer(
        viewModel: CartViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 3,
                backgroundColor: Colors.white,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  "Order Details",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                top: true,
                left: false,
                right: false,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomText(
                          "Order ID: #3874608",
                          fontSize: headingFontSize,
                          isTitle: true,
                          isBold: true,
                        ),
                        verticalSpaceSmall,
                        SizedBox(
                            height: 150,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 5,
                                child: Padding(
                                    padding: EdgeInsets.all(5),
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
                                                    height: 100,
                                                    fadeInCurve: Curves.easeIn,
                                                    placeholder:
                                                        "assets/images/placeholder.png",
                                                    image:
                                                        "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                                    fit: BoxFit.cover,
                                                  )),
                                              Expanded(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          verticalSpaceTiny,
                                                          CustomText(
                                                              "Nike T-Shirt",
                                                              isBold: true),
                                                          CustomText(
                                                            "By Nike",
                                                            fontSize:
                                                                subtitleFontSize -
                                                                    2,
                                                          ),
                                                          Row(children: <
                                                              Widget>[
                                                            CustomText("Qty: 1",
                                                                fontSize:
                                                                    subtitleFontSize),
                                                            horizontalSpaceMedium,
                                                            CustomText(
                                                                "Size: S",
                                                                fontSize:
                                                                    subtitleFontSize),
                                                            horizontalSpaceMedium,
                                                          ]),
                                                          verticalSpaceTiny,
                                                          Row(children: <
                                                              Widget>[
                                                            CustomText(
                                                                rupeeUnicode +
                                                                    '100',
                                                                isBold: true,
                                                                fontSize:
                                                                    priceFontSize),
                                                            // horizontalSpaceMedium,
                                                            // CustomText(
                                                            //   rupeeUnicode + '200',
                                                            //   textStyle: TextStyle(
                                                            //       color: Colors.grey,
                                                            //       decoration:
                                                            //           TextDecoration
                                                            //               .lineThrough,
                                                            //       fontSize:
                                                            //           priceFontSize),
                                                            // ),
                                                            // horizontalSpaceMedium,
                                                            // CustomText("20% off",
                                                            //     color: Colors.red,
                                                            //     fontSize:
                                                            //         priceFontSize),
                                                          ]),
                                                        ],
                                                      ))),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            CustomText(
                                              "Status: ",
                                              fontSize: subtitleFontSize,
                                            ),
                                            CustomText(
                                              "PLACED",
                                              fontSize: subtitleFontSize,
                                              isBold: true,
                                            )
                                          ],
                                        )
                                      ],
                                    )))),
                        verticalSpaceSmall,
                        spaceDividerExtraThin,
                        verticalSpaceTiny,
                        CustomText(
                          "Delivery Status",
                          fontSize: headingFontSize,
                          isTitle: true,
                          isBold: true,
                        ),
                        verticalSpaceSmall,
                        LinearPercentIndicator(
                          lineHeight: 15.0,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          percent: 0.3,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.green,
                        ),
                        CustomText(
                          "Placed",
                          fontSize: titleFontSize,
                        ),
                        verticalSpaceTiny_0,
                        Row(
                          children: <Widget>[
                            CustomText(
                              "Estimated Delivery:",
                              fontSize: titleFontSize,
                            ),
                            CustomText(
                              "2 June 2020",
                              fontSize: titleFontSize,
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        spaceDividerExtraThin,
                        verticalSpaceTiny,
                        CustomText(
                          "Order Summary",
                          fontSize: headingFontSize,
                          isTitle: true,
                          isBold: true,
                        ),
                        verticalSpaceSmall,
                        Container(
                            child: bottomSheetDetailsTable(
                                headingFontSize,
                                titleFontSize,
                                subtitleFontSize,
                                priceFontSize)),
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
                                    child: Image.asset(
                                        "assets/images/DZOR_full_logo.png"))),
                            Spacer(),
                            CustomText(
                              "\"Quote\"",
                              fontSize: titleFontSize,
                            ),
                            horizontalSpaceTiny
                          ],
                        )
                      ]),
                )),
              ),
              // ),
              // )
            ));
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
