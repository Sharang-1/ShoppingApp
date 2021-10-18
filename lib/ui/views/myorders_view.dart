import 'package:compound/ui/widgets/my_order_tile.dart';
import 'package:compound/ui/widgets/section_builder.dart';
import 'package:compound/ui/widgets/shimmer/my_orders_shimmer.dart';
import 'package:compound/utils/lang/translation_keys.dart';
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
import '../widgets/shimmer/shimmer_widget.dart';
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
              SETTINGS_MY_ORDER.tr,
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
                  child: Center(
                    child: Image.asset(
                      "assets/images/loading_img.gif",
                      height: 25,
                      width: 25,
                    ),
                  ),
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
              child: MyOrdersTile(controller: controller),
            ),
          ),
        ),
      );
}
