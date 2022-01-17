import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class SellerCard extends StatelessWidget {
  final data;
  final bool fromHome;
  final Function onClick;
  const SellerCard({
    Key? key,
    required this.data,
    required this.fromHome,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double subtitleFontSize = fromHome ? 18 * 0.8 : 18;
    double titleFontSize = fromHome ? 18 * 0.8 : 18;
    double multiplyer = fromHome ? 0.8 : 1;

    return Container(
        padding: EdgeInsets.only(left: 5, bottom: 10, right: fromHome ? 5 : 0),
        child: SizedBox(
          height: 200 * (fromHome ? 0.8 : 1),
          width:
              (MediaQuery.of(context).size.width - 40) * (fromHome ? 0.8 : 1),
          child: GestureDetector(
            onTap: onClick(),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(curve15),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(curve15),
                                  child: FadeInImage.assetNetwork(
                                    width: 80 * multiplyer,
                                    height: 80 * multiplyer,
                                    fadeInCurve: Curves.easeIn,
                                    placeholder:
                                        "assets/images/product_preloading.png",
                                    image:
                                        "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/images/product_preloading.png",
                                      width: 80 * multiplyer,
                                      height: 80 * multiplyer,
                                      fit: BoxFit.cover,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        CustomText(
                                          data.name,
                                          dotsAfterOverFlow: true,
                                          isTitle: true,
                                          isBold: true,
                                          fontSize: titleFontSize,
                                        ),
                                        CustomDivider(),
                                        CustomText(
                                          data.accountType,
                                          color: data.accountType == "SELLER"
                                              ? logoRed
                                              : textIconOrange,
                                          isBold: true,
                                          dotsAfterOverFlow: true,
                                          fontSize: subtitleFontSize -
                                              (2 * multiplyer),
                                        ),
                                      ],
                                    ))),
                          ],
                        ),
                        verticalSpace(10),
                        data.accountType == "SELLER"
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(
                                    "Sells         :  ",
                                    color: Colors.grey,
                                    isBold: true,
                                    dotsAfterOverFlow: true,
                                    fontSize:
                                        subtitleFontSize - (4 * multiplyer),
                                  ),
                                  verticalSpace(2),
                                  Expanded(
                                    child: CustomText(
                                      data.designs,
                                      color: Colors.grey[700]!,
                                      isBold: true,
                                      dotsAfterOverFlow: true,
                                      fontSize:
                                          subtitleFontSize - (4 * multiplyer),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(
                                    "Speciality          :  ",
                                    color: Colors.grey,
                                    isBold: true,
                                    dotsAfterOverFlow: true,
                                    fontSize:
                                        subtitleFontSize - (4 * multiplyer),
                                  ),
                                  verticalSpace(2),
                                  Expanded(
                                    child: CustomText(
                                      data.known,
                                      color: Colors.grey[700]!,
                                      isBold: true,
                                      dotsAfterOverFlow: true,
                                      fontSize:
                                          subtitleFontSize - (5 * multiplyer),
                                    ),
                                  ),
                                ],
                              ),
                        CustomDivider(),
                        data.accountType == "SELLER"
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(
                                    "Discount  :  ",
                                    color: Colors.grey,
                                    isBold: true,
                                    dotsAfterOverFlow: true,
                                    fontSize:
                                        subtitleFontSize - (4 * multiplyer),
                                  ),
                                  verticalSpace(2),
                                  Expanded(
                                    child: CustomText(
                                      "10% Upto 30%",
                                      color: green,
                                      isBold: true,
                                      dotsAfterOverFlow: true,
                                      fontSize:
                                          subtitleFontSize - (4 * multiplyer),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CustomText(
                                    "Works Offered  :  ",
                                    color: Colors.grey,
                                    isBold: true,
                                    dotsAfterOverFlow: true,
                                    fontSize:
                                        subtitleFontSize - (4 * multiplyer),
                                  ),
                                  verticalSpace(2),
                                  Expanded(
                                    child: CustomText(
                                      data.works,
                                      color: Colors.grey[700]!,
                                      isBold: true,
                                      dotsAfterOverFlow: true,
                                      fontSize:
                                          subtitleFontSize - (5 * multiplyer),
                                    ),
                                  ),
                                ],
                              ),
                      ]),
                )),
          ),
        ));
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
        ));
  }
}
