import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../locator.dart';
import '../../models/products.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/remote_config_service.dart';
import '../../services/wishlist_service.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/home_view_slider.dart';

class ExploreProductTileUI extends StatefulWidget {
  final Product data;
  final Function onClick;
  final int index;
  final EdgeInsets cardPadding;
  final Function() onAddToCartClicked;

  const ExploreProductTileUI({
    Key key,
    @required this.data,
    @required this.onClick,
    @required this.index,
    this.cardPadding,
    this.onAddToCartClicked,
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
          locator<WishListController>().list.indexOf(widget.data.key) != -1;
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
    paddingCard = widget.cardPadding == null ? paddingCard : widget.cardPadding;

    final designerKey = widget.data.account.key;
    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String productName = widget?.data?.name ?? "No name";
    final double productDiscount =
        widget?.data?.cost?.productDiscount?.rate ?? 0.0;
    final num deliveryCharges = 35.40;
    final int productPrice =
        (widget.data.cost.costToCustomer + deliveryCharges).round() ?? 0;
    final int actualCost = (widget.data.cost.cost +
                widget.data.cost.convenienceCharges.cost +
                widget.data.cost.gstCharges.cost +
                deliveryCharges)
            .round() ??
        0;
    final String fontFamily = "Poppins";

    return InkWell(
      onTap: widget.onClick,
      child: Container(
        padding: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 5.0, color: Colors.grey[500]))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () =>
                  BaseController.goToSellerPage(widget.data.account.key),
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
                        fit: BoxFit.contain,
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
                                "${widget?.data?.seller?.name.toString() ?? 'No Name'}",
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
                                "${widget?.data?.seller?.establishmentType?.name?.capitalize ?? ''}",
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
                            icon: Image.asset(
                              "assets/images/share_icon.png",
                              width: 25,
                              height: 25,
                            ),
                            onPressed: () async {
                              await Share.share(
                                await locator<DynamicLinkService>()
                                    .createLink(productLink + widget.data.key),
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
                discount: productDiscount,
                priceFontSize: priceFontSize,
              ),
            ),
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
                        child: Row(
                          children: [
                            Text(
                              " ${capitalizeString(productName)}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            horizontalSpaceSmall,
                            Text(
                              "${locator<RemoteConfigService>().remoteConfig.getString(DZOR_EXPLORE_TAG_1_EN)}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: subtitleFontSize,
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Text(
                              "\u20B9" + '$productPrice',
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
                              "\u20B9" + '$actualCost',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: widget.onClick,
                          child: Text(
                            "🛍️ Shop Now !",
                            style: TextStyle(
                              fontSize: 14,
                              color: logoRed,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 16,
                      child: VerticalDivider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            if (locator<WishListController>()
                                    .list
                                    .indexOf(widget.data.key) ==
                                -1) {
                              addToWishList(widget.data.key);
                              setState(() {
                                isWishlistIconFilled = true;
                              });
                            }
                          },
                          child: Text(
                            isWishlistIconFilled
                                ? "❤️ Added to wishlist"
                                : "❤️ Add to wishlist",
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
              child: HomeSlider(
                aspectRatio: 1,
                imgList: photoUrls,
                fromExplore: true,
              ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 20,
        //   right: 8,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white,
        //     ),
        //     child: IconButton(
        //       icon: Image.asset(
        //         "assets/images/share_icon.png",
        //         width: 25,
        //         height: 25,
        //       ),
        //       onPressed: () async {
        //         await Share.share(
        //           await locator<DynamicLinkService>()
        //               .createLink(productLink + key),
        //         );
        //       },
        //     ),
        //   ),
        // ),
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
