import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import '../../services/remote_config_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../widgets/cart_icon_badge.dart';
import '../widgets/profile_setup_indicator.dart';
import 'bottom_nav_style.dart';
import 'home_view_list.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key, this.args}) : super(key: key);

  final args;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = locator<HomeController>();

  final GlobalKey searchKey = GlobalKey();

  final GlobalKey cartKey = GlobalKey();

  final GlobalKey logoKey = GlobalKey();

  // @override
  // void dispose() {
  //   controller.refreshController.dispose();
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) {
          controller.onRefresh(context: context, args: widget.args);
          controller.showTutorial(context,
              searchKey: searchKey, logoKey: logoKey);
        },
        builder: (controller) {
          return Scaffold(
            drawerEdgeDragWidth: 0,
            primary: true,
            backgroundColor: Colors.white,
            bottomNavigationBar: StyleProvider(
              style: BottomNavigationStyle(),
              child: ConvexAppBar(
                style: TabStyle.fixedCircle,
                items: [
                  TabItem(
                    title: NAVBAR_CATEGORIES.tr,
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Image.asset(
                        "assets/images/nav_categories.png",
                        color: newBackgroundColor,
                      ),
                    ),
                  ),
                  TabItem(
                    title: NAVBAR_ORDERS.tr,
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Image.asset(
                        "assets/images/nav_orders.png",
                        color: newBackgroundColor,
                      ),
                    ),
                  ),
                  TabItem(
                    title: '',
                    icon: Padding(
                      key: logoKey,
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        "assets/svg/logo.svg",
                        color: logoRed,
                        height: 15,
                        width: 15,
                      ),
                    ),
                  ),
                  TabItem(
                    title: NAVBAR_APPOINTMENTS.tr,
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Image.asset(
                        "assets/images/nav_appointment.png",
                        color: newBackgroundColor,
                      ),
                    ),
                  ),
                  TabItem(
                    title: NAVBAR_MAPS.tr,
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Image.asset(
                        "assets/images/nav_map.png",
                        color: newBackgroundColor,
                      ),
                    ),
                  ),
                ],
                backgroundColor: logoRed,
                activeColor: backgroundWhiteCreamColor,
                disableDefaultTabController: true,
                initialActiveIndex: 2,
                onTabNotify: controller.bottomNavigationOnTap,
                elevation: 5,
              ),
            ),
            body: SafeArea(
              top: true,
              left: false,
              right: false,
              bottom: false,
              child: RefreshIndicator(
                displacement: 10,
                edgeOffset: 50,

                // enablePullDown: true,
                // footer: Container(),
                // header: WaterDropHeader(
                //   waterDropColor: logoRed,
                //   refresh: Center(
                //     child: Image.asset(
                //       "assets/images/loading_img.gif",
                //       height: 25,
                //       width: 25,
                //     ),
                //   ),
                //   complete: Container(),
                // ),
                // controller: controller.refreshController,
                onRefresh: () async {
                  await controller.onRefresh();
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.grey.shade900),
                      backgroundColor: Colors.white,
                      title: InkWell(
                        onTap: () {
                          controller.onCityNameTap();
                        },
                        child: Column(
                          children: [
                            Text(
                              HOMESCREEN_LOCATION.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              "${controller.cityName.capitalize ?? ''}",
                              style: TextStyle(
                                fontSize: 16,
                                color: textIconBlue,
                              ),
                            )
                          ],
                        ),
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
                          key: searchKey,
                          onTap: () {
                            BaseController.search();
                          },
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
                        icon: Stack(
                          children: [
                            Image.asset(
                              "assets/images/profile_m.png",
                              color: Colors.grey.shade900,
                            ),
                            if (!controller.isProfileComplete)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: ProfileSetupIndicator(),
                              ),
                          ],
                        ),
                        onPressed: () => NavigationService.to(SettingsRoute),
                      ),
                      actions: <Widget>[
                        Obx(() {
                          return Center(
                            child: InkWell(
                              key: cartKey,
                              child: Container(
                                margin: EdgeInsets.only(right: 12.0),
                                padding: EdgeInsets.all(4.0),
                                height: 35,
                                width: 35,
                                child: CartIconWithBadge(
                                  iconColor: Colors.grey.shade900,
                                  count: locator<CartCountController>()
                                      .count
                                      .value,
                                ),
                              ),
                              onTap: () async {
                                controller.isLoggedIn
                                    ? await BaseController.cart()
                                    : await BaseController.showLoginPopup(
                                        nextView: CartViewRoute,
                                        shouldNavigateToNextScreen: true,
                                      );
                              },
                            ),
                          );
                        }),
                      ],
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Use Code 💥1STOFMANY💥 while checkout",
                          // "${controller.remoteConfig!.getString(HOMESCREEN_APPBAR_TEXT)}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
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
          );
        });
  }
}
