import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class TopPicksAndDealsCard extends StatelessWidget {
  final Map<String, dynamic> data;

  TopPicksAndDealsCard({
    this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(curve15),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(children: <Widget>[
                  Opacity(
                      opacity: (data["isDiscountAvailable"] != null &&
                                  data["isDiscountAvailable"] == "true") ||
                              (data["isExclusive"] != null &&
                                  data["isExclusive"] == "true")
                          ? 0.7
                          : 1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(curve15),
                          child: FadeInImage.assetNetwork(
                            width: 100,
                            fadeInCurve: Curves.easeIn,
                            placeholder: "assets/images/placeholder.png",
                            image:
                                "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.cover,
                          ))),
                  (data["isDiscountAvailable"] != null &&
                              data["isDiscountAvailable"] == "true") ||
                          (data["isExclusive"] != null &&
                              data["isExclusive"] == "true")
                      ? Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: logoRed,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10))),
                            width: 50,
                            height: 20,
                            child: Center(
                              child: Text(
                                data["isExclusive"] != null &&
                                        data["isExclusive"] == "true"
                                    ? "Exclusive"
                                    : "Discount",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitleFontSizeStyle - 8),
                              ),
                            ),
                          ))
                      : Container()
                ]),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            verticalSpaceTiny,
                            CustomText(
                              data['name'],
                              dotsAfterOverFlow: true,
                              isTitle: true,
                              isBold: true,
                              fontSize: titleFontSizeStyle,
                            ),
                            data["isDiscountAvailable"] == null ||
                                    (data["isDiscountAvailable"] != null &&
                                        data["isDiscountAvailable"] != "true")
                                ? Column(children: <Widget>[
                                    verticalSpaceTiny,
                                    CustomText(
                                      'By ${data['sellerName']}',
                                      color: Colors.grey,
                                      dotsAfterOverFlow: true,
                                      fontSize: subtitleFontSizeStyle,
                                    )
                                  ])
                                : Container(),
                            verticalSpaceSmall,
                            data["isDiscountAvailable"] != null &&
                                    data["isDiscountAvailable"] == "true"
                                ? Row(children: <Widget>[
                                    CustomText(
                                        rupeeUnicode + data['discountedPrice'],
                                        color: darkRedSmooth,
                                        isBold: true,
                                        fontSize: subtitleFontSizeStyle - 2),
                                    horizontalSpaceTiny,
                                    Text(
                                      "\u20B9" + data["price"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: subtitleFontSizeStyle - 4),
                                    )
                                  ])
                                : CustomText(rupeeUnicode + data['price'],
                                    color: darkRedSmooth,
                                    isBold: true,
                                    fontSize: subtitleFontSizeStyle - 2),
                          ],
                        ))),
              ],
            )),
            data["isSameDayDelivery"] != null &&
                    data["isSameDayDelivery"] == "true"
                ? Column(children: <Widget>[
                    verticalSpaceTiny,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomText(
                          "Same Day Delivery",
                          isBold: true,
                          fontSize: subtitleFontSizeStyle - 2,
                          color: textIconOrange,
                        )
                      ],
                    )
                  ])
                : verticalSpace(0)
          ]),
        ));
  }
}
