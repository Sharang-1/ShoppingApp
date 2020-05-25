import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'custom_text.dart';

class TopPicksAndDealsCard extends StatelessWidget {
  final Map<String, dynamic> data;

  TopPicksAndDealsCard({
    this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Card(
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
                            ? 1
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
                        ? data["isExclusive"] != null &&
                                data["isExclusive"] == "true"
                            ? Positioned(
                                top: 0, left: 0, right: 0, child: svgRibbon())
                            : Positioned(top: 0, left: 0, child: svgDiscount())

                        // Container(
                        //   decoration: BoxDecoration(
                        //       color: logoRed,
                        //       borderRadius: BorderRadius.only(
                        //           bottomRight: Radius.circular(10))),
                        //   width: 50,
                        //   height: 20,
                        //   child: Center(
                        //     child: Text(
                        //       data["isExclusive"] != null &&
                        //               data["isExclusive"] == "true"
                        //           ? "Exclusive"
                        //           : "Discount",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: subtitleFontSizeStyle - 8),
                        //     ),
                        //   ),
                        // )

                        : Container()
                  ]),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CustomText(
                                data['name'],
                                dotsAfterOverFlow: true,
                                isTitle: true,
                                isBold: true,
                                color: Colors.grey[800],
                                fontSize: subtitleFontSizeStyle - 2,
                              ),
                              CustomDivider(),
                              data["isDiscountAvailable"] == null ||
                                      (data["isDiscountAvailable"] != null &&
                                          data["isDiscountAvailable"] != "true")
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                          CustomText(
                                            'By ${data['sellerName']}',
                                            color: Colors.grey,
                                            dotsAfterOverFlow: true,
                                            fontSize: subtitleFontSizeStyle - 4,
                                          ),
                                          CustomDivider(),
                                        ])
                                  : Container(),
                              Row(
                                children: <Widget>[
                                  CustomText(rupeeUnicode + data['price'],
                                      color: textIconBlue,
                                      isBold: true,
                                      fontSize: subtitleFontSizeStyle - 2),
                                  horizontalSpaceTiny,
                                  data["isDiscountAvailable"] != null &&
                                          data["isDiscountAvailable"] == "true"
                                      ? Text(
                                          "\u20B9" + data["price"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize:
                                                  subtitleFontSizeStyle - 4),
                                        )
                                      : Container(),
                                ],
                              ),
                              data["isDiscountAvailable"] != null &&
                                      data["isDiscountAvailable"] == "true"
                                  ? Column(
                                      children: <Widget>[
                                        CustomDivider(),
                                        CustomText(
                                          "10 % Discount",
                                          fontSize: subtitleFontSizeStyle - 4,
                                          isBold: true,
                                          color: green,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ))),
                ],
              )),
              data["isSameDayDelivery"] != null &&
                      data["isSameDayDelivery"] == "true"
                  ? Column(children: <Widget>[
                      CustomDivider(),
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
                    ])
                  : verticalSpace(0)
            ]),
          )),
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
                borderRadius: BorderRadius.circular(curve30)),
            height: 20,
            width: 20,
          )),
      SvgPicture.asset(
        "assets/svg/discount.svg",
        color: logoRed,
        height: 30,
        width: 30,
      ),
    ]);
  }

  Widget svgRibbon() {
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        child: SvgPicture.asset(
          "assets/svg/ribbon.svg",
          color: logoRed,
          width: 50,
        ),
      ),
    ]);
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Divider(
          thickness: 1,
          color: Colors.grey[400].withOpacity(0.1),
        ));
  }
}
