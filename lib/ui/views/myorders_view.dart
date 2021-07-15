import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/orders_controller.dart';
import '../../models/orders.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import '../widgets/grid_list_widget.dart';
import 'myorders_details_view.dart';

class MyOrdersView extends StatefulWidget {
  @override
  _MyOrdersViewState createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  double subtitleFontSize = subtitleFontSizeStyle - 2;
  double titleFontSize = subtitleFontSizeStyle;
  double headingFontSize = headingFontSizeStyle;

  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) => GetBuilder(
        init: OrdersController()..getOrders(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "My Orders",
              style: TextStyle(
                fontFamily: headingFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                iconSize: 30,
                icon: Image.asset(
                  "assets/images/wishlist.png",
                ),
                onPressed: () {
                  NavigationService.to(WishListRoute);
                },
              )
            ],
            iconTheme: IconThemeData(color: appBarIconColor),
          ),
          backgroundColor: newBackgroundColor,
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            child: SmartRefresher(
              enablePullDown: true,
              footer: null,
              header: WaterDropHeader(
                waterDropColor: logoRed,
                refresh: Center(
                  child: CircularProgressIndicator(),
                ),
                complete: Container(),
              ),
              controller: refreshController,
              onRefresh: () async {
                setState(() {
                  key = UniqueKey();
                });
                await Future.delayed(Duration(milliseconds: 100));
                refreshController.refreshCompleted(resetFooterState: true);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenPadding,
                      right: screenPadding,
                      top: 10,
                      bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     TextButton(
                      //       child: CustomText(
                      //         "Wishlist",
                      //         fontFamily: headingFont,
                      //         isBold: true,
                      //         fontSize: subtitleFontSize,
                      //         color: logoRed,
                      //       ),
                      //       onPressed: () {
                      //         NavigationService.to(WishListRoute);
                      //       },
                      //     )
                      //   ],
                      // ),
                      // verticalSpace(10),
                      if (controller.busy)
                        Image.asset(
                          "assets/images/loading_img.gif",
                          height: 50,
                          width: 50,
                        ),
                      if (!controller.busy && controller.mOrders != null)
                        GroupedListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          elements: controller.mOrders.orders,
                          groupBy: (Order o) => o.created.substring(0, 10),
                          groupComparator: (String a, String b) {
                            DateTime aDateTime = DateTime.parse(
                                "${a.substring(6, 10)}${a.substring(3, 5)}${a.substring(0, 2)}");
                            DateTime bDateTime = DateTime.parse(
                                "${b.substring(6, 10)}${b.substring(3, 5)}${b.substring(0, 2)}");
                            return bDateTime.compareTo(aDateTime);
                          },
                          groupSeparatorBuilder: (String created) {
                            var date = DateFormat.yMMMMd('en_US').format(
                                DateTime.parse(
                                    "${created.substring(6, 10)}${created.substring(3, 5)}${created.substring(0, 2)}"));
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey[400]),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  // decoration: BoxDecoration(
                                  // color: logoRed,
                                  // borderRadius: BorderRadius.circular(15),
                                  // ),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: logoRed,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemBuilder: (BuildContext context, Order order) =>
                              Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              height: 180,
                              child: GestureDetector(
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(curve15),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        verticalSpaceSmall,
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Row(
                                            children: [
                                              // Container(
                                              //   child: Icon(
                                              //     Icons.cloud_done,
                                              //     color: Color(0xFF17a17f),
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   width: 15.0,
                                              // ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    order.status.state,
                                                    style: TextStyle(
                                                      color: (<int>[
                                                        0,
                                                        1,
                                                        2,
                                                        3,
                                                        4,
                                                        5,
                                                        7
                                                      ].contains(
                                                              order.status.id))
                                                          ? Color(0xFF17a17f)
                                                          : logoRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    (<int>[
                                                      1,
                                                      2,
                                                      3,
                                                      4,
                                                      5,
                                                    ].contains(order.status.id))
                                                        ? 'on ${order.created}'
                                                        : (order.status.id == 7)
                                                            ? 'on ${order.deliveryDate}'
                                                            : "",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        curve15),
                                                child: FadeInImage.assetNetwork(
                                                  width: 100,
                                                  height: 100,
                                                  fadeInCurve: Curves.easeIn,
                                                  placeholder:
                                                      "assets/images/product_preloading.png",
                                                  image:
                                                      "$PRODUCT_PHOTO_BASE_URL/${order.product.key}/${order?.product?.photo?.photos?.first?.name ?? 'photo'}-small.png",
                                                  imageErrorBuilder: (context,
                                                          error, stackTrace) =>
                                                      Image.asset(
                                                    "assets/images/product_preloading.png",
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            horizontalSpaceTiny,
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CustomText(
                                                  order.product.name
                                                      .capitalizeFirst,
                                                  isBold: true,
                                                  color: Colors.grey[800],
                                                  dotsAfterOverFlow: true,
                                                  fontSize: titleFontSize + 4,
                                                ),
                                                verticalSpaceSmall,
                                                Row(
                                                  children: [
                                                    CustomText("Qty: ",
                                                        dotsAfterOverFlow: true,
                                                        color: Colors.black54,
                                                        fontSize:
                                                            subtitleFontSize),
                                                    horizontalSpaceSmall,
                                                    CustomText(
                                                        order.orderCost.quantity
                                                            .toString(),
                                                        dotsAfterOverFlow: true,
                                                        color: Colors.grey,
                                                        fontSize:
                                                            subtitleFontSize),
                                                  ],
                                                ),
                                                if (order.variation.size !=
                                                    'N/A')
                                                  Row(
                                                    children: [
                                                      CustomText("Size: ",
                                                          dotsAfterOverFlow:
                                                              true,
                                                          color: Colors.black54,
                                                          fontSize:
                                                              subtitleFontSize),
                                                      horizontalSpaceSmall,
                                                      CustomText(
                                                          order.variation.size,
                                                          dotsAfterOverFlow:
                                                              true,
                                                          color: Colors.grey,
                                                          fontSize:
                                                              subtitleFontSize),
                                                    ],
                                                  ),
                                                verticalSpaceTiny,
                                                CustomText(
                                                  rupeeUnicode +
                                                      order.orderCost.cost
                                                          .toString(),
                                                  dotsAfterOverFlow: true,
                                                  fontSize: titleFontSize,
                                                  isBold: true,
                                                  color: textIconOrange,
                                                ),
                                                // CustomText(
                                                //   order.status.state,
                                                //   fontSize: subtitleFontSize,
                                                //   isBold: true,
                                                //   color: Colors.grey,
                                                // ),
                                              ],
                                            )),
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {},
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) =>
                                          MyOrdersDetailsView(order),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      if (!controller.busy &&
                          controller.mOrders?.orders?.length == 0)
                        verticalSpaceLarge,
                      if (!controller.busy &&
                          controller?.mOrders?.orders?.length == 0)
                        EmptyListWidget(),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
