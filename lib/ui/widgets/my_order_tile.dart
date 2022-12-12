import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../constants/server_urls.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/orders.dart';
import '../../services/analytics_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/myorders_details_view.dart';
import '../widgets/custom_text.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/shimmer/shimmer_widget.dart';
import 'shimmer/my_orders_shimmer.dart';

class MyOrdersTile extends StatefulWidget {
  const MyOrdersTile({this.controller, this.loader});
  final dynamic controller;
  final ShimmerWidget? loader;
  MyordersTileState createState() => MyordersTileState();
}

class MyordersTileState extends State<MyOrdersTile> {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Widget build(BuildContext context) {
    List<Widget> myOrderShimmerEffect() => List<Widget>.generate(5, (index) => MyOrdersShimmer());
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: screenPadding, right: screenPadding, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.controller.busy) Column(children: myOrderShimmerEffect()),
            // if (widget.controller.mOrders == null) EmptyListWidget(),
            if (!widget.controller.busy && widget.controller.mOrders != null)
              GroupedListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                elements: widget.controller.mOrders.orders,
                groupBy: (Order o) => o.created!.substring(0, 10),
                groupComparator: (String a, String b) {
                  DateTime aDateTime = DateTime.parse(
                      "${a.substring(6, 10)}${a.substring(3, 5)}${a.substring(0, 2)}");
                  DateTime bDateTime = DateTime.parse(
                      "${b.substring(6, 10)}${b.substring(3, 5)}${b.substring(0, 2)}");
                  return bDateTime.compareTo(aDateTime);
                },
                groupSeparatorBuilder: (String created) {
                  var date = DateFormat.yMMMMd('en_US').format(DateTime.parse(
                      "${created.substring(6, 10)}${created.substring(3, 5)}${created.substring(0, 2)}"));
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Container(
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
                itemBuilder: (BuildContext context, Order order) => GestureDetector(
                  child: Container(
                    height: 130,
                    padding: EdgeInsets.only(left: 12, right: 8),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(curve15),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
                    child: Column(
                      children: [
                        verticalSpaceSmall,
                        Row(
                          children: [
                            Text(
                              order.status!.state ?? "",
                              style: TextStyle(
                                color: (<int>[0, 1, 2, 3, 4, 5, 7].contains(order.status!.id))
                                    ? Colors.black45
                                    : logoRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                            horizontalSpaceSmall,
                            // Text("${order.status!.id}"),
                            Text(
                              (<int>[
                                1,
                                2,
                                3,
                                4,
                                5,
                              ].contains(order.status!.id))
                                  ? 'on ${order.created}'
                                  : (order.status!.id == 7)
                                      ? 'on ${order.deliveryDate}'
                                      : "",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  order.product?.name?.capitalizeFirst ?? "",
                                  isBold: true,
                                  color: Colors.black87,
                                  dotsAfterOverFlow: true,
                                  fontSize: titleFontSize + 2,
                                ),
                                verticalSpaceSmall,
                                Row(
                                  children: [
                                    CustomText("Qty: ",
                                        dotsAfterOverFlow: true,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                        fontSize: subtitleFontSize),
                                    horizontalSpaceSmall,
                                    CustomText((order.orderCost!.quantity ?? 0).toString(),
                                        dotsAfterOverFlow: true,
                                        color: Colors.grey,
                                        fontSize: subtitleFontSize),
                                  ],
                                ),
                                if (order.variation!.size != 'N/A')
                                  Row(
                                    children: [
                                      CustomText("Size: ",
                                          dotsAfterOverFlow: true,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          fontSize: subtitleFontSize),
                                      horizontalSpaceSmall,
                                      CustomText(order.variation!.size ?? "",
                                          dotsAfterOverFlow: true,
                                          color: Colors.grey,
                                          fontSize: subtitleFontSize),
                                    ],
                                  ),
                                verticalSpaceTiny,
                                CustomText(
                                  rupeeUnicode + order.orderCost!.cost.toString(),
                                  dotsAfterOverFlow: true,
                                  fontSize: titleFontSize,
                                  isBold: true,
                                  color: lightGreen,
                                ),
                              ],
                            )),
                            
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(curve15),
                                child: FadeInImage.assetNetwork(
                                  width: 80,
                                  height: 80,
                                  fadeInCurve: Curves.easeIn,
                                  placeholder: "assets/images/product_preloading.png",
                                  image:
                                      "$PRODUCT_PHOTO_BASE_URL/${order.product!.key}/${order.product?.photo?.photos?.first.name ?? 'photo'}-small.png",
                                  imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                                    "assets/images/product_preloading.png",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    print("order history");
                    await _analyticsService.sendAnalyticsEvent(
                        eventName: "order_history_view",
                        parameters: <String, dynamic>{
                          "order_id": order.productId,
                          "user_id": locator<HomeController>().details!.key,
                          "user_name": locator<HomeController>().details!.name,
                          "user_contact": locator<HomeController>().details!.contact!.phone!.mobile,
                        });
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => MyOrdersDetailsView(order),
                      ),
                    );
                  },
                ),
              ),
            if (!widget.controller.busy && widget.controller.mOrders?.orders?.length == 0)
              verticalSpaceLarge,
            if (!widget.controller.busy && widget.controller?.mOrders?.orders?.length == 0)
              EmptyListWidget(),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }
}
