import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../models/productPageArg.dart';
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
  final APIService _apiService = locator<APIService>();
  SellerTileUi({
    Key key,
    this.toProduct = false,
    @required this.data,
    @required this.fromHome,
    this.onClick,
  }) : super(key: key);
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
                Seller seller = await _apiService.getSellerByID(data.key);
                return _navigationService.navigateTo(SellerIndiViewRoute,
                    arguments: seller);
              }
            },
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
                              width: 100 * multiplyer,
                              height: 100 * multiplyer,
                              fadeInCurve: Curves.easeIn,
                              placeholder:
                                  "assets/images/product_preloading.png",
                              image: data?.key != null
                                  ? "$SELLER_PHOTO_BASE_URL/${data.key}"
                                  : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                              imageErrorBuilder: (context, error, stackTrace) =>
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color:
                                          data.accountType == AccountType.SELLER
                                              ? logoRed
                                              : textIconOrange,
                                      isBold: true,
                                      dotsAfterOverFlow: true,
                                      fontSize: subtitleFontSize +
                                          2 -
                                          (2 * multiplyer),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                    verticalSpace(10),
                    if (data.subscriptionTypeId != 2)
                      data.accountType == AccountType.SELLER
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  "Designs         :  ",
                                  color: textIconBlue,
                                  isBold: true,
                                  dotsAfterOverFlow: true,
                                  fontSize: subtitleFontSize - (4 * multiplyer),
                                ),
                                verticalSpace(2),
                                Expanded(
                                  child: CustomText(
                                    data?.designs ?? "",
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
                                  fontSize: subtitleFontSize - (4 * multiplyer),
                                ),
                                verticalSpace(2),
                                Expanded(
                                  child: CustomText(
                                    data?.designs ?? "",
                                    color: Colors.grey[700],
                                    isBold: true,
                                    dotsAfterOverFlow: true,
                                    fontSize:
                                        subtitleFontSize - (5 * multiplyer),
                                  ),
                                ),
                              ],
                            ),
                    if (data.subscriptionTypeId != 2) CustomDivider(),
                    if (data.subscriptionTypeId != 2)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            "Works Offered  :  ",
                            color: textIconBlue,
                            isBold: true,
                            dotsAfterOverFlow: true,
                            fontSize: subtitleFontSize - (4 * multiplyer),
                          ),
                          verticalSpace(2),
                          Expanded(
                            child: CustomText(
                              data?.works ?? "",
                              color: Colors.grey[700],
                              isBold: true,
                              dotsAfterOverFlow: true,
                              fontSize: subtitleFontSize - (5 * multiplyer),
                            ),
                          ),
                        ],
                      ),
                    if (data.subscriptionTypeId == 2)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            "Address  :  ",
                            color: textIconBlue,
                            isBold: true,
                            dotsAfterOverFlow: true,
                            fontSize: subtitleFontSize - (4 * multiplyer),
                          ),
                          verticalSpace(2),
                          Expanded(
                            child: CustomText(
                              data?.contact?.address ?? "",
                              color: Colors.grey[700],
                              isBold: true,
                              dotsAfterOverFlow: true,
                              fontSize: subtitleFontSize - (5 * multiplyer),
                            ),
                          ),
                        ],
                      ),
                    if (data.subscriptionTypeId == 2)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            "                    ",
                            color: textIconBlue,
                            isBold: true,
                            dotsAfterOverFlow: true,
                            fontSize: subtitleFontSize - (4 * multiplyer),
                          ),
                          verticalSpace(2),
                          Expanded(
                            child: CustomText(
                              data?.contact?.pincode ?? "",
                              color: Colors.grey[700],
                              isBold: true,
                              dotsAfterOverFlow: true,
                              fontSize: subtitleFontSize - (5 * multiplyer),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
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
