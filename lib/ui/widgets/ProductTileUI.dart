import 'dart:math';

import 'package:compound/models/products.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:compound/utils/tools.dart';
import '../shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    bool isTablet = Tools.checkIfTablet(MediaQuery.of(context));

    double titleFontSize = isTablet ? 18.0 : 14.0;
    double subtitleFontSize = isTablet ? 16.0 : 10.0;
    double priceFontSize = isTablet ? 18.0 : 14.0;
    double ratingCountFontSize = isTablet ? 16.0 : 12.0;
    double wishlistIconSize = isTablet ? 34 : 25;
    // final BlousePadding sellerName=widget.data.whoMadeIt;

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
    final String fontFamily = "Raleway";
    String getTruncatedString(int length, String str) {
      return str.length <= length ? str : '${str.substring(0, length)}...';
    }

    double tagSize = isTablet ? 14.0 : 10.0;

    List<String> tags = [
      "Coats",
      "Trending",
      "211",
      // "212343"
    ];
    // print("Image : ::::::::::::::::::::::::::::::::");
    // print("http://52.66.141.191/api/photos/" + originalName.toString());
    // print("http://52.66.141.191/api/photos/" + name.toString());

    return GestureDetector(
        onTap: widget.onClick,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 6,
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Expanded(
                  flex: 13,
                  child: _imageStackview(originalPhotoName, productDiscount)),
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8.0, 6, 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(getTruncatedString(13, productName),
                                  style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.bold)),
                            ),
                            InkWell(
                              child: this.toggle
                                  ? Icon(
                                      Icons.favorite,
                                      size: wishlistIconSize,
                                      color: darkRedSmooth,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: wishlistIconSize,
                                      color: darkRedSmooth,
                                    ),
                              onTap: () {
                                setState(() {
                                  this.toggle = !this.toggle;
                                });
                              },
                            )
                          ],
                          // )
                        ),
                        Text("By Anita's Creation",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "\u20B9" + '${productPrice.toInt().toString()}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: priceFontSize),
                              ),
                              SizedBox(width: 10,),
                              productDiscount != 0.0
                                  ? Text(
                                      "\u20B9" +
                                          '${productOldPrice.toString()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: priceFontSize),
                                    )
                                  : Container(),
                            ]),
                      ],
                    ),
                  )),
            ]),
          ),
        ));
  }

  Widget _imageStackview(originalPhotoName, discount) {
    return Stack(fit: StackFit.loose, children: <Widget>[
      Positioned.fill(
        child: FractionallySizedBox(
            widthFactor: 1,
            child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                // borderRadius: BorderRadius.circular(5),
                child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.transparent.withOpacity(0.12),
                        BlendMode.srcATop),
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.fill,
                        fadeInCurve: Curves.easeIn,
                        placeholder: 'assets/images/placeholder.png',
                        image: originalPhotoName == null
                            ? 'https://images.pexels.com/photos/157675/fashion-men-s-individuality-black-and-white-157675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                            : originalPhotoName)))),
      ),
      discount != 0.0
          ? Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: darkRedSmooth,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10))),
                width: 40,
                height: 20,
                child: Center(
                  child: Text(
                    discount.round().toString()+"%",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ),
              ))
          : Container()
    ]
        // )

        );
  }
}
