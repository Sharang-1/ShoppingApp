import 'dart:math';

import 'package:compound/models/products.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:compound/utils/tools.dart';
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
    double subtitleFontSize = isTablet ? 16.0 : 12.0;
    double priceFontSize = isTablet ? 18.0 : 14.0;
    double ratingCountFontSize = isTablet ? 16.0 : 12.0;
    double wishlistIconSize = isTablet ? 34 : 22;
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
        child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Expanded(flex: 12, child: _imageStackview(originalPhotoName)),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(getTruncatedString(15, productName),
                                    style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.bold)),
                              )),
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                child: this.toggle
                                    ? Icon(
                                        Icons.favorite,
                                        size: wishlistIconSize,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: wishlistIconSize,
                                        color: Colors.black,
                                      ),
                                onTap: () {
                                  setState(() {
                                    this.toggle = !this.toggle;
                                  });
                                },
                              ))
                        ],
                        // )
                      ))),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(top: 2, left: 5),
                      child: Text("By Nike",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: subtitleFontSize,
                              color: Colors.grey)))),
              Expanded(
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: priceFontSize),
                            )),
                        Expanded(
                            flex: 1,
                            child:
                                // productOldPrice == 0
                                //     ? Container()
                                //     :
                                Text(
                              "\u20B9" + '${productOldPrice.toString()}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: priceFontSize),
                            )),
                        Expanded(
                            flex: 1,
                            child:
                                // productDiscount == 0
                                //     ? Container()
                                //     :

                                Text('${productDiscount.toString()}% off',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: priceFontSize - 2,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ))),
                      ]))),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2, left: 5, right: 5),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        color: Colors.green[900], // button color
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Text('${productRatingValue.toString()}',
                                    style: TextStyle(
                                        fontFamily: fontFamily,
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
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {},
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 1),
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(5, 5)),
                                              color: Colors.grey,
                                            ),
                                            child: Center(
                                              child: Text(
                                                tags[index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: tagSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )));
                                })),
                      ])))
            ])));
  }

  Widget _imageStackview(originalPhotoName) {
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
      Align(
          alignment: Alignment.topRight,
          child: SizedBox(
              height: 30,
              width: 30,
              child: SvgPicture.asset(
                "assets//images/coupon_1.svg",
              )))
    ]
        // )

        );
  }
}
