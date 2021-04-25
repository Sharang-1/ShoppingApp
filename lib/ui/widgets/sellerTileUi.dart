import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../models/productPageArg.dart';
import '../../models/reviews.dart';
import '../../models/sellers.dart';
import '../../services/api/api_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class SellerTileUi extends StatelessWidget {
  final Seller data;
  final bool fromHome;
  final bool toProduct;
  final onClick;
  // final APIService _apiService = locator<APIService>();
  SellerTileUi({
    Key key,
    this.toProduct = false,
    @required this.data,
    @required this.fromHome,
    this.onClick,
  }) : super(key: key);

  Color getColorAccordingToRattings(num rattings) {
    switch (rattings) {
      case 5:
        return Color.fromRGBO(0, 100, 0, 1);
      case 4:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 2:
        return Colors.orange;
      default:
        return logoRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtitleFontSize = fromHome ? 18 * 0.8 : 18;
    // double titleFontSize = fromHome ? 18 * 0.8 : 18;
    double multiplyer = fromHome ? 0.8 : 1;
    final NavigationService _navigationService = locator<NavigationService>();
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.only(left: 5, bottom: 10, right: fromHome ? 5 : 0),
        child: SizedBox(
          height: 200.0 * (fromHome ? 0.8 : 1.0),
          width:
              (MediaQuery.of(context).size.width - 40) * (fromHome ? 0.8 : 1),
          child: GestureDetector(
            onTap: () async {
              if (toProduct || data.subscriptionTypeId == 2) {
                return _navigationService.navigateTo(
                  ProductsListRoute,
                  arguments: ProductPageArg(
                    subCategory: data.name,
                    queryString: "accountKey=${data.key};",
                    sellerPhoto: "$SELLER_PHOTO_BASE_URL/${data.key}",
                  ),
                );
              } else {
                // Seller seller = await _apiService.getSellerByID(data.key);
                return _navigationService.navigateTo(SellerIndiViewRoute,
                    arguments: data);
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(curve15),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: Stack(
                children: [
                  // if (data?.subscriptionTypeId != 2)
                  //   Align(
                  //     alignment: Alignment.topRight,
                  //     child: FutureBuilder<Reviews>(
                  //       future: locator<APIService>()
                  //           .getReviews(data?.key, isSellerReview: true),
                  //       builder: (context, snapshot) => ((snapshot
                  //                       .connectionState ==
                  //                   ConnectionState.done) &&
                  //               ((snapshot?.data?.ratingAverage?.rating ?? 0) >
                  //                   0))
                  //           ? FittedBox(
                  //               fit: BoxFit.scaleDown,
                  //               child: Container(
                  //                 padding: EdgeInsets.symmetric(
                  //                     vertical: 5, horizontal: 10),
                  //                 decoration: BoxDecoration(
                  //                     color: getColorAccordingToRattings(
                  //                         snapshot.data.ratingAverage.rating),
                  //                     borderRadius:
                  //                         BorderRadius.circular(curve30)),
                  //                 child: Row(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.center,
                  //                   children: <Widget>[
                  //                     CustomText(
                  //                       snapshot.data.ratingAverage.rating
                  //                           .toString(),
                  //                       color: Colors.white,
                  //                       isBold: true,
                  //                       fontSize: 15,
                  //                     ),
                  //                     horizontalSpaceTiny,
                  //                     Icon(
                  //                       Icons.star,
                  //                       color: Colors.white,
                  //                       size: 15,
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           : Container(),
                  //     ),
                  //   ),
                  Container(
                    // decoration: ((data.subscriptionTypeId != 2) &&
                    //         (data?.photo?.first?.name ?? '').isNotEmpty)
                    //     ? BoxDecoration(
                    //         image: DecorationImage(
                    //           image: CachedNetworkImageProvider(
                    //               "$SELLER_PROFILE_PHOTO_BASE_URL/${data.key}/profile/${data?.photos?.first?.name ?? ''}"),
                    //           fit: BoxFit.scaleDown,
                    //         ),
                    //       )
                    //     : BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 0.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    width: 100 * multiplyer,
                                    height: 100 * multiplyer,
                                    fadeInCurve: Curves.easeIn,
                                    placeholder:
                                        "assets/images/product_preloading.png",
                                    image: data?.key != null
                                        ? "$SELLER_PHOTO_BASE_URL/${data.key}"
                                        : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/images/product_preloading.png",
                                      width: 100 * multiplyer,
                                      height: 100 * multiplyer,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Stack(
                                    children: [
                                      
                                      Column(
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
                                            fontSize: 22,
                                          ),
                                          CustomDivider(),
                                          CustomText(
                                            data?.establishmentType?.name ??
                                                accountTypeValues.reverse[
                                                    data?.accountType ??
                                                        AccountType.SELLER],
                                            color: data.accountType ==
                                                    AccountType.SELLER
                                                ? logoRed
                                                : textIconOrange,
                                            isBold: true,
                                            dotsAfterOverFlow: true,
                                            fontSize: subtitleFontSize +
                                                2 -
                                                (2 * multiplyer),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: FutureBuilder<Reviews>(
                                              future: locator<APIService>()
                                                  .getReviews(data?.key,
                                                      isSellerReview: true),
                                              builder: (context, snapshot) =>
                                                  ((snapshot.connectionState ==
                                                              ConnectionState
                                                                  .done) &&
                                                          ((snapshot
                                                                      ?.data
                                                                      ?.ratingAverage
                                                                      ?.rating ??
                                                                  0) >
                                                              0))
                                                      ? FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal: 10),
                                                            decoration: BoxDecoration(
                                                                color: getColorAccordingToRattings(
                                                                    snapshot
                                                                        .data
                                                                        .ratingAverage
                                                                        .rating),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            curve30)),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                CustomText(
                                                                  snapshot
                                                                      .data
                                                                      .ratingAverage
                                                                      .rating
                                                                      .toString(),
                                                                  color:
                                                                      Colors.white,
                                                                  isBold: true,
                                                                  fontSize: 15,
                                                                ),
                                                                horizontalSpaceTiny,
                                                                Icon(
                                                                  Icons.star,
                                                                  color:
                                                                      Colors.white,
                                                                  size: 15,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  data?.subscriptionTypeId == 2
                                      ? data?.contact?.address
                                      : data?.bio ?? "",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize:
                                        subtitleFontSize - (4 * multiplyer) - 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

// class SellerScreen extends StatelessWidget {
//   Map<String, String> sellerCardDetails = {
//     "name": "Sejal Works",
//     "type": "SELLER",
//     "sells": "Dresses , Kurtas",
//     "discount": "10% Upto 30%",
//   };
//   Map<String, String> boutiqueCardDetails = {
//     "name": "Ketan Works",
//     "type": "BOUTIQUE",
//     "Speciality": "Spec1 , Spec2 , Spec3 , Spec4 , Spec5",
//     "WorksOffered": "Work1 , Work2 , Work3 , Work4",
//   };
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: backgroundWhiteCreamColor,
//         elevation: 0,
//       ),
//       backgroundColor: backgroundWhiteCreamColor,
//       body: Container(
//         padding: EdgeInsets.only(left: 20),
//         height: 175,
//         child: ListView(
//           scrollDirection: Axis.horizontal,
//           children: <Widget>[
//             SellerTileUi(
//               data: sellerCardDetails,
//               fromHome: true,
//             ),
//             SellerTileUi(
//               data: boutiqueCardDetails,
//               fromHome: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
