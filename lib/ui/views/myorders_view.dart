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
import './myorders_details_view.dart';

class MyOrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double priceFontSize = 14.0;
    double subtitleFontSize = 16;
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
                  "My Orders",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                                              IconButton(
                                                icon: Icon(
                                                    Icons.arrow_forward_ios),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyOrdersDetailsView()));
                                                },
                                              )
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
                        verticalSpaceMedium,
                      ]),
                )),
              ),
              // ),
              // )
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
