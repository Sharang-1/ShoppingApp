import 'dart:math';

import 'package:compound/models/products.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';

class ProductTileUI extends StatefulWidget {
  final Product data;
  final Function onClick;

  const ProductTileUI({
    Key key,
    this.data,
    this.onClick,
  }) : super(key: key);

  @override
  _ProductTileUIState createState() => _ProductTileUIState();
}

class _ProductTileUIState extends State<ProductTileUI> {
  bool toggle = false;
  bool checkIfTablet(MediaQueryData query) {
    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = checkIfTablet(MediaQuery.of(context));

    double titleFontSize = isTablet ? 18.0 : 14.0;
    double priceFontSize = isTablet ? 16.0 : 12.0;
    double ratingCountFontSize = isTablet ? 16.0 : 12.0;
    double wishlistIconSize = isTablet ? 34 : 22;
    double wishListPadding = isTablet ? 15 : 5;

    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String originalPhotoName =
        photos != null ? photos[0].originalName ?? null : null;
    final String productName = widget.data.name ?? "No name";
    final double productDiscount = widget.data.discount ?? 0.0;
    final double productPrice = widget.data.price ?? 0.0;
    final double productOldPrice = widget.data.oldPrice ?? 0.0;
    final productRatingObj = widget.data.rating ?? null;
    final productRatingValue =
        productRatingObj != null ? productRatingObj.rate : 0.0;
    String getTruncatedString(int length, String str) {
      return str.length <= length ? str : '${str.substring(0, length)}...';
    }

    // print("Image : ::::::::::::::::::::::::::::::::");
    // print("http://52.66.141.191/api/photos/" + originalName.toString());
    // print("http://52.66.141.191/api/photos/" + name.toString());

    return GestureDetector(
        onTap: widget.onClick,
        child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      flex: 5,
                      child: Stack(children: <Widget>[
                        Positioned.fill(
                            child: FractionallySizedBox(
                                widthFactor: 1,
                                child: ClipRRect(
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadius.circular(5),
                                    // child: ColorFiltered(
                                    //     colorFilter: ColorFilter.mode(
                                    //         Colors.transparent
                                    //             .withOpacity(0.12),
                                    //         BlendMode.srcATop),
                                    child: FadeInImage.assetNetwork(
                                        fit: BoxFit.fill,
                                        fadeInCurve: Curves.easeIn,
                                        placeholder:
                                            'assets/images/placeholder.png',
                                        image: originalPhotoName == null
                                            ? 'https://images.pexels.com/photos/157675/fashion-men-s-individuality-black-and-white-157675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                                            : originalPhotoName)))),
                        // ),
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              iconSize: wishlistIconSize,
                              // padding: EdgeInsets.all(2),
                              icon: this.toggle
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                setState(() {
                                  this.toggle = !this.toggle;
                                });
                              },
                            ))
                      ])),
                  Flexible(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text(getTruncatedString(18, productName),
                                style: TextStyle(fontSize: titleFontSize)),
                          ))),
                  Flexible(
                    flex: 1,
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Text(
                                "\u20B9" + '${productPrice.toInt().toString()}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: priceFontSize),
                              )),
                          // SizedBox(
                          //   width: 4,
                          // ),
                          Expanded(
                              flex: 1,
                              child: productOldPrice == 0
                                  ? Container()
                                  : Text(
                                      "\u20B9" +
                                          '${productOldPrice.toString()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: priceFontSize),
                                    )),
                          // SizedBox(
                          //   width: 4,
                          // ),
                          Expanded(
                              flex: 1,
                              child: productDiscount == 0
                                  ? Container()
                                  : Text(
                                      '${productDiscount.toString()}% off',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: priceFontSize - 2),
                                    )),
                        ])),
                  ),
                  Flexible(
                      flex: 1,
                      // child: FractionallySizedBox(
                      // size: Size(50, 30), // button width and height

                      // widthFactor: 0.25,
                      // heightFactor: 0.45,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            color: Colors.green[900], // button color
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 3),
                                    child: Text(
                                        '${productRatingValue.toString()}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ratingCountFontSize,
                                            fontWeight: FontWeight.w400))),
                                Padding(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: ratingCountFontSize - 2,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        // ),
                      )),
                  // Flexible(flex: 1, child: SizedBox())
                ]

                // )
                // )
                // ]

                )));
  }
}
