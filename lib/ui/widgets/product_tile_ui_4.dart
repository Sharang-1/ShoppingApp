import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/server_urls.dart';
import '../../controllers/wishlist_controller.dart';
import '../../locator.dart';
import '../../models/products.dart';
import '../../services/wishlist_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'date_count_down.dart';

class ProductTileUI4 extends StatefulWidget {
  final Product data;
  final Function onClick;
  final int index;
  final EdgeInsets? cardPadding;
  final Function()? onAddToCartClicked;

  const ProductTileUI4({
    Key? key,
    required this.data,
    required this.onClick,
    required this.index,
    this.cardPadding,
    this.onAddToCartClicked,
  }) : super(key: key);

  @override
  _ProductTileUI4State createState() => _ProductTileUI4State();
}

class _ProductTileUI4State extends State<ProductTileUI4> {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 130,
            right: 20,
            left: 20),
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
    DateTime today = DateTime.now();
    DateTime nextSat = today.add(
      Duration(
        days: (DateTime.saturday - today.weekday) % DateTime.daysPerWeek,
        hours: (24 - DateTime.now().hour),
        minutes: (60 - DateTime.now().minute),
        seconds: (60 - DateTime.now().second),
      ),
    );

    EdgeInsetsGeometry paddingCard = widget.index % 2 == 0
        ? const EdgeInsets.fromLTRB(screenPadding, 0, 0, 10)
        : const EdgeInsets.fromLTRB(0, 0, screenPadding, 10);
    paddingCard =
        widget.cardPadding == null ? paddingCard : widget.cardPadding!;

    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String photoURL = photos != null ? photos[0].name ?? "" : "";
    // final String productName = widget.data.name ?? "No name";
    final double? productDiscount =
        (widget.data.cost!.productDiscount != null &&
                widget.data.cost!.productDiscount!.rate != null)
            ? widget.data.cost!.productDiscount!.rate as double?
            : 0.0;
    // final int productPrice = widget.data.cost?.costToCustomer.round() ?? 0;
    // final int actualCost;
    // if (widget.data.cost != null && widget.data.cost!.gstCharges != null) {
    //   actualCost = (widget.data.cost!.cost +
    //           widget.data.cost!.convenienceCharges!.cost! +
    //           widget.data.cost!.gstCharges!.cost!)
    //       .round();
    // } else {
    //   actualCost = 0;
    // }

    return GestureDetector(
      onTap: () {
        print("Hello World ${widget.data.coupons}");
        widget.onClick();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: Get.height - 80,
            height: 180,
            child: _imageStackview(
              photoURL,
              productDiscount,
              priceFontSize,
              handcrafted: (widget.data.whoMadeIt?.id == 2),
            ),
          ),

          // Expanded(
          //   flex: 7,
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(10, 8.0, 6, 6),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Expanded(
          //               child: Text(
          //                 capitalizeString(productName),
          //                 overflow: TextOverflow.ellipsis,
          //                 style: TextStyle(
          //                   fontSize: titleFontSize,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),

          //           ],
          //         ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "Win this product",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: titleFontSize + 4,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "Share any product on the app to stand a chance to win this product for free.",
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CountDownText(
                    due: nextSat,
                    finishedText: "Done",
                    showLabel: true,
                    longDateName: false,
                    daysTextLong: " Day ",
                    hoursTextLong: " Hr ",
                    minutesTextLong: " Min ",
                    secondsTextLong: " S ",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  horizontalSpaceTiny,
                  Text(
                    "until winners are announced!",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          verticalSpaceSmall,
          //         Row(
          //           children: [
          //             Padding(
          //               padding: EdgeInsets.only(right: 5.0),
          //               child: Text(
          //                 "${BaseController.formatPrice(productPrice)}",
          //                 overflow: TextOverflow.ellipsis,
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(
          //                   color: lightGreen,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: priceFontSize,
          //                 ),
          //               ),
          //             ),
          //             if ((productDiscount != null) && (productDiscount != 0.0))
          //               Text(
          //                 "${BaseController.formatPrice(actualCost)}",
          //                 overflow: TextOverflow.ellipsis,
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(
          //                   color: Colors.grey,
          //                   decoration: TextDecoration.lineThrough,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: priceFontSize - 2,
          //                 ),
          //               ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _imageStackview(photoURL, discount, priceFontSize,
      {bool handcrafted = false}) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Positioned.fill(
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.transparent.withOpacity(0.12), BlendMode.srcATop),
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
        widget.data.isCustomisable
            ? Positioned(
                bottom: 2,
                right: 2,
                child: Image.asset(
                  'assets/icons/custom.png',
                  height: 30,
                  width: 30,
                ),
              )
            : Container(),
        // discount != 0.0
        //     ? Positioned(
        //         top: 0,
        //         left: 0,
        //         child: Container(
        //           decoration: BoxDecoration(
        //               color: logoRed,
        //               borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
        //           width: 40,
        //           height: 20,
        //           child: Center(
        //             child: Text(
        //               discount.round().toString() + "%",
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: priceFontSize - 4),
        //             ),
        //           ),
        //         ))
        //     : Container(),
        if (handcrafted)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              height: 20,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 233, 209, 1),
                borderRadius: BorderRadius.circular(
                  curve30,
                ),
              ),
              child: Center(
                child: Text(
                  PRODUCTSCREEN_HANDCRAFTED.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: priceFontSize - 2,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
