// import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../models/products.dart';
import '../../services/navigation_service.dart';
import '../shared/shared_styles.dart';

class OrderItemUnavailableErrorView extends StatefulWidget {
  final List<String>? products;
  const OrderItemUnavailableErrorView({Key? key, this.products})
      : super(key: key);

  @override
  State<OrderItemUnavailableErrorView> createState() =>
      _OrderItemUnavailableErrorViewState();
}

class _OrderItemUnavailableErrorViewState
    extends State<OrderItemUnavailableErrorView> {
  List<Product?> items = [];

  @override
  void initState() {
    getItemDetails();
    FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
    super.initState();
  }

  getItemDetails() async {
    for (var i = 0; i < (widget.products?.length ?? 0); i++) {
      var failedItem =
          await APIService().getProductById(productId: widget.products![i]);
      items.add(failedItem);
    }
  }

  Future itemUnavailableReturnHome(context) async {
    Future.delayed(Duration(milliseconds: 5000), () async {
      await NavigationService.offAll(HomeViewRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    itemUnavailableReturnHome(context);

    return ScaffoldMessenger(
      child: Dialog(
        elevation: 5,
        alignment: Alignment.bottomCenter,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          1,
        ),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "The item in your cart is no longer available",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: headingFont,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: (headingFontSizeStyle - 1),
                ),
              )),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     verticalSpaceMedium,
          //     Text("The following items in your cart is no longer available"),
          //     verticalSpaceSmall,
          //     Container(
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         itemCount: items.length,
          //         itemBuilder: (context, index) {
          //           Product? _failedItem = items[index];
          //           final photo = _failedItem!.photo ?? null;
          //           final photos = photo != null ? photo.photos ?? null : null;
          //           final String photoURL =
          //               photos != null ? photos[0].name ?? "" : "";
          //           final String productName = _failedItem.name ?? "No name";
          //           final double? productDiscount =
          //               (_failedItem.cost!.productDiscount != null &&
          //                       _failedItem.cost!.productDiscount!.rate != null)
          //                   ? _failedItem.cost!.productDiscount!.rate as double?
          //                   : 0.0;
          //           final int productPrice =
          //               _failedItem.cost?.costToCustomer.round() ?? 0;
          //           final int actualCost;
          //           if (_failedItem.cost != null &&
          //               _failedItem.cost!.gstCharges != null) {
          //             actualCost = (_failedItem.cost!.cost +
          //                     _failedItem.cost!.convenienceCharges!.cost! +
          //                     _failedItem.cost!.gstCharges!.cost!)
          //                 .round();
          //           } else {
          //             actualCost = 0;
          //           }

          //           return Container(
          //             padding: EdgeInsets.all(8),
          //             margin: EdgeInsets.symmetric(vertical: 2),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(5),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black12,
          //                   blurRadius: 2,
          //                 ),
          //               ],
          //             ),
          //             child: Row(
          //               children: [
          //                 Container(
          //                   height: 100,
          //                   width: 100,
          //                   child: _imageStackview(
          //                     _failedItem,
          //                     photoURL,
          //                   ),
          //                 ),
          //                 Container(
          //                   padding: EdgeInsets.symmetric(
          //                       vertical: 6, horizontal: 12),
          //                   width:
          //                       MediaQuery.of(context).size.width * 0.9 - 100,
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         capitalizeString(productName),
          //                         overflow: TextOverflow.ellipsis,
          //                         maxLines: 1,
          //                         style: TextStyle(
          //                           fontSize: titleFontSize + 3,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                       // verticalSpaceTiny,

          //                       verticalSpaceTiny,
          //                       Row(
          //                         children: [
          //                           Padding(
          //                             padding: EdgeInsets.only(right: 5.0),
          //                             child: Text(
          //                               "${BaseController.formatPrice(productPrice)}",
          //                               overflow: TextOverflow.ellipsis,
          //                               textAlign: TextAlign.left,
          //                               style: TextStyle(
          //                                 color: lightGreen,
          //                                 fontWeight: FontWeight.bold,
          //                                 fontSize: priceFontSize + 5,
          //                               ),
          //                             ),
          //                           ),
          //                           if ((productDiscount != null) &&
          //                               (productDiscount != 0.0))
          //                             Text(
          //                               "${BaseController.formatPrice(actualCost)}",
          //                               overflow: TextOverflow.ellipsis,
          //                               textAlign: TextAlign.left,
          //                               style: TextStyle(
          //                                 color: Colors.grey,
          //                                 decoration:
          //                                     TextDecoration.lineThrough,
          //                                 fontWeight: FontWeight.bold,
          //                                 fontSize: priceFontSize + 4,
          //                               ),
          //                             ),
          //                         ],
          //                       ),
          //                       verticalSpaceTiny,
          //                       Text(
          //                         _failedItem.description.toString(),
          //                         maxLines: 1,
          //                         overflow: TextOverflow.ellipsis,
          //                         style: TextStyle(
          //                           color: Colors.grey,
          //                           fontWeight: FontWeight.normal,
          //                           fontSize: subtitleFontSize,
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _imageStackview(Product? product, photoURL) {
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
                  colorFilter: ColorFilter.mode(
                      Colors.transparent.withOpacity(0.12), BlendMode.srcATop),
                  child: FastCachedImage(
                    // child: CachedNetworkImage(
                    errorBuilder:
                        // errorWidget:
                        (context, url, error) => Image.asset(
                      'assets/images/product_preloading.png',
                      fit: BoxFit.cover,
                    ),
                    url:
                        // imageUrl:
                        photoURL == null
                            ? 'https://images.pexels.com/photos/157675/fashion-men-s-individuality-black-and-white-157675.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                            : '$PRODUCT_PHOTO_BASE_URL/${product?.key}/$photoURL-small.png',
                    fit: BoxFit.cover,
                    // fadeInCurve: Curves.easeIn,
                    // placeholder:
                    loadingBuilder: (context, url) => Image.asset(
                      'assets/images/product_preloading.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
