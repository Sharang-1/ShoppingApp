import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../locator.dart';
import '../../models/products.dart';
import '../../services/api/api_service.dart';
import '../../services/wishlist_service.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'wishlist_icon.dart';

class ProductTileUI3 extends StatefulWidget {
  final Product data;
  final Function onClick;
  final int index;
  final EdgeInsets? cardPadding;
  final Function()? onAddToCartClicked;

  const ProductTileUI3({
    Key? key,
    required this.data,
    required this.onClick,
    required this.index,
    this.cardPadding,
    this.onAddToCartClicked,
  }) : super(key: key);

  @override
  _ProductTileUI3State createState() => _ProductTileUI3State();
}

class _ProductTileUI3State extends State<ProductTileUI3> {
  final WishListService _wishListService = locator<WishListService>();
  bool toggle = false;
  bool isWishlistIconFilled = false;
  Product? productInfo;

  @override
  void initState() {
    super.initState();
    getProductDetailInfo();
    setState(() {
      isWishlistIconFilled =
          locator<WishListController>().list.indexOf(widget.data.key ?? "") != -1;
    });
  }

  getProductDetailInfo() async {
    final prod = await APIService().getProductById(productId: widget.data.key!);
    setState(() {
      productInfo = prod;
    });
  }

  void addToWishList(id) async {
    var res = await _wishListService.addWishList(id);
    if (res == true) {
      locator<WishListController>().addToWishList(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 130, right: 20, left: 20),
        content: Row(
          children: [
            Icon(
              CupertinoIcons.checkmark_alt,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            const Text('Added to Your wishlist'),
          ],
        ),
        backgroundColor: Color(0xFF5da588),
      ));
      // Get.snackbar( 'Added to Your wishlist','',
      //     snackPosition: SnackPosition.TOP,
      //
      //   backgroundColor: Color(0xFF5da588),
      //   icon: Icon(
      //     CupertinoIcons.check_mark,
      //     color: Colors.white,
      //   ),
      //
      // );
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
    paddingCard = widget.cardPadding == null ? paddingCard : widget.cardPadding!;

    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String photoURL = photos != null ? photos[0].name ?? "" : "";
    final String productName = widget.data.name ?? "No name";
    final double? productDiscount = (widget.data.cost!.productDiscount != null &&
            widget.data.cost!.productDiscount!.rate != null)
        ? widget.data.cost!.productDiscount!.rate as double?
        : 0.0;
    final int productPrice = widget.data.cost?.costToCustomer.round() ?? 0;
    final int actualCost;
    if (widget.data.cost != null && widget.data.cost!.gstCharges != null) {
      actualCost = (widget.data.cost!.cost +
              widget.data.cost!.convenienceCharges!.cost! +
              widget.data.cost!.gstCharges!.cost!)
          .round();
    } else {
      actualCost = 0;
    }

    return GestureDetector(
      onTap: () {
        print("Hello World ${widget.data.coupons}");
        widget.onClick();
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(3),
              height: double.maxFinite,
              width: 120,
              decoration: BoxDecoration(
                // border: Border.all()
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: _imageStackview(
                      photoURL,
                      productDiscount,
                      priceFontSize,
                      handcrafted: (widget.data.whoMadeIt?.id == 2),
                    ),
                  ),
                  // Positioned(
                  //   left: 0,
                  //   top: 0,
                  //   child: Container(
                  //     color: Colors.white,
                  //     padding: EdgeInsets.all(5),
                  //     child: Text(widget.index.toString()),
                  //   ),
                  // ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: widget.onAddToCartClicked == null
                        ? InkWell(
                            child: WishListIcon(
                              filled: isWishlistIconFilled,
                              width: 10,
                              height: 10,
                            ),
                            onTap: (locator<HomeController>().isLoggedIn)
                                ? () async {
                                    if (locator<WishListController>()
                                            .list
                                            .indexOf(widget.data.key ?? "") !=
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
                                  }
                                : () async {
                                    await BaseController.showLoginPopup(
                                      nextView: WishListRoute,
                                      shouldNavigateToNextScreen: true,
                                    );
                                  },
                          )
                        : InkWell(
                            child: Icon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                          )),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.only(top: widget.data.whoMadeIt?.id == 2?0: 8, left: 12, bottom: 5, right: 12),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              width: MediaQuery.of(context).size.width * 0.9 - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// widget.data.whoMadeIt?.id == 2 ?Container(
//                 height: 14,
//                 width: 100,
//                 padding: EdgeInsets.symmetric(horizontal: 8.0),
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(251, 233, 209, 1),
//                   borderRadius: BorderRadius.circular(
//                     curve30,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     PRODUCTSCREEN_HANDCRAFTED.tr,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: priceFontSize - 4,
//                     ),
//                   ),
//                 ),
//               ): Container(),

                  Text(
                    capitalizeString(productName),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: titleFontSize + 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // verticalSpaceTiny,

                  Text(
                    "By ${productInfo?.seller?.name.toString() ?? 'Anonymous seller'}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: subtitleFontSize + 1,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  verticalSpaceTiny,
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          "${BaseController.formatPrice(productPrice)}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: lightGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: priceFontSize + 5,
                          ),
                        ),
                      ),
                      if ((productDiscount != null) && (productDiscount != 0.0))
                        Text(
                          "${BaseController.formatPrice(actualCost)}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.bold,
                            fontSize: priceFontSize + 4,
                          ),
                        ),
                    ],
                  ),
                  verticalSpaceTiny,
                  Text(
                    widget.data.description.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: subtitleFontSize,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageStackview(photoURL, discount, priceFontSize, {bool handcrafted = false}) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Positioned.fill(
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Colors.transparent.withOpacity(0.12), BlendMode.srcATop),
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/product_preloading.png',
                      fit: BoxFit.cover,
                    ),
                    imageUrl: photoURL == null
                        ? 'https://images.pexels.com/photos/157675/fashion-men-s-individuality-black-and-white-157675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                        : '$PRODUCT_PHOTO_BASE_URL/${widget.data.key}/$photoURL-small.png',
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeIn,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/product_preloading.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
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
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
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
            : Container(),
        // if (handcrafted)
        //   Positioned(
        //     bottom: 8,
        //     left: 8,
        //     child: Container(
        //       height: 14,
        //       padding: EdgeInsets.symmetric(horizontal: 8.0),
        //       decoration: BoxDecoration(
        //         color: Color.fromRGBO(251, 233, 209, 1),
        //         borderRadius: BorderRadius.circular(
        //           curve30,
        //         ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           PRODUCTSCREEN_HANDCRAFTED.tr,
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontWeight: FontWeight.bold,
        //             fontSize: priceFontSize - 4,
        //           ),
        //         ),
        //       ),
        //     ),
        //   )
      ],
    );
  }
}
