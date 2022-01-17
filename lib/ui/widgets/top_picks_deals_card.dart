import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/server_urls.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class TopPicksAndDealsCard extends StatelessWidget {
  final Map<String, dynamic> data;

  TopPicksAndDealsCard({
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(curve15),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Stack(children: <Widget>[
                        Opacity(
                          opacity: (data["isDiscountAvailable"] != null &&
                                      data["isDiscountAvailable"] == "true") ||
                                  (data["isExclusive"] != null &&
                                      data["isExclusive"] == "true")
                              ? 1
                              : 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(curve15),
                            child: data["isExclusive"] != null &&
                                    data["isExclusive"] == "true"
                                ? imageWithTag()
                                : FadeInImage.assetNetwork(
                                    width: 500,
                                    height: 500,
                                    fadeInCurve: Curves.easeIn,
                                    placeholder:
                                        "assets/images/product_preloading.png",
                                    image: data['key'] != null &&
                                            data['photo'] != null
                                        ? '$PRODUCT_PHOTO_BASE_URL/${data["key"]}/${data["photo"]}-small.png'
                                        : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/images/product_preloading.png",
                                      width: 500,
                                      height: 500,
                                      fit: BoxFit.cover,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (data["isDiscountAvailable"] != null &&
                            data["isDiscountAvailable"] == "true")
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: logoRed,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              width: 40,
                              height: 20,
                              child: Center(
                                child: Text(
                                  "${data['discount'].toInt().toString()} %",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: priceFontSize - 4),
                                ),
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              capitalizeString(data['name'] ?? ''),
                              dotsAfterOverFlow: true,
                              isTitle: true,
                              isBold: true,
                              color: Colors.grey[800]!,
                              fontSize: subtitleFontSizeStyle - 2,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: CustomText(
                                    'By ${data['sellerName']}',
                                    color: Colors.grey,
                                    dotsAfterOverFlow: true,
                                    fontSize: subtitleFontSizeStyle - 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: CustomText(
                                      rupeeUnicode + data['price'].toString(),
                                      color: textIconBlue,
                                      isBold: true,
                                      fontSize: subtitleFontSizeStyle - 2),
                                ),
                                horizontalSpaceTiny,
                                data["isDiscountAvailable"] != null &&
                                        data["isDiscountAvailable"] == "true"
                                    ? Text(
                                        "\u20B9" +
                                            data["actualCost"].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: subtitleFontSizeStyle - 4,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            data["isSameDayDelivery"] != null &&
                    data["isSameDayDelivery"] == "true"
                ? Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomText(
                            "Same Day Delivery",
                            isBold: true,
                            fontSize: subtitleFontSizeStyle - 4,
                            color: textIconOrange,
                          )
                        ],
                      )
                    ],
                  )
                : verticalSpace(8)
          ],
        ),
      ),
    );
  }

  Widget svgDiscount() {
    return Stack(children: [
      Positioned(
        top: 5,
        left: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(curve30),
          ),
          height: 15,
          width: 15,
        ),
      ),
      SvgPicture.asset(
        "assets/svg/discount.svg",
        color: logoRed,
        height: 25,
        width: 25,
      ),
    ]);
  }

  Widget imageWithTag() {
    return Container(
      width: 100,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            right: 5,
            top: 0,
            bottom: 0,
            child: FadeInImage.assetNetwork(
              width: 90,
              fadeInCurve: Curves.easeIn,
              placeholder: "assets/images/product_preloading.png",
              image:
                  "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/product_preloading.png",
                width: 90,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 8,
            child: Container(
              height: 18,
              color: logoRed,
              child: Center(
                child: CustomText(
                  "Exclusive",
                  color: Colors.white,
                  isBold: true,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            top: 18,
            right: -5,
            child: Transform.rotate(
              angle: 0,
              child: Icon(
                Icons.play_arrow,
                size: 15,
                color: logoRed,
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: -5,
            child: Transform.rotate(
              angle: 45,
              child: Icon(
                Icons.play_arrow,
                size: 15,
                color: logoRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Divider(
        thickness: 1,
        color: Colors.grey[400]!.withOpacity(0.1),
      ),
    );
  }
}
