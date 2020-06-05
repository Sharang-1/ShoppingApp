import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/grid_view_builder_filter_models/cartFilter.dart';
import 'package:compound/ui/widgets/CartTileUI.dart';

import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/cart_grid_view_builder_view_model.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/shared_styles.dart';
import '../widgets/custom_stepper.dart';

class CartView extends StatefulWidget {
  CartView({Key key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  CartFilter filter = CartFilter();

  @override
  Widget build(BuildContext context) {
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
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  verticalSpace(20),
                  Text(
                    "Cart",
                    style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                  verticalSpace(10),
                  const CutomStepper(
                    step: 1,
                  ),
                  verticalSpace(20),
                  GridListWidget<Cart, Item>(
                    context: context,
                    filter: filter,
                    gridCount: 1,
                    disablePagination: true,
                    viewModel: CartGridViewBuilderViewModel(),
                    childAspectRatio: 1,
                    tileBuilder: (BuildContext context, data, index, onDelete,
                        onUpdate) {
                      Fimber.d("test");
                      print((data as Item).toJson());
                      final Item dItem = data as Item;

                      return CartTileUI(
                        index: index,
                        item: dItem,
                        onDelete: (int index) async {
                          await onDelete(index);
                        },
                        applyPromoCode: model.applyPromocode,
                        calculateProductPrice: model.calculateProductPrice,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
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
      ),
    );
  }

  Widget bottomSheetDetailsTable(titleFontSize, subtitleFontSize) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: appBarIconColor),
          centerTitle: true,
          title: Text(
            "Details",
            style: TextStyle(color: Colors.black, fontSize: 23),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.clear_circled_solid),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              color: Colors.grey[700],
              iconSize: 30,
            ),
            horizontalSpaceSmall
          ],
          backgroundColor: Colors.grey[300],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 10),
            child: Column(
              children: <Widget>[
                Table(
                    children: orderSummaryDetails1
                        .map((String key) {
                          return <TableRow>[
                            TableRow(children: [
                              CustomText(
                                key,
                                color: Colors.grey,
                                fontSize: titleFontSize,
                              ),
                              CustomText(
                                orderSummaryDetails[key],
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              )
                            ]),
                            TableRow(children: [
                              verticalSpace(8),
                              verticalSpace(8),
                            ]),
                          ];
                        })
                        .expand((element) => element)
                        .toList()),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Divider(),
                ),
                Table(
                    children: orderSummaryDetails2
                        .map((String key) {
                          return <TableRow>[
                            TableRow(children: [
                              CustomText(
                                key,
                                color: Colors.grey,
                                fontSize: titleFontSize,
                              ),
                              CustomText(
                                orderSummaryDetails[key],
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              )
                            ]),
                            TableRow(children: [
                              verticalSpace(8),
                              verticalSpace(8),
                            ]),
                          ];
                        })
                        .expand((element) => element)
                        .toList()),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Divider(),
                ),
                Table(
                  children: orderSummaryDetails3
                      .map(
                        (String key) {
                          return key == "Total"
                              ? <TableRow>[
                                  TableRow(
                                    children: [
                                      verticalSpaceSmall,
                                      verticalSpaceSmall
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Divider(thickness: 1),
                                      Divider(thickness: 1),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpaceSmall,
                                      verticalSpaceSmall
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      CustomText(key,
                                          isBold: true,
                                          color: Colors.grey,
                                          fontSize: titleFontSize),
                                      CustomText(orderSummaryDetails[key],
                                          fontSize: titleFontSize + 2,
                                          color: darkRedSmooth,
                                          isBold: true)
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpace(8),
                                      verticalSpace(8),
                                    ],
                                  ),
                                ]
                              : <TableRow>[
                                  TableRow(
                                    children: [
                                      CustomText(
                                        key,
                                        color: Colors.grey,
                                        fontSize: titleFontSize,
                                      ),
                                      CustomText(
                                        key == "Delivery Charges"
                                            ? orderSummaryDetails[key] == "0.0"
                                                ? "Free Delivery"
                                                : orderSummaryDetails[key]
                                            : orderSummaryDetails[key],
                                        fontSize: subtitleFontSize,
                                        color: key == "Delivery Charges"
                                            ? orderSummaryDetails[key] == "0.0"
                                                ? green
                                                : Colors.black
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpace(8),
                                      verticalSpace(8),
                                    ],
                                  ),
                                ];
                        },
                      )
                      .expand((element) => element)
                      .toList(),
                ),
                verticalSpaceMedium,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        elevation: 5,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectAddress(),
                            ),
                          );
                        },
                        color: green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          // side: BorderSide(
                          //     color: Colors.black, width: 0.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            orderSummaryDetails["Total"] +
                                "\t" +
                                "Proceed to Order ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget productCard(titleFontSize, subtitleFontSize, priceFontSize) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(curve15),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
          child: Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(curve15),
                  child: FadeInImage.assetNetwork(
                    width: 120,
                    fadeInCurve: Curves.easeIn,
                    placeholder: "assets/images/tile_ui_placeholder.jpg",
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
                            dotsAfterOverFlow: true,
                            isTitle: true,
                            isBold: true,
                            fontSize: titleFontSize,
                          ),
                          verticalSpaceTiny,
                          CustomText(
                            "By Nike",
                            color: Colors.grey,
                            dotsAfterOverFlow: true,
                            fontSize: subtitleFontSize - 2,
                          ),
                          verticalSpaceSmall,
                          Row(children: <Widget>[
                            CustomText(orderSummaryDetails["Total"],
                                color: darkRedSmooth,
                                isBold: true,
                                fontSize: priceFontSize),
                            horizontalSpaceTiny,
                            Expanded(
                              child: Text(
                                "\u20B9" + "300",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: priceFontSize - 2),
                              ),
                            )
                          ]),
                          verticalSpaceTiny,
                          CustomText("Qty : 1 Piece",
                              dotsAfterOverFlow: true,
                              color: Colors.grey,
                              fontSize: subtitleFontSize - 2),
                          verticalSpaceTiny,
                          CustomText("Size : S",
                              dotsAfterOverFlow: true,
                              color: Colors.grey,
                              fontSize: subtitleFontSize - 2),
                        ],
                      ))),
              IconButton(
                icon: Icon(
                  !clicked
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    clicked = true;
                  });

                  showModalBottomSheet<void>(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
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





SizedBox(
                    height: 180,
                    child: productCard(
                      titleFontSize,
                      subtitleFontSize,
                      priceFontSize,
                    ),
                  ),
                  verticalSpaceMedium,
                  SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 30,
                              bottom: 10,
                            ),
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5),
                                labelText: '  Promo Code',
                                labelStyle: TextStyle(fontSize: 18),
                                alignLabelWithHint: true,
                                isDense: true,
                              ),
                              autofocus: false,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          heightFactor: 0.7,
                          child: RaisedButton(
                            elevation: 5,
                            onPressed: () {},
                            color: darkRedSmooth,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              // side: BorderSide(
                              //     color: Colors.black, width: 0.5)
                            ),
                            child: Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 0,
                        onPressed: () {},
                        color: backgroundWhiteCreamColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: logoRed, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Remove",
                            style: TextStyle(color: logoRed),
                          ),
                        ),
                      ),
                      horizontalSpaceMedium,
                      Expanded(
                        child: RaisedButton(
                          elevation: 5,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectAddress(),
                              ),
                            );
                          },
                          color: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            // side: BorderSide(
                            //     color: Colors.black, width: 0.5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "Proceed to Order ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

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
