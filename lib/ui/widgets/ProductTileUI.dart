import 'package:compound/constants/server_urls.dart';
import 'package:compound/models/WhishListSetUp.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/whishlist_service.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/widgets/wishlist_icon.dart';
import 'package:compound/utils/tools.dart';
import 'package:provider/provider.dart';
import '../../locator.dart';
import '../shared/app_colors.dart';
import 'package:flutter/material.dart';

class ProductTileUI extends StatefulWidget {
  final Product data;
  final Function onClick;
  final int index;
  final EdgeInsets cardPadding;

  const ProductTileUI({
    Key key,
    this.data,
    this.onClick,
    this.index,
    this.cardPadding,
  }) : super(key: key);

  @override
  _ProductTileUIState createState() => _ProductTileUIState();
}

class _ProductTileUIState extends State<ProductTileUI> {
  final WhishListService _whishListService = locator<WhishListService>();
  bool toggle = false;

  @override
  void initState() {
    super.initState();
  }

  void addToWhishList(id) async {
    var res = await _whishListService.addWhishList(id);
    if (res == true) {
      Provider.of<WhishListSetUp>(context, listen: false).addToWhishList(id);
    }
  }

  void removeFromWhishList(id) async {
    var res = await _whishListService.removeWhishList(id);
    if (res == true) {
      Provider.of<WhishListSetUp>(context, listen: false)
          .removeFromWhishList(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = Tools.checkIfTablet(MediaQuery.of(context));

    double titleFontSize =
        isTablet ? subtitleFontSizeStyle : subtitleFontSizeStyle - 2;
    double subtitleFontSize =
        isTablet ? subtitleFontSizeStyle - 2 : subtitleFontSizeStyle - 6;
    double priceFontSize =
        isTablet ? subtitleFontSizeStyle : subtitleFontSizeStyle - 4;
    EdgeInsetsGeometry paddingCard = widget.index % 2 == 0
        ? const EdgeInsets.fromLTRB(screenPadding, 0, 0, 10)
        : const EdgeInsets.fromLTRB(0, 0, screenPadding, 10);
    paddingCard = widget.cardPadding == null ? paddingCard : widget.cardPadding;
    // final BlousePadding sellerName=widget.data.whoMadeIt;

    final photo = widget.data.photo ?? null;
    final photos = photo != null ? photo.photos ?? null : null;
    final String photoURL = photos != null ? photos[0].name ?? null : null;
    final String productName = widget?.data?.name ?? "No name";
    final double productDiscount = widget?.data?.cost?.productDiscount?.rate ?? 0.0;
    final int productPrice = widget.data.cost.costToCustomer.round() ?? 0.0;
    final int actualCost = (widget.data.cost.cost + widget.data.cost.convenienceCharges.cost + widget.data.cost.gstCharges.cost).round();
    // final double productOldPrice = widget.data.oldPrice ?? 0.0;
    // final productRatingObj = widget.data.rating ?? null;
    // final productRatingValue =
    //     productRatingObj != null ? productRatingObj.rate : 0.0;
    final String fontFamily = "Raleway";
    print("Take this step");

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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(curve15),
          ),
          elevation: 8,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              productName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Provider.of<WhishListSetUp>(context,
                                            listen: true)
                                        .list
                                        .indexOf(widget.data.key) !=
                                    -1
                                ? WishListIcon(
                                    filled: true,
                                    width: 18,
                                    height: 18,
                                  )
                                : WishListIcon(
                                    filled: false,
                                    width: 18,
                                    height: 18,
                                  ),
                            onTap: () {
                              if (Provider.of<WhishListSetUp>(context,
                                          listen: false)
                                      .list
                                      .indexOf(widget.data.key) !=
                                  -1) {
                                removeFromWhishList(widget.data.key);
                              } else {
                                addToWhishList(widget.data.key);
                              }
                            },
                          )
                        ],
                        // )
                      ),
                      Text(
                        "By ${widget?.data?.seller?.name.toString() ?? 'No Name'}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: fontFamily,
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

                          if ((productDiscount != null) && (productDiscount != 0.0))
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
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Text(
                      //       "\u20B9" + '${productPrice.toInt().toString()}',
                      //       overflow: TextOverflow.ellipsis,
                      //       textAlign: TextAlign.left,
                      //       style: TextStyle(
                      //         color: productDiscount != 0.0
                      //             ? logoRed
                      //             : textIconBlue,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: priceFontSize,
                      //       ),
                      //     ),
                      //     if (productDiscount != 0.0)
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //     if (productDiscount != 0.0)
                      //       Text(
                      //         "\u20B9" +
                      //             '${(productPrice / (1 - (productDiscount / 100))).toString()}',
                      //         textAlign: TextAlign.center,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: TextStyle(
                      //           color: Colors.grey,
                      //           decoration: TextDecoration.lineThrough,
                      //           fontSize: priceFontSize,
                      //         ),
                      //       ),
                      //   ],
                      // ),
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
                        fit: BoxFit.cover,
                        fadeInCurve: Curves.easeIn,
                        placeholder: 'assets/images/product_preloading.png',
                        image: photoURL == null
                            ? 'https://images.pexels.com/photos/157675/fashion-men-s-individuality-black-and-white-157675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                            : '$PRODUCT_PHOTO_BASE_URL/${widget.data.key}/$photoURL',
                        imageErrorBuilder: (context, error, stackTrace) => Image.asset("assets/images/product_preloading.png", fit: BoxFit.cover,),
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
