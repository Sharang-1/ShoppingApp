import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CartView extends StatelessWidget {
  final searchController = TextEditingController();

  CartView({Key key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    double priceFontSize = 14.0;
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
                            "\u20B9100",
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
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(0),
                                              icon: Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {}),
                                          Column(
                                            children: <Widget>[
                                              Expanded(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                width: 100,
                                                fadeInCurve: Curves.easeIn,
                                                placeholder:
                                                    "assets/images/placeholder.png",
                                                image:
                                                    "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                                fit: BoxFit.fill,
                                              )),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text("Qty:1"))
                                            ],
                                          )
                                        ],
                                      ),
                                      Expanded(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Nike T-Shirt",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text("Size: S"),
                                                  Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          "\u20B9" + '100',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  priceFontSize),
                                                        ),
                                                        horizontalSpaceSmall,
                                                        Text(
                                                          "\u20B9" + '200',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontSize:
                                                                  priceFontSize),
                                                        ),
                                                        horizontalSpaceSmall,
                                                        Text(
                                                          "20% off",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize:
                                                                  priceFontSize),
                                                        ),
                                                      ]),
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
                                        labelText: 'Coupon Code',
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
