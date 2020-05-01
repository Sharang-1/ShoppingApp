import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/grid_view_builder_filter_models/cartFilter.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/cart_grid_view_builder_view_model.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CartView extends StatefulWidget {
  CartView({Key key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final searchController = TextEditingController();

  final filter = CartFilter();
  bool clicked = false;
  final _formkey = GlobalKey<FormState>();

  TextEditingController _controller = new TextEditingController();

  Widget _customText(text,
      {bool isBold = false,
      double fontsize = 16,
      TextStyle textStyle,
      Color color = Colors.black}) {
    return Text(
      text,
      style: textStyle != null
          ? textStyle
          : TextStyle(
              fontSize: fontsize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    double priceFontSize = 14.0;
    double subtitleFontSize = 14;
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
              bottomNavigationBar: Material(
                  elevation: 15,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 0.05)),
                  child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Total: " + rupeeUnicode + "100",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          RaisedButton(
                              onPressed: () {},
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
                        ],
                      ))),
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
                              child: Row(
                                children: <Widget>[
                                  // Row(
                                  //   children: <Widget>[
                                  // IconButton(
                                  //     alignment: Alignment.center,
                                  //     padding: EdgeInsets.all(0),
                                  //     icon: Icon(
                                  //         Icons.remove_circle_outline),
                                  //     onPressed: () {}),
                                  // Card(
                                  //         clipBehavior: Clip.antiAlias,
                                  //         child:
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: FadeInImage.assetNetwork(
                                        width: 120,
                                        fadeInCurve: Curves.easeIn,
                                        placeholder:
                                            "assets/images/placeholder.png",
                                        image:
                                            "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                        fit: BoxFit.fill,
                                      )),

                                  Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              verticalSpaceTiny,
                                              _customText("Nike T-Shirt",
                                                  isBold: true),
                                              _customText(
                                                "By Nike",
                                                fontsize: subtitleFontSize - 2,
                                              ),
                                              Row(children: <Widget>[
                                                _customText("Qty: 1",
                                                    fontsize: subtitleFontSize),
                                                horizontalSpaceMedium,
                                                _customText("Size: S",
                                                    fontsize: subtitleFontSize),
                                                horizontalSpaceMedium,
                                                SizedBox(
                                                    height: 25,
                                                    child: FloatingActionButton(
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
                                                            context: context,
                                                            builder: (context) {
                                                              return FractionallySizedBox(
                                                                  heightFactor:
                                                                      0.5,
                                                                  child: Scaffold(
                                                                      appBar: AppBar(
                                                                        iconTheme:
                                                                            IconThemeData(color: Colors.black),
                                                                        centerTitle:
                                                                            true,
                                                                        title:
                                                                            Text(
                                                                          "Details",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                      ),
                                                                      body: SingleChildScrollView(
                                                                        child: Padding(
                                                                            padding: EdgeInsets.all(10),
                                                                            child: Table(
                                                                              children: [
                                                                                TableRow(children: [
                                                                                  TableCell(child: _customText("Shipping To:")),
                                                                                  _customText("Ahmedabad")
                                                                                ]),
                                                                                TableRow(children: [
                                                                                  _customText("Shipping Address:"),
                                                                                  _customText("ABC apartment,Naranpura,Ahmedabad-380013")
                                                                                ]),
                                                                                TableRow(children: [
                                                                                  _customText("Price:"),
                                                                                  _customText(rupeeUnicode + "300")
                                                                                ]),
                                                                                TableRow(children: [
                                                                                  _customText("Discount:"),
                                                                                  _customText("30%")
                                                                                ]),
                                                                                TableRow(children: [
                                                                                  _customText("Order Total:"),
                                                                                  _customText(rupeeUnicode + "270")
                                                                                ]),
                                                                                TableRow(children: [
                                                                                  _customText("Delivery Charges:"),
                                                                                  _customText(rupeeUnicode + "40")
                                                                                ]),
                                                                                TableRow(decoration: BoxDecoration(border: Border(top: BorderSide(style: BorderStyle.solid), bottom: BorderSide(style: BorderStyle.solid))), children: [
                                                                                  _customText("Total", isBold: true),
                                                                                  _customText(rupeeUnicode + "310", isBold: true)
                                                                                ]),
                                                                              ],
                                                                            )),
                                                                      )));
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
                                                _customText(
                                                    rupeeUnicode + '100',
                                                    isBold: true,
                                                    fontsize: priceFontSize),
                                                horizontalSpaceMedium,
                                                _customText(
                                                  rupeeUnicode + '200',
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: priceFontSize),
                                                ),
                                                horizontalSpaceMedium,
                                                _customText("20% off",
                                                    color: Colors.red,
                                                    fontsize: priceFontSize),
                                              ]),
                                              Spacer(),
                                              SizedBox(
                                                  height: 30,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 2),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          RaisedButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                              elevation: 1,
                                                              onPressed: () {},
                                                              color: Colors
                                                                  .grey[300],
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
                                                                "Update ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                          horizontalSpaceTiny,
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
                                                      ))),
                                            ],
                                          )))
                                ],
                              ),
                            )),
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
                                ]))
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
