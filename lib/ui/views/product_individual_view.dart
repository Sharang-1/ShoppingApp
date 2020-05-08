import 'dart:convert';

import 'package:compound/locator.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:compound/ui/widgets/reviews.dart';
import 'package:compound/viewmodels/product_individual_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import '../shared/app_colors.dart';
import '../views/home_view_slider.dart';
import '../widgets/cart_icon_badge.dart';
import '../shared/shared_styles.dart';

class ProductIndiView extends StatefulWidget {
  final Product data;
  const ProductIndiView({Key key, @required this.data}) : super(key: key);
  @override
  _ProductIndiViewState createState() => _ProductIndiViewState();
}

class _ProductIndiViewState extends State<ProductIndiView> {
  int selectedQty = 0;
  int selectedIndex = -1;
  String selectedSize = "";
  String selectedColor = "";
  String getTruncatedString(int length, String str) {
    return str.length <= length ? str : '${str.substring(0, length)}...';
  }

  Widget productNameAndDescInfo(productName, variations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          productName,
          // overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            fontFamily: headingFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          "By Anita's Creation",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget priceInfo(productPrice, productDiscount) {
    return Row(
      children: <Widget>[
        Text(
          '\u20B9${productPrice.toString()}',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        productDiscount == 0.0
            ? Container()
            : Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Text(
                    '${(productPrice / (1 - (productDiscount / 100))).toString()}',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${productDiscount.toString()}% off',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ],
    );
  }

  List<Widget> choiceChips(variations) {
    List<Widget> allChips = [];
    // List jsonParsed = json.decode(variations.toString());
    for (int i = 0; i < variations.length; i++) {
      allChips.add(ChoiceChip(
        backgroundColor: Colors.white,
        selectedShadowColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: selectedSize == variations[i]["size"]
                  ? darkRedSmooth
                  : Colors.grey,
              width: 0.5,
            )),
        labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: selectedSize == variations[i]["size"]
                ? FontWeight.w600
                : FontWeight.normal,
            color: selectedSize == variations[i]["size"]
                ? darkRedSmooth
                : Colors.grey),
        selectedColor: Colors.white,
        label: Text(variations[i]["size"]),
        selected: selectedSize == variations[i]["size"],
        onSelected: (val) {
          setState(
              () => {selectedSize = variations[i]["size"], selectedIndex = i});
        },
      ));
    }

    return allChips;
  }

  Wrap allSizes(variations) {
    return Wrap(
      spacing: 8,
      children: choiceChips(variations),
    );
  }

  Wrap allColors(colors) {
    List<Widget> allColorChips = [];
    for (String color in colors) {
      allColorChips.add(ChoiceChip(
        backgroundColor: Colors.white,
        selectedShadowColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: selectedColor == color ? darkRedSmooth : Colors.grey,
              width: 0.5,
            )),
        labelStyle: TextStyle(
            fontSize: 14,
            fontWeight:
                selectedColor == color ? FontWeight.w600 : FontWeight.normal,
            color: selectedColor == color ? darkRedSmooth : Colors.grey),
        selectedColor: Colors.white,
        label: Text(color),
        selected: selectedColor == color,
        onSelected: (val) {
          setState(() => {selectedColor = color});
        },
      ));
    }
    return Wrap(
      spacing: 8,
      children: allColorChips,
    );
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget allTags(tags) {
    var alltags = "";
    for (var item in tags) {
      alltags += "#" + item + "  ";
    }
    return Text(
      alltags,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget rattingsInfo() {
    return Row(
      children: <Widget>[
        Container(
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.lightGreen,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: <Widget>[
                Text(
                  "3.5",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.star,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "1050 ratings",
          style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
        )
      ],
    );
  }

  Widget paddingWidget(Widget item) {
    return Padding(child: item, padding: EdgeInsets.fromLTRB(0, 10, 0, 0));
  }

  Widget tableLeftText(String item) {
    return paddingWidget(Text(
      item,
      style: TextStyle(color: Colors.grey, fontSize: 15),
    ));
  }

  Widget tableRightText(String item) {
    return paddingWidget(Text(
      item,
      style: TextStyle(fontSize: 15),
    ));
  }

  Widget otherDetails() {
    return Column(
      children: <Widget>[
        Table(
          children: [
            TableRow(children: [
              Text(
                "Product Details",
                style: TextStyle(fontSize: 17),
              ),
              tableRightText(""),
            ]),
            TableRow(children: [
              tableLeftText("color"),
              tableRightText("grey"),
            ]),
            TableRow(children: [
              tableLeftText("Sizes"),
              tableRightText("X M L"),
            ]),
            TableRow(children: [
              tableLeftText("Stiches"),
              tableRightText("multitype"),
            ]),
          ],
        )
      ],
    );
  }

  Widget bottomBar(ProductIndividualViewModel model) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: Center(
              child: Text(
            "ADD TO WISHLIST ",
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          )),
        ),
        GestureDetector(
          onTap: () {
            model.addToCart(widget.data, 1, "1");
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            color: lightGrey,
            child: Center(
                child: Text(
              "ADD TO CART ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            )),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String originalPhotoName =
        'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80';
    final String productName = widget.data.name ?? "Iphone 11";
    final String productId = widget.data.key;
    final double productDiscount = widget.data.discount ?? 0.0;
    final double productPrice = widget.data.price ?? 0.0;
    final double productOldPrice = widget.data.oldPrice ?? 0.0;
    final productRatingObj = widget.data.rating ?? null;

    final String shipment = widget.data.shipment.days == null
        ? "Not Availabel"
        : widget.data.shipment.days.toString() +
            (widget.data.shipment.days == 1 ? " Day" : " Days");
    final variations = [
      {
        "size": "X",
        "maxQty": 3,
        "color": ["Blue", "Orange"]
      },
      {
        "size": "XL",
        "maxQty": 5,
        "color": ["Red", "Orange"]
      },
      {
        "size": "XXL",
        "maxQty": 1,
        "color": ["Black", "Orange"]
      },
    ];

    final tags = [
      "JustHere",
      "Trending",
    ];
    final bool available = widget.data.available ?? false;

    return ViewModelProvider<ProductIndividualViewModel>.withConsumer(
      viewModel: ProductIndividualViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundWhiteCreamColor,
          iconTheme: IconThemeData(color: textIconBlue),
          title: Center(
              child: Image.asset(
            "assets/images/logo_red.png",
            height: 40,
            width: 40,
          )),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: CartIconWithBadge(
                IconColor: textIconBlue,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  productNameAndDescInfo(productName, widget.data.variations),
                  SizedBox(
                    height: 15,
                  ),
                  Stack(children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: HomeSlider())),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white.withOpacity(1)),
                        child: Icon(
                          Icons.favorite_border,
                          color: darkRedSmooth,
                          size: 30,
                        ),
                      ),
                    )
                  ]),
                  verticalSpace(20),
                  Row(
                    children: <Widget>[
                      Expanded(child: priceInfo(productPrice, productDiscount)),
                      SvgPicture.asset(
                        "assets/icons/share.svg",
                        width: 30,
                        height: 30,
                        color: textIconBlue,
                      )
                    ],
                  ),
                  tags.length == 0
                      ? Container()
                      : Column(
                          children: <Widget>[
                            verticalSpace(10),
                            allTags(tags),
                          ],
                        ),
                  verticalSpace(20),
                  available
                      ? Text(
                          "In Stock",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        )
                      : Text("Out Of Stock",
                          style: TextStyle(
                              fontSize: 20,
                              color: logoRed,
                              fontWeight: FontWeight.w600)),

                  verticalSpace(20),
                  Row(
                    children: <Widget>[
                      Text(
                        "Delivery In :",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      horizontalSpaceSmall,
                      Text(
                        shipment,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(5),
                  Row(
                    children: <Widget>[
                      Text(
                        "Delivery To :",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      horizontalSpaceSmall,
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.add),
                            horizontalSpaceSmall,
                            Text("Add Address")
                          ],
                        ),
                      )
                      // Expanded(
                      //     child: Text(
                      //   "Add ur address here",
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //   ),
                      // )),
                    ],
                  ),
                  verticalSpace(20),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Select Size",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Text(
                                  "size chart",
                                  style: TextStyle(
                                      color: Colors.blue[600], fontSize: 15),
                                )
                              ],
                            ),
                            verticalSpace(5),
                            allSizes(variations),
                            verticalSpace(10),
                            selectedIndex == -1
                                ? Container()
                                : Row(
                                    children: <Widget>[
                                      Text(
                                        "Select Qty",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      horizontalSpaceMedium,
                                      Container(
                                        height: 40,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: darkRedSmooth),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              color: selectedQty == 0
                                                  ? Colors.grey
                                                  : darkRedSmooth,
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                if (selectedQty != 0) {
                                                  setState(() {
                                                    selectedQty =
                                                        selectedQty - 1;
                                                  });
                                                }
                                              },
                                            ),
                                            Text(
                                              selectedQty.toString(),
                                              style: TextStyle(
                                                  color: darkRedSmooth,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              color: variations[selectedIndex]
                                                          ["maxQty"] ==
                                                      selectedQty
                                                  ? Colors.grey
                                                  : darkRedSmooth,
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                if (variations[selectedIndex]
                                                        ["maxQty"] !=
                                                    selectedQty) {
                                                  setState(() {
                                                    selectedQty =
                                                        selectedQty + 1;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            selectedIndex == -1
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      verticalSpace(20),
                                      Text(
                                        "Select Color",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      verticalSpace(5),
                                      allColors(
                                          variations[selectedIndex]["color"]),
                                    ],
                                  ),
                          ],
                        ),
                      )),
                  verticalSpace(30),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: textIconOrange,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            "BUY NOW",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        model.addToCart(widget.data, selectedQty, selectedSize);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: logoRed,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            "ADD TO CART",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpace(40),
                  Text(
                    "   Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  verticalSpace(5),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          widget.data.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        )),
                  ),
                  verticalSpace(40),
                  Text(
                    "   Sold By",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  verticalSpace(5),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Pooja Creations",
                              style:
                                  TextStyle(fontSize: 18, color: darkRedSmooth),
                            ),
                            verticalSpace(10),
                            Center(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.5),
                                        height: 1))),
                            verticalSpace(10),
                            Text(
                              getTruncatedString(100, widget.data.description),
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            )
                          ],
                        )),
                  ),
                  verticalSpace(40),
                  // bottomTag()
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // rattingsInfo(),
                  // SizedBox(
                  //   height: 40,
                  // ),
                  // otherDetails(),
                  // verticalSpaceMedium,
                  // ReviewWidget(productId),
                  // verticalSpaceMedium,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class bottomTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
        height: 100,
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          decoration: BoxDecoration(
              color: backgroundWhiteCreamColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
        ),
      )
    ]);
  }
}
