import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/grid_view_builder_filter_models/cartFilter.dart';
import 'package:compound/ui/views/cart_select_delivery_view.dart';

import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/cart_grid_view_builder_view_model.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/dashed_line.dart';

class CartView extends StatefulWidget {
  CartView({Key key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final searchController = TextEditingController();

  final filter = CartFilter();
  bool clicked = false;

  Map<String, String> orderSummaryDetails = {
    "Shipping To": "Ahmedabad",
    "Shipping Address": "ABC appartment,Naranpura-380013",
    "Price": rupeeUnicode + "300",
    "Discount": "30%",
    "Order Total": rupeeUnicode + "270",
    "Delivery Charges": rupeeUnicode + "40",
    "Total": rupeeUnicode + "310"
  };

  TextEditingController _controller = new TextEditingController();

  // Widget CustomText(text,
  //     {bool isBold = false,
  //     double fontsize = 16,
  //     TextStyle textStyle,
  //     Color color = Colors.black}) {
  //   return Text(
  //     text,
  //     style: textStyle != null
  //         ? textStyle
  //         : TextStyle(
  //             fontSize: fontsize,
  //             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
  //             color: color),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double priceFontSize = 14.0;

    double subtitleFontSize = 14;
    double titleFontSize = 16;
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
                  "My Cart",
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {},
                    tooltip: "Clear Cart",
                  )
                ],
              ),
              bottomNavigationBar:
                  //  Material(
                  //     elevation: 15,
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(side: BorderSide(width: 0.05)),
                  //     child:

                  Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectAddress()));
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(
                      //     color: Colors.black, width: 0.5)
                    ),
                    child: Text(
                      "Proceed to Order ",
                      style: TextStyle(color: Colors.white),
                    )),
                // )
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            height: 150,
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: FadeInImage.assetNetwork(
                                            width: 120,
                                            fadeInCurve: Curves.easeIn,
                                            placeholder:
                                                "assets/images/placeholder.png",
                                            image:
                                                "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                            fit: BoxFit.cover,
                                          )),
                                      Expanded(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  verticalSpaceTiny,
                                                  CustomText("Nike T-Shirt",
                                                      isBold: true),
                                                  CustomText(
                                                    "By Nike",
                                                    fontSize:
                                                        subtitleFontSize - 2,
                                                  ),
                                                  Row(children: <Widget>[
                                                    CustomText("Qty: 1",
                                                        fontSize:
                                                            subtitleFontSize),
                                                    horizontalSpaceMedium,
                                                    CustomText("Size: S",
                                                        fontSize:
                                                            subtitleFontSize),
                                                    horizontalSpaceMedium,
                                                    SizedBox(
                                                        height: 25,
                                                        child:
                                                            FloatingActionButton(
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(
                                                            !clicked
                                                                ? Icons
                                                                    .keyboard_arrow_down
                                                                : Icons
                                                                    .keyboard_arrow_up,
                                                            color: Colors.black,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              clicked = true;
                                                            });

                                                            showModalBottomSheet<
                                                                    void>(
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return bottomSheetDetailsTable(
                                                                      titleFontSize,
                                                                      subtitleFontSize);
                                                                }).whenComplete(() {
                                                              setState(() {
                                                                clicked = false;
                                                              });
                                                            });
                                                          },
                                                        ))
                                                  ]),
                                                  verticalSpaceTiny,
                                                  Row(children: <Widget>[
                                                    CustomText(
                                                        rupeeUnicode + '100',
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
                                                  Spacer(),
                                                  SizedBox(
                                                      height: 30,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          // RaisedButton(
                                                          //     padding:
                                                          //         EdgeInsets
                                                          //             .all(
                                                          //                 0),
                                                          //     elevation: 1,
                                                          //     onPressed:
                                                          //         () {},
                                                          //     color: Colors
                                                          //             .grey[
                                                          //         300],
                                                          //     shape:
                                                          //         RoundedRectangleBorder(
                                                          //       borderRadius:
                                                          //           BorderRadius.circular(
                                                          //               10),
                                                          //       // side: BorderSide(
                                                          //       //     color: Colors.black, width: 0.5)
                                                          //     ),
                                                          //     child: Text(
                                                          //       "Update ",
                                                          //       style: TextStyle(
                                                          //           color: Colors
                                                          //               .black),
                                                          //     )),
                                                          // horizontalSpaceTiny,
                                                          RaisedButton(
                                                              elevation: 1,
                                                              onPressed: () {},
                                                              color: Colors.red,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                // side: BorderSide(
                                                                //     color: Colors.black, width: 0.5)
                                                              ),
                                                              child: Text(
                                                                "Delete ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                          horizontalSpaceTiny
                                                        ],
                                                      )),
                                                ],
                                              )))
                                    ],
                                  ),
                                ))),
                        verticalSpaceMedium,
                        SizedBox(
                            height: 40,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        labelText: 'Promo Code',
                                        isDense: true),
                                    autofocus: false,
                                    maxLines: 1,
                                  )),
                                  FractionallySizedBox(
                                      heightFactor: 1,
                                      child: RaisedButton(
                                          elevation: 1,
                                          onPressed: () {},
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // side: BorderSide(
                                            //     color: Colors.black, width: 0.5)
                                          ),
                                          child: Text(
                                            "Apply ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                ])),
                        verticalSpaceMedium,
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(0.05)),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomText(
                                    "Price Details",
                                    isBold: true,
                                    color: Colors.grey,
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CustomText("SubTotal", isBold: true),
                                      CustomText(rupeeUnicode + "100",
                                          isBold: true)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CustomText("Shipping",
                                          fontSize: subtitleFontSize),
                                      CustomText(
                                        "Free",
                                        fontSize: subtitleFontSize,
                                        color: Colors.green,
                                      )
                                    ],
                                  ),
                                  verticalSpaceTiny,
                                  DashedLine(
                                    color: Colors.grey[300],
                                  ),
                                  verticalSpaceTiny,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CustomText("Total", isBold: true),
                                      CustomText(rupeeUnicode + "100",
                                          isBold: true)
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            )),
                      ]),
                )),
              ),
              // ),
              // )
            ));
  }

  Widget bottomSheetDetailsTable(titleFontSize, subtitleFontSize) {
    return FractionallySizedBox(
        heightFactor: 0.5,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              title: Text(
                "Details",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Table(
                      children: orderSummaryDetails.keys
                          .map((String key) {
                            return key == "Total"
                                ? <TableRow>[
                                    TableRow(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    style: BorderStyle.solid,
                                                    width: 0.15),
                                                bottom: BorderSide(
                                                    style: BorderStyle.solid,
                                                    width: 0.15))),
                                        children: [
                                          CustomText(key,
                                              isBold: true,
                                              fontSize: titleFontSize),
                                          CustomText(orderSummaryDetails[key],
                                              fontSize: titleFontSize,
                                              isBold: true)
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
                          .toList())),
            )));
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
