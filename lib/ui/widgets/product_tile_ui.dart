import 'package:compound/constants/route_names.dart';
import 'package:compound/controllers/base_controller.dart';
import 'package:compound/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/server_urls.dart';
import '../../controllers/wishlist_controller.dart';
import '../../locator.dart';
import '../../models/products.dart';
import '../../services/wishlist_service.dart';
import '../../utils/stringUtils.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'wishlist_icon.dart';

class ProductTileUI extends StatefulWidget {
  final Product data;
  final Function onClick;
  final int index;
  final EdgeInsets cardPadding;
  final Function() onAddToCartClicked;

  const ProductTileUI({
    Key key,
    @required this.data,
    @required this.onClick,
    @required this.index,
    this.cardPadding,
    this.onAddToCartClicked,
  }) : super(key: key);

  @override
  _ProductTileUIState createState() => _ProductTileUIState();
}

class _ProductTileUIState extends State<ProductTileUI> {
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
    // final BlousePadding sellerName=widget.data.whoMadeIt;

    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String photoURL = photos != null ? photos[0].name ?? null : null;
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
    // final double productOldPrice = widget.data.oldPrice ?? 0.0;
    // final productRatingObj = widget.data.rating ?? null;
    // final productRatingValue =
    //     productRatingObj != null ? productRatingObj.rate : 0.0;

    // double tagSize = isTablet ? 14.0 : 10.0;

    // List<String> tags = [
    //   "Coats",
    //   "Trending",
    //   "211",
    // ];

    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        padding: paddingCard,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 13,
                child: _imageStackview(
                  photoURL,
                  productDiscount,
                  priceFontSize,
                ),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8.0, 6, 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              capitalizeString(productName),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          widget?.onAddToCartClicked == null
                              ? InkWell(
                                  child: WishListIcon(
                                    filled: isWishlistIconFilled,
                                    width: 18,
                                    height: 18,
                                  ),
                                  onTap: (locator<HomeController>().isLoggedIn)
                                      ? () async {
                                          if (locator<WishListController>()
                                                  .list
                                                  .indexOf(widget.data.key) !=
                                              -1) {
                                            removeFromWishList(widget.data.key);
                                            setState(() {
                                              isWishlistIconFilled = false;
                                            });
                                          } else {
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
                                  child: Image.asset(
                                    'assets/images/add_to_bag.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                )
                        ],
                        // )
                      ),
                      Text(
                        "By ${widget?.data?.seller?.name.toString() ?? 'No Name'}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
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
                                fontSize: priceFontSize,
                              ),
                            ),
                          ),
                          if ((productDiscount != null) &&
                              (productDiscount != 0.0))
                            Text(
                              "${BaseController.formatPrice(actualCost)}",
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageStackview(photoURL, discount, priceFontSize) {
    return Stack(fit: StackFit.loose, children: <Widget>[
      Positioned.fill(
        child: FractionallySizedBox(
            widthFactor: 1,
            child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                // borderRadius: BorderRadius.circular(5),
                child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.transparent.withOpacity(0.12),
                        BlendMode.srcATop),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.contain,
                      fadeInCurve: Curves.easeIn,
                      placeholder: 'assets/images/product_preloading.png',
                      image: photoURL == null
                          ? 'https://images.pexels.com/photos/157675/fashion-men-s-individuality-black-and-white-157675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                          : '$PRODUCT_PHOTO_BASE_URL/${widget.data.key}/$photoURL-small.png',
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                        "assets/images/product_preloading.png",
                        fit: BoxFit.cover,
                      ),
                    )))),
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
    ]
        // )

        );
  }
}
