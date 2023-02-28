import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../app/app.dart';
import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/orders_controller.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../widgets/my_order_tile.dart';

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
          backgroundColor: newBackgroundColor2,
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            child: App.isUserLoggedIn == false
                ? Center(
                    child: Column(children: [
                      Text("Login to view order history"),
                      Image.asset("assets/images/empty_cart.png"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: lightGreen,
                          elevation: 0,
                        ),
                        onPressed: () async {
                          await BaseController.showLoginPopup(
                            nextView: HomeViewRoute,
                            shouldNavigateToNextScreen: true,
                          );
                        },
                        child: Text("Login"),
                      ),
                    ]),
                  )
                : SmartRefresher(
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
                      refreshController.refreshCompleted(
                          resetFooterState: true);
                    },
                    child: MyOrdersTile(controller: controller),
                  ),
          ),
        ),
      );
}
