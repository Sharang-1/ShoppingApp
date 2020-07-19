import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';

import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/shared_styles.dart';

class SellerCard extends StatelessWidget {
  final data;
  final bool fromHome;
  final Function onClick;
  const SellerCard({
    Key key,
    @required this.data,
    @required this.fromHome,
    this.onClick,
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
            onTap: onClick,
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
                                        "assets/images/placeholder.png",
                                    image:
                                        "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
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
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      color: Colors.grey[700],
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
                                      color: Colors.grey[700],
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
                                      color: Colors.grey[700],
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

// class SellerTileUi extends StatelessWidget {
//   final data;

//   const SellerTileUi({Key key, @required this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double subtitleFontSize = 17;
//     double titleFontSize = 17;
//     return Container(
//         padding: EdgeInsets.only(bottom: 10),
//         child: SizedBox(
//           height: 200,
//           child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(curve15),
//               ),
//               clipBehavior: Clip.antiAlias,
//               elevation: 5,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
//                 child: Row(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: ClipRRect(
//                           borderRadius: BorderRadius.circular(curve15),
//                           child: FadeInImage.assetNetwork(
//                             width:
//                                 (MediaQuery.of(context).size.width - 60) * 0.4,
//                             height: 150,
//                             fadeInCurve: Curves.easeIn,
//                             placeholder: "assets/images/placeholder.png",
//                             image:
//                                 "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
//                             fit: BoxFit.cover,
//                           )),
//                     ),
//                     Expanded(
//                         child: Padding(
//                             padding: EdgeInsets.only(left: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 CustomText(
//                                   data["name"],
//                                   dotsAfterOverFlow: true,
//                                   isTitle: true,
//                                   isBold: true,
//                                   fontSize: titleFontSize,
//                                 ),
//                                 CustomDivider(),
//                                 CustomText(
//                                   data.accountType,
//                                   color: textIconOrange,
//                                   isBold: true,
//                                   dotsAfterOverFlow: true,
//                                   fontSize: subtitleFontSize - 2,
//                                 ),
//                                 CustomDivider(),
//                                 data.accountType == "SELLER"
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           CustomText(
//                                             "Sells :",
//                                             color: Colors.grey,
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                           verticalSpace(2),
//                                           CustomText(
//                                             data["sells"],
//                                             color: Colors.grey[700],
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                         ],
//                                       )
//                                     : Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           CustomText(
//                                             "Speciality :",
//                                             color: Colors.grey,
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                           verticalSpace(2),
//                                           CustomText(
//                                             data["Speciality"],
//                                             color: Colors.grey[700],
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                         ],
//                                       ),
//                                 CustomDivider(),
//                                 data.accountType == "SELLER"
//                                     ? Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           CustomText(
//                                             "Discount :",
//                                             color: Colors.grey,
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                           verticalSpace(2),
//                                           CustomText(
//                                             data["discount"],
//                                             color: green,
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                         ],
//                                       )
//                                     : Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           CustomText(
//                                             "Works Offered :",
//                                             color: Colors.grey,
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                           verticalSpace(2),
//                                           CustomText(
//                                             data["WorksOffered"],
//                                             color: Colors.grey[700],
//                                             isBold: true,
//                                             dotsAfterOverFlow: true,
//                                             fontSize: subtitleFontSize - 4,
//                                           ),
//                                         ],
//                                       ),

//                               ],
//                             ))),
//                   ],
//                 ),
//               )),
//         ));
//   }
// }

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

class SellerScreen extends StatelessWidget {
  Map<String, String> sellerCardDetails = {
    "name": "Sejal Works",
    "type": "SELLER",
    "sells": "Dresses , Kurtas",
    "discount": "10% Upto 30%",
  };
  Map<String, String> boutiqueCardDetails = {
    "name": "Ketan Works",
    "type": "BOUTIQUE",
    "Speciality": "Spec1 , Spec2 , Spec3 , Spec4 , Spec5",
    "WorksOffered": "Work1 , Work2 , Work3 , Work4",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundWhiteCreamColor,
        elevation: 0,
      ),
      backgroundColor: backgroundWhiteCreamColor,
      body: Container(
        padding: EdgeInsets.only(left: 20),
        height: 175,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SellerCard(
              data: sellerCardDetails,
              fromHome: true,
            ),
            SellerCard(
              data: boutiqueCardDetails,
              fromHome: true,
            ),
          ],
        ),
      ),
    );
  }
}
