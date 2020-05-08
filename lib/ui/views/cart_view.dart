import 'package:compound/ui/shared/app_colors.dart';
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
  static double price = 300, discount = 30, deliveryCharges = 0;
  static double discountedPrice = price - (price * discount / 100);

  Map<String, String> orderSummaryDetails = {
    "Product Name": "Nike T-Shirt",
    "Seller": "Nike",
    "Qty": "1",
    "Size": "S",
    "Shipping To": "Ahmedabad",
    "Shipping Address": "ABC appartment,Naranpura-380013",
    "Price": rupeeUnicode + price.toString(),
    "Discount": discount.toString() + "%",
    "Order Total": rupeeUnicode + discountedPrice.toString(),
    "Delivery Charges": deliveryCharges.toString(),
    "Total": rupeeUnicode + (discountedPrice + deliveryCharges).toString()
  };

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double priceFontSize = 16.0;

    double subtitleFontSize = 18;
    double titleFontSize = 20;
    return ViewModelProvider<CartViewModel>.withConsumer(
        viewModel: CartViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backgroundWhiteCreamColor,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  "My Cart",
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Tab(
                        icon: Image.asset(
                      "assets/images/logo_red.png",
                      height: 35,
                      width: 35,
                    )),
                  )
                ],
              ),
              backgroundColor: backgroundWhiteCreamColor,
              body: SafeArea(
                top: true,
                left: false,
                right: false,
                child: SingleChildScrollView(
                    child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            height: 150,
                            child: productCard(titleFontSize, subtitleFontSize,
                                priceFontSize)),
                        verticalSpaceTiny,
                        SizedBox(
                            height: 50,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 40, bottom: 10),
                                          child: TextField(
                                            controller: _controller,
                                            decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 5),
                                                labelText: 'Promo Code',
                                                labelStyle:
                                                    TextStyle(fontSize: 18),
                                                alignLabelWithHint: true,
                                                isDense: true),
                                            autofocus: false,
                                            maxLines: 1,
                                          ))),
                                  FractionallySizedBox(
                                      heightFactor: 0.7,
                                      child: RaisedButton(
                                          elevation: 1,
                                          onPressed: () {},
                                          color: darkRedSmooth,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // side: BorderSide(
                                            //     color: Colors.black, width: 0.5)
                                          ),
                                          child: Text(
                                            "Apply ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                ])),
                        verticalSpaceTiny,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                                elevation: 1,
                                onPressed: () {},
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(
                                  //     color: Colors.black, width: 0.5)
                                ),
                                child: Text(
                                  "Remove ",
                                  style: TextStyle(color: Colors.red),
                                )),
                            horizontalSpaceSmall,
                            Expanded(
                                child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectAddress()));
                                    },
                                    color: Colors.green[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      // side: BorderSide(
                                      //     color: Colors.black, width: 0.5)
                                    ),
                                    child: Text(
                                      "Proceed to Order ",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          ],
                        ),
                      ]),
                )),
              ),
              // ),
              // )
            ));
  }

  Widget priceDetailsContainer(subtitleFontSize) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.05)),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomText("SubTotal", isBold: true),
                  CustomText(orderSummaryDetails["Order Total"], isBold: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomText("Shipping", fontSize: subtitleFontSize),
                  CustomText(
                    deliveryCharges == 0
                        ? "Free"
                        : orderSummaryDetails["Delivery Charges"],
                    fontSize: subtitleFontSize,
                    color: deliveryCharges == 0 ? Colors.green : Colors.black,
                  )
                ],
              ),
              verticalSpaceTiny,
              DashedLine(
                color: Colors.grey[300],
              ),
              verticalSpaceTiny,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomText("Total", isBold: true),
                  CustomText(orderSummaryDetails["Total"], isBold: true)
                ],
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ));
  }

  Widget bottomSheetDetailsTable(titleFontSize, subtitleFontSize) {
    return FractionallySizedBox(
        heightFactor: 0.75,
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              title: Text(
                "Details",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: backgroundWhiteCreamColor,
            ),
            backgroundColor: backgroundWhiteCreamColor,
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Table(
                          children: orderSummaryDetails.keys
                              .map((String key) {
                                return key == "Total"
                                    ? <TableRow>[
                                        TableRow(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 0.15),
                                                    bottom: BorderSide(
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 0.15))),
                                            children: [
                                              CustomText(key + ":",
                                                  isBold: true,
                                                  fontSize: titleFontSize),
                                              CustomText(
                                                  orderSummaryDetails[key],
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
                                            key + ":",
                                            fontSize: titleFontSize,
                                          ),
                                          CustomText(
                                            key == "Delivery Charges"
                                                ? orderSummaryDetails[key] ==
                                                        "0.0"
                                                    ? "Free"
                                                    : orderSummaryDetails[key]
                                                : orderSummaryDetails[key],
                                            fontSize: subtitleFontSize,
                                            color: key == "Delivery Charges"
                                                ? orderSummaryDetails[key] ==
                                                        "0.0"
                                                    ? Colors.green
                                                    : Colors.black
                                                : Colors.black,
                                          )
                                        ]),
                                        TableRow(children: [
                                          verticalSpaceTiny,
                                          verticalSpaceTiny,
                                        ]),
                                      ];
                              })
                              .expand((element) => element)
                              .toList()),
                      verticalSpaceSmall,
                      Row(children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectAddress()));
                                },
                                color: Colors.green[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(
                                  //     color: Colors.black, width: 0.5)
                                ),
                                child: Text(
                                  orderSummaryDetails["Total"] +
                                      "\t" +
                                      "Proceed to Order ",
                                  style: TextStyle(color: Colors.white),
                                )))
                      ])
                    ],
                  )),
            )));
  }

  Widget productCard(titleFontSize, subtitleFontSize, priceFontSize) {
    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    width: 120,
                    fadeInCurve: Curves.easeIn,
                    placeholder: "assets/images/placeholder.png",
                    image:
                        "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                    fit: BoxFit.cover,
                  )),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          verticalSpaceTiny,
                          CustomText(
                            "Nike T-Shirt",
                            isBold: true,
                            fontSize: titleFontSize,
                          ),
                          CustomText(
                            "By Nike",
                            fontSize: subtitleFontSize - 2,
                          ),
                          Row(children: <Widget>[
                            CustomText("Qty: 1", fontSize: subtitleFontSize),
                            horizontalSpaceMedium,
                            CustomText("Size: S", fontSize: subtitleFontSize),
                          ]),
                          verticalSpaceTiny,
                          Row(children: <Widget>[
                            CustomText(orderSummaryDetails["Total"],
                                isBold: true, fontSize: priceFontSize),
                          ]),
                        ],
                      ))),
              IconButton(
                icon: Icon(
                  !clicked
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    clicked = true;
                  });

                  showModalBottomSheet<void>(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return bottomSheetDetailsTable(
                            titleFontSize, subtitleFontSize);
                      }).whenComplete(() {
                    setState(() {
                      clicked = false;
                    });
                  });
                },
              )
            ],
          ),
        ));
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
