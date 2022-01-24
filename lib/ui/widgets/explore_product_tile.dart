import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../locator.dart';
import '../../models/products.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/wishlist_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/home_view_slider.dart';

class ExploreProductTileUI extends StatefulWidget {
  final Product data;
  final Function onClick;
  final int index;
  final EdgeInsets? cardPadding;
  final Function()? onAddToCartClicked;
  final List<String> tags;

  ExploreProductTileUI({
    Key? key,
    required this.data,
    required this.onClick,
    required this.index,
    this.cardPadding,
    this.onAddToCartClicked,
    this.tags = const [],
  }) : super(key: key);

  @override
  _ExploreProductTileUIState createState() => _ExploreProductTileUIState();
}

class _ExploreProductTileUIState extends State<ExploreProductTileUI> {
  final WishListService _wishListService = locator<WishListService>();
  bool toggle = false;
  bool isWishlistIconFilled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isWishlistIconFilled =
          locator<WishListController>().list.indexOf(widget.data.key ?? "") !=
              -1;
    });
  }

  void addToWishList(id) async {
    var res = await _wishListService.addWishList(id);
    if (res == true) {
      locator<WishListController>().addToWishList(id);
      Get.snackbar('Added to Your wishlist', '',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeFromWishList(id) async {
    var res = await _wishListService.removeWishList(id);
    if (res == true) {
      locator<WishListController>().removeFromWishList(id);
    }
  }

  void addToCart(String id) async {}

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry paddingCard = widget.index % 2 == 0
        ? const EdgeInsets.fromLTRB(screenPadding, 0, 0, 10)
        : const EdgeInsets.fromLTRB(0, 0, screenPadding, 10);
    paddingCard =
        widget.cardPadding == null ? paddingCard : widget.cardPadding!;

    final designerKey = widget.data.account!.key ?? "";
    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String productName = widget.data.name ?? "No name";
    final double productDiscount =
        widget.data.cost?.productDiscount?.rate as double? ?? 0.0;
    final int productPrice = widget.data.cost?.costToCustomer.round() ?? 0;
    final int actualCost = (widget.data.cost!.cost +
            widget.data.cost!.convenienceCharges!.cost! +
            widget.data.cost!.gstCharges!.cost!)
        .round();
    final List<String>? videos =
        widget.data.video?.videos.map((e) => e.name ?? "").toList() ?? [];
    final String fontFamily = "Poppins";

    return InkWell(
      onTap: () {
        widget.onClick(fontFamily);
      },
      child: Container(
        padding: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 5.0, color: Colors.grey[300]!))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () =>
                  BaseController.goToSellerPage(widget.data.account!.key ?? ""),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fadeInCurve: Curves.easeIn,
                        imageUrl: '$SELLER_PHOTO_BASE_URL/$designerKey',
                        errorWidget: (context, error, stackTrace) =>
                            Image.asset(
                          "assets/images/product_preloading.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.data.seller?.name.toString() ?? 'No Name'}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${widget.data.seller?.establishmentType?.name?.capitalize ?? ''}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: subtitleFontSize,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.share
                                  : Icons.share,
                              size: 25,
                            ),
                            onPressed: () async {
                              await Share.share(
                                await locator<DynamicLinkService>().createLink(
                                        productLink + widget.data.key!) ??
                                    "",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpaceTiny,
            Expanded(
              child: _imageStackview(
                key: widget.data.key,
                photoUrls: (photos ?? <PhotoElement>[])
                    .map((e) =>
                        '$PRODUCT_PHOTO_BASE_URL/${widget.data.key}/${e.name}')
                    .toList(),
                videoUrls: (videos ?? <String>[])
                    .map((e) =>
                        "${BASE_URL}products/${widget.data.key}/videos/$e")
                    .toList(),
                discount: productDiscount,
                priceFontSize: priceFontSize,
              ),
            ),
            verticalSpaceTiny,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " ${capitalizeString(productName.trim())}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: <String>[
                                ...widget.tags,
                                if ((widget.data.stitchingType?.id ?? -1) == 2)
                                  "Unstitched",
                                if (widget.data.whoMadeIt!.id == 2)
                                  "HandCrafted",
                              ]
                                      .map(
                                        (e) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Text(
                                            e,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: subtitleFontSize,
                                                fontFamily: fontFamily,
                                                color: e.toLowerCase() ==
                                                        "#justhere"
                                                    ? textIconBlue
                                                    : Colors.black),
                                          ),
                                        ),
                                      )
                                      .toList()),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Text(
                              BaseController.formatPrice(productPrice),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: textIconBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: priceFontSize,
                              ),
                            ),
                          ),
                          if ((productDiscount != null) &&
                              (productDiscount != 0.0))
                            Text(
                              BaseController.formatPrice(actualCost),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: priceFontSize - 2,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Divider(
                    color: Colors.grey[400],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          margin: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: lightGreen,
                          ),
                          child: InkWell(
                            onTap: () => widget.onClick(),
                            child: Text(
                              SHOP_NOW.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 25,
                        child: VerticalDivider(
                          color: Colors.grey[400],
                          thickness: 1,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              if (locator<HomeController>().isLoggedIn) {
                                if (locator<WishListController>()
                                        .list
                                        .indexOf(widget.data.key!) !=
                                    -1) {
                                  removeFromWishList(widget.data.key);
                                  setState(() {
                                    isWishlistIconFilled = false;
                                  });
                                } else {
                                  addToWishList(widget.data.key);
                                  setState(() {
                                    isWishlistIconFilled = true;
                                  });
                                }
                              } else {
                                await BaseController.showLoginPopup(
                                  nextView: WishListRoute,
                                  shouldNavigateToNextScreen: false,
                                );
                              }
                            },
                            child: Text(
                              isWishlistIconFilled
                                  ? PRODUCTSCREEN_ADDED_TO_WISHLIST.tr
                                  : PRODUCTSCREEN_ADD_TO_WISHLIST.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: logoRed,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageStackview({
    key,
    photoUrls,
    videoUrls = const [],
    discount,
    priceFontSize,
    // deals = "5+ Coupons",
    deals = "",
  }) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(0.12), BlendMode.srcATop),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Colors.grey[400]!,
                    ),
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.grey[400]!,
                    ),
                  ),
                ),
                child: HomeSlider(
                  aspectRatio: 1,
                  imgList: photoUrls,
                  videoList: videoUrls,
                  fromExplore: true,
                ),
              ),
            ),
          ),
        ),
        if (deals != null && deals != '')
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.yellowAccent,
              ),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              child: Row(
                children: [
                  Text(
                    deals,
                    style: TextStyle(fontSize: 10, color: textIconBlue),
                  ),
                  horizontalSpaceTiny,
                  Icon(
                    Icons.local_offer_outlined,
                    size: 10,
                  ),
                ],
              ),
            ),
          ),
        discount != 0.0
            ? Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: logoRed,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(10))),
                  width: 40,
                  height: 20,
                  child: Center(
                    child: Text(
                      discount.round().toString() + "%",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: priceFontSize - 4),
                    ),
                  ),
                ))
            : Container()
      ],
    );
  }
}
