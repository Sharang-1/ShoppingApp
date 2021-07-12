import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import '../../services/remote_config_service.dart';
import '../shared/app_colors.dart';
import '../widgets/cart_icon_badge.dart';
import 'home_view_list.dart';

class HomeView extends StatelessWidget {
  HomeView({Key key}) : super(key: key);

  final HomeController controller = locator<HomeController>();

  final GlobalKey searchBarKey = GlobalKey();
  final GlobalKey cartKey = GlobalKey();
  final GlobalKey logoKey = GlobalKey();

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        init: controller,
        initState: (state) {
          controller.onRefresh();
          controller.showTutorial(context,
              searchBarKey: searchBarKey, logoKey: logoKey);
        },
        builder: (controller) => Scaffold(
          drawerEdgeDragWidth: 0,
          primary: true,
          backgroundColor: Colors.white,
          bottomNavigationBar: ConvexAppBar(
            style: TabStyle.fixedCircle,
            items: controller.navigationItems,
            backgroundColor: logoRed,
            activeColor: backgroundWhiteCreamColor,
            disableDefaultTabController: true,
            initialActiveIndex: 2,
            onTabNotify: controller.bottomNavigationOnTap,
            elevation: 5,
          ),
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            bottom: false,
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
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.grey.shade900),
                    backgroundColor: Colors.white,
                    title: Column(
                      children: [
                        Text(
                          "You Are In".toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          "${controller.cityName.capitalize}",
                          style: TextStyle(
                            fontSize: 16,
                            color: textIconBlue,
                          ),
                        )
                      ],
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Image.asset(
                        "assets/images/wishlist.png",
                        color: Colors.grey.shade900,
                      ),
                      onPressed: controller.isLoggedIn
                          ? BaseController.gotoWishlist
                          : () async => await BaseController.showLoginPopup(
                                nextView: WishListRoute,
                                shouldNavigateToNextScreen: true,
                              ),
                    ),
                    actions: <Widget>[
                      InkWell(
                        key: searchBarKey,
                        onTap: BaseController.search,
                        child: Container(
                          margin: EdgeInsets.only(right: 8.0),
                          padding: EdgeInsets.all(4.0),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: logoRed,
                          ),
                          child: Image.asset(
                            "assets/images/search.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                    pinned: false,
                    primary: false,
                  ),
                  SliverAppBar(
                    primary: true,
                    automaticallyImplyLeading: false,
                    iconTheme: IconThemeData(color: appBarIconColor),
                    backgroundColor: Colors.white,
                    pinned: true,
                    leading: IconButton(
                      icon: Image.asset(
                        "assets/images/profile_m.png",
                        color: Colors.grey.shade900,
                      ),
                      onPressed: () => NavigationService.to(SettingsRoute),
                    ),
                    actions: <Widget>[
                      Obx(
                        () => Center(
                          child: InkWell(
                            key: cartKey,
                            child: Container(
                              margin: EdgeInsets.only(right: 12.0),
                              padding: EdgeInsets.all(4.0),
                              height: 35,
                              width: 35,
                              child: CartIconWithBadge(
                                iconColor: Colors.grey.shade900,
                                count:
                                    locator<CartCountController>().count.value,
                              ),
                            ),
                            onTap: () async => controller.isLoggedIn
                                ? await BaseController.cart()
                                : await BaseController.showLoginPopup(
                                    nextView: CartViewRoute,
                                    shouldNavigateToNextScreen: true,
                                  ),
                          ),
                        ),
                      ),
                    ],
                    title: Text(
                      "${controller.remoteConfig.getString(HOMESCREEN_APPBAR_TEXT)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: HomeViewList(
                          controller: controller,
                          productUniqueKey: controller.productKey,
                          sellerUniqueKey: controller.sellerKey,
                          categoryUniqueKey: controller.categoryKey,
                        ),
                      ),
                      childCount: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
