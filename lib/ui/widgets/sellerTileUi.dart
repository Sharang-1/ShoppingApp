import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/lang/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/productPageArg.dart';
import '../../models/reviews.dart';
import '../../models/sellers.dart';
import '../../services/api/api_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

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

class SellerTileUi extends StatelessWidget {
  final Seller data;
  final bool fromHome;
  final bool toProduct;
  final onClick;

  SellerTileUi({
    Key? key,
    this.toProduct = false,
    required this.data,
    required this.fromHome,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double subtitleFontSize = fromHome ? 18 * 0.8 : 18;
    double multiplyer = fromHome ? 0.8 : 1;
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
              if (toProduct || data.subscriptionTypeId == 2)
                return NavigationService.to(
                  ProductsListRoute,
                  arguments: ProductPageArg(
                    subCategory: data.name,
                    queryString: "accountKey=${data.key};",
                    sellerPhoto: "$SELLER_PHOTO_BASE_URL/${data.key}",
                  ),
                );
              else
                return NavigationService.to(SellerIndiViewRoute,
                    arguments: data);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(curve15),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                image: data.key != null
                                    ? "$SELLER_PHOTO_BASE_URL/${data.key}"
                                    : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                  "assets/images/product_preloading.png",
                                  width: 100 * multiplyer,
                                  height: 100 * multiplyer,
                                  fit: BoxFit.cover,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text("Speciality",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: logoRed)),
                              AutoSizeText(
                                data.subscriptionTypeId == 2
                                    ? data.contact!.address ?? ""
                                    : data.bio ?? "",
                                // data.subscriptionTypeId == 2
                                //     ? data.contact!.address
                                //     : data.bio ?? "",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize:
                                      subtitleFontSize - (4 * multiplyer) - 2,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                    data.name ?? "",
                                    dotsAfterOverFlow: true,
                                    isTitle: true,
                                    isBold: true,
                                    fontSize: 22,
                                  ),
                                ),
                                verticalSpaceTiny,
                                CustomText(
                                  data.establishmentType!.name ??
                                      accountTypeValues.reverse[
                                          data.accountType ??
                                              AccountType.SELLER] ??
                                      "",
                                  // data.establishmentType.name ??
                                  //     accountTypeValues.reverse[
                                  //         data?.accountType ??
                                  //             AccountType.SELLER],
                                  color: data.accountType == AccountType.SELLER
                                      ? logoRed
                                      : textIconOrange,
                                  isBold: true,
                                  dotsAfterOverFlow: true,
                                  fontSize: subtitleFontSize - (2 * multiplyer),
                                ),
                                verticalSpaceSmall,
                                AutoSizeText(
                                  data.bio ?? "",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize:
                                        subtitleFontSize - (2 * multiplyer),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                FutureBuilder<Reviews?>(
                                  future: locator<APIService>().getReviews(
                                      data.key ?? "",
                                      isSellerReview: true),
                                  builder: (context, snapshot) => ((snapshot
                                                  .connectionState ==
                                              ConnectionState.done) &&
                                          ((snapshot.data?.ratingAverage
                                                      ?.rating ??
                                                  0) >
                                              0))
                                      ? Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Tools
                                                    .getColorAccordingToRattings(
                                                        snapshot
                                                            .data!
                                                            .ratingAverage!
                                                            .rating as num
                                                        // snapshot.data.ratingAverage
                                                        //     .rating,
                                                        ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  curve30,
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  CustomText(
                                                    snapshot.data!
                                                        .ratingAverage!.rating
                                                        .toString(),
                                                    color: Colors.white,
                                                    isBold: true,
                                                    fontSize: 15,
                                                  ),
                                                  horizontalSpaceTiny,
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 15,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ),
                                Expanded(
                                  child: CustomText(
                                    data.operations ?? "",
                                    dotsAfterOverFlow: true,
                                    fontSize: 14,
                                    color: Colors.grey[500]!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

class DesignerTileUi extends StatelessWidget {
  final Seller data;
  final bool isID3;
  final bool isSmallDevice;

  DesignerTileUi({
    Key? key,
    required this.data,
    this.isID3 = false,
    this.isSmallDevice = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0, bottom: 10, right: 0),
      height: 200.0,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[200]!, style: BorderStyle.solid),
        ),
      ),
      width: MediaQuery.of(context).size.width - 40,
      child: GestureDetector(
        onTap: () async {
          if (locator<HomeController>().isLoggedIn) {
            if (data.subscriptionTypeId == 2)
              return NavigationService.to(
                ProductsListRoute,
                arguments: ProductPageArg(
                  subCategory: data.name,
                  queryString: "accountKey=${data.key};",
                  sellerPhoto: "$SELLER_PHOTO_BASE_URL/${data.key}",
                ),
              );
            else
              return NavigationService.to(SellerIndiViewRoute, arguments: data);
          } else {
            await BaseController.showLoginPopup(
              nextView: SellerIndiViewRoute,
              shouldNavigateToNextScreen: false,
            );
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical : 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              child: FadeInImage(
                                width: 48,
                                height: 48,
                                fadeInCurve: Curves.easeIn,
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    "$SELLER_PHOTO_BASE_URL/${data.key}"),
                                placeholder: AssetImage(
                                    "assets/images/product_preloading.png"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                  "assets/images/product_preloading.png",
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          horizontalSpaceSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  data.name ?? "",
                                  dotsAfterOverFlow: true,
                                  isTitle: true,
                                  isBold: false,
                                  fontSize: 18,
                                ),
                                verticalSpaceTiny,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      data.establishmentType?.id == 1
                                          ? 'assets/images/boutique.png'
                                          : 'assets/images/shop.png',
                                      color: Colors.black,
                                      width: 18.0,
                                      height: 18.0,
                                    ),
                                    horizontalSpaceTiny,
                                    CustomText(
                                      data.establishmentType?.name ??
                                          accountTypeValues.reverse[
                                              data.accountType ??
                                                  AccountType.SELLER] ??
                                          "",
                                      // data?.establishmentType?.name ??
                                      //     accountTypeValues.reverse[
                                      //         data?.accountType ??
                                      //             AccountType.SELLER],
                                      color: Colors.black,
                                      isBold: false,
                                      dotsAfterOverFlow: true,
                                      fontSize: 10,
                                      align: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        FutureBuilder<Reviews?>(
                          //! seller key null arhi
                          future: locator<APIService>()
                              .getReviews(data.key ?? "ST2276", isSellerReview: true),
                          builder: (context, snapshot) => ((snapshot
                                          .connectionState ==
                                      ConnectionState.done) &&
                                  ((snapshot.data?.ratingAverage?.rating ?? 0) >
                                      0))
                              ? FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Tools
                                                .getColorAccordingToRattings(
                                              snapshot.data!.ratingAverage!
                                                  .rating as num,
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            CustomText(
                                              snapshot
                                                  .data!.ratingAverage!.rating
                                                  .toString(),
                                              color: Tools
                                                  .getColorAccordingToRattings(
                                                snapshot.data!.ratingAverage!
                                                    .rating as num,
                                              ),
                                              isBold: true,
                                              fontSize: 12,
                                            ),
                                            horizontalSpaceTiny,
                                            Icon(
                                              Icons.star,
                                              color: Tools
                                                  .getColorAccordingToRattings(
                                                snapshot.data!.ratingAverage!
                                                    .rating as num,
                                              ),
                                              size: 12,
                                            )
                                          ],
                                        ),
                                      ),
                                      verticalSpaceTiny,
                                      // CustomText(
                                      //   "${snapshot.data!.ratingAverage!.person} RATINGS",
                                      //   color: Colors.black87,
                                      //   isBold: false,
                                      //   fontSize: 10,
                                      // ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpaceTiny,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: logoRed,
                            size: 10,
                          ),
                          horizontalSpaceTiny,
                          CustomText(
                            data.contact!.city ?? "",
                            fontSize: 12,
                          ),
                          if (!isID3)
                            Row(
                              children: [
                                horizontalSpaceSmall,
                                if (data.subscriptionType?.id == 1)
                                  Image.asset(
                                    'assets/images/stitching.png',
                                    color: logoRed,
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                Image.asset(
                                  'assets/images/selling.png',
                                  color: logoRed,
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (!isID3)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () => BaseController.goToProductListPage(
                              ProductPageArg(
                                subCategory: data.name,
                                queryString: "accountKey=${data.key};",
                                sellerPhoto:
                                    "$SELLER_PHOTO_BASE_URL/${data.key}",
                              ),
                            ),
                            child: CustomText(VIEW_ALL.tr,
                                textStyle: TextStyle(
                                  fontSize: 10,
                                  color: textIconBlue,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),
                    ],
                  ),
                ),
                if (!isID3) verticalSpaceSmall,
                if (!isID3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: data.products!
                        .map(
                          (product) => InkWell(
                            onTap: () =>
                                BaseController.goToProductPage(product),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: FadeInImage(
                                        fit: BoxFit.cover,
                                        fadeInCurve: Curves.easeIn,
                                        height: 100,
                                        width: 100,
                                        placeholder: AssetImage(
                                            'assets/images/product_preloading.png'),
                                        image: CachedNetworkImageProvider(
                                          (product.photo?.photos?.length ??
                                                      0) ==
                                                  0
                                              ? 'assets/images/product_preloading.png'
                                              : '$PRODUCT_PHOTO_BASE_URL/${product.key}/${product.photo?.photos?.first.name}-small.png',
                                        ),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/product_preloading.png",
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                    if ((product.cost?.productDiscount?.rate ??
                                            0.0) !=
                                        0.0)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: logoRed,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(
                                                10,
                                              ),
                                              topRight: Radius.circular(
                                                10,
                                              ),
                                            ),
                                          ),
                                          width: 30,
                                          height: 15,
                                          child: Center(
                                            child: Text(
                                              "${product.cost?.productDiscount?.rate?.round().toString()} %",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                verticalSpaceTiny_0,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      "${BaseController.formatPrice((product.cost!.costToCustomer).round())}",
                                      fontSize: 12,
                                      color: ((product.cost?.productDiscount
                                                      ?.rate ??
                                                  0.0) !=
                                              0.0)
                                          ? lightGreen
                                          : Colors.black,
                                      isBold: true,
                                    ),
                                    if ((product.cost?.productDiscount?.rate ??
                                            0.0) !=
                                        0.0)
                                      horizontalSpaceTiny,
                                    if ((product.cost?.productDiscount?.rate ??
                                            0.0) !=
                                        0.0)
                                      Text(
                                        "${BaseController.formatPrice((product.cost!.cost + product.cost!.convenienceCharges!.cost! + product.cost!.gstCharges!.cost!).round())}",
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey[500],
                                          fontSize: 8,
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
