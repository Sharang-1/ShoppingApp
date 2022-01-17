import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../constants/server_urls.dart';
import '../../models/orders.dart';
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
  Widget build(BuildContext context) {
    List<Widget> myOrderShimmerEffect() =>
        List<Widget>.generate(5, (index) => MyOrdersShimmer());
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: screenPadding, right: screenPadding, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.controller.busy)
              Column(children: myOrderShimmerEffect()),
            //widget.loader,
            // Image.asset(
            //   "assets/images/loading_img.gif",
            //   height: 50,
            //   width: 50,
            // ),
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                itemBuilder: (BuildContext context, Order order) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 180,
                    child: GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(curve15),
                        ),
                        elevation: 0,
                        child: Container(
                          child: Column(
                            children: [
                              verticalSpaceSmall,
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.status!.state ?? "",
                                          style: TextStyle(
                                            color: (<int>[0, 1, 2, 3, 4, 5, 7]
                                                    .contains(order.status!.id))
                                                ? Color(0xFF17a17f)
                                                : logoRed,
                                            fontWeight: FontWeight.bold,
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
                                          ].contains(order.status!.id))
                                              ? 'on ${order.created}'
                                              : (order.status!.id == 7)
                                                  ? 'on ${order.deliveryDate}'
                                                  : "",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(curve15),
                                      child: FadeInImage.assetNetwork(
                                        width: 100,
                                        height: 100,
                                        fadeInCurve: Curves.easeIn,
                                        placeholder:
                                            "assets/images/product_preloading.png",
                                        image:
                                            "$PRODUCT_PHOTO_BASE_URL/${order.product!.key}/${order.product?.photo?.photos?.first.name ?? 'photo'}-small.png",
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
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
                                        order.product!.name!.capitalizeFirst ??
                                            "",
                                        isBold: true,
                                        color: Colors.grey[800]!,
                                        dotsAfterOverFlow: true,
                                        fontSize: titleFontSize + 4,
                                      ),
                                      verticalSpaceSmall,
                                      Row(
                                        children: [
                                          CustomText("Qty: ",
                                              dotsAfterOverFlow: true,
                                              color: Colors.black54,
                                              fontSize: subtitleFontSize),
                                          horizontalSpaceSmall,
                                          CustomText(
                                              (order.orderCost!.quantity ?? 0)
                                                  .toString(),
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
                                                color: Colors.black54,
                                                fontSize: subtitleFontSize),
                                            horizontalSpaceSmall,
                                            CustomText(
                                                order.variation!.size ?? "",
                                                dotsAfterOverFlow: true,
                                                color: Colors.grey,
                                                fontSize: subtitleFontSize),
                                          ],
                                        ),
                                      verticalSpaceTiny,
                                      CustomText(
                                        rupeeUnicode +
                                            order.orderCost!.cost.toString(),
                                        dotsAfterOverFlow: true,
                                        fontSize: titleFontSize,
                                        isBold: true,
                                        color: textIconOrange,
                                      ),
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
                            builder: (context) => MyOrdersDetailsView(order),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            if (!widget.controller.busy &&
                widget.controller.mOrders?.orders?.length == 0)
              verticalSpaceLarge,
            if (!widget.controller.busy &&
                widget.controller?.mOrders?.orders?.length == 0)
              EmptyListWidget(),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }
}
