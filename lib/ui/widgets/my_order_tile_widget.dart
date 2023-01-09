import 'package:compound/models/ordersV2.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/server_urls.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/products.dart';
import '../../services/analytics_service.dart';
import '../../services/api/api_service.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/myorders_details_view.dart';
import 'shimmer/my_orders_shimmer.dart';

class OrderTileDetail extends StatefulWidget {
  final Order order;
  const OrderTileDetail({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderTileDetail> createState() => _OrderTileDetailState();
}

class _OrderTileDetailState extends State<OrderTileDetail> {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  bool isLoading = true;
  Product? productDetail;
  final APIService _apiService = locator<APIService>();

  @override
  void initState() {
    getProductInfo();
    super.initState();
  }

  getProductInfo() async {
    var productInfo = await _apiService.getProductById(productId: widget.order.productId!);
    setState(() {
      productDetail = productInfo;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? MyOrdersShimmer()
        : GestureDetector(
            child: Container(
              height: 110,
              padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(curve15),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(curve15),
                      child: FadeInImage.assetNetwork(
                        width: 90,
                        height: 90,
                        fadeInCurve: Curves.easeIn,
                        placeholder: "assets/images/product_preloading.png",
                        // image: "",
                        // todo : img url
                        image:
                            "$PRODUCT_PHOTO_BASE_URL/${productDetail!.key}/${productDetail?.photo?.photos?.first.name ?? 'photo'}-small.png",
                        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                          "assets/images/product_preloading.png",
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    // width: Get.width - 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          productDetail?.name?.capitalizeFirst ?? "",
                          // "Product Name for more than 2 lines example testingbla bla bla bla bl al",
                          // todo : implement product name
                          isBold: true,
                          maxLines: 2,
                          color: Colors.black87,
                          dotsAfterOverFlow: true,
                          fontSize: titleFontSize + 2,
                        ),
                        verticalSpaceSmall,
                        //order placed on date time
                        Row(
                          children: [
                            Text(
                              widget.order.status!.state ?? "",
                              style: TextStyle(
                                color:
                                    (<int>[0, 1, 2, 3, 4, 5, 7].contains(widget.order.status!.id))
                                        ? Colors.green
                                        : logoRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                            horizontalSpaceTiny,
                            // Text("${order.status!.id}"),
                            Text(
                              (<int>[
                                1,
                                2,
                                3,
                                4,
                                5,
                              ].contains(widget.order.status!.id))
                                  ? 'on ${widget.order.created}'
                                  : (widget.order.status!.id == 7)
                                      ? 'on ${widget.order.deliveryDate}'
                                      : "",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // verticalSpaceTiny,
                        // CustomText(
                        //   "$rupeeUnicode${widget.order.commonField?.orderCost?.cost.toString()}",
                        //   dotsAfterOverFlow: true,
                        //   fontSize: titleFontSize + 2,
                        //   isBold: true,
                        //   color: Colors.black54,
                        // ),
                        // Column(
                        //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[

                        //     // Row(
                        //     //   children: [
                        //     //     CustomText("Qty: ",
                        //     //         dotsAfterOverFlow: true,
                        //     //         color: Colors.black,
                        //     //         fontWeight: FontWeight.bold,
                        //     //         fontSize: subtitleFontSize),
                        //     //     horizontalSpaceSmall,
                        //     //     CustomText((order.itemCost?.quantity ?? 0).toString(),
                        //     //         dotsAfterOverFlow: true,
                        //     //         color: Colors.grey,
                        //     //         fontSize: subtitleFontSize),
                        //     //   ],
                        //     // ),
                        //     // if (order.variation!.size != 'N/A')
                        //     //   Row(
                        //     //     children: [
                        //     //       CustomText("Size: ",
                        //     //           dotsAfterOverFlow: true,
                        //     //           color: Colors.black45,
                        //     //           fontWeight: FontWeight.bold,
                        //     //           fontSize: subtitleFontSize),
                        //     //       horizontalSpaceSmall,
                        //     //       CustomText(order.variation!.size ?? "",
                        //     //           dotsAfterOverFlow: true,
                        //     //           color: Colors.grey,
                        //     //           fontSize: subtitleFontSize),
                        //     //     ],
                        //     //   ),
                        //     verticalSpaceTiny,
                        //     CustomText(
                        //       rupeeUnicode + order.commonField!.orderCost!.cost.toString(),
                        //       dotsAfterOverFlow: true,
                        //       fontSize: titleFontSize,
                        //       isBold: true,
                        //       color: Colors.black54,
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  horizontalSpaceSmall,
                  Icon(
                    Icons.chevron_right,
                    size: 25,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            onTap: () async {
              print("order history");
              await _analyticsService.sendAnalyticsEvent(
                  eventName: "order_history_view",
                  parameters: <String, dynamic>{
                    "order_id": widget.order.productId,
                    "user_id": locator<HomeController>().details!.key,
                    "user_name": locator<HomeController>().details!.name,
                    "user_contact": locator<HomeController>().details!.contact!.phone!.mobile,
                  });
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => MyOrdersDetailsView(widget.order),
                ),
              );
            },
          );
  }
}
