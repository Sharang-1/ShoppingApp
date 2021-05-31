import 'package:compound/constants/route_names.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import '../widgets/cart_icon_badge.dart';
import 'home_view_list.dart';

class HomeView extends StatelessWidget {
  HomeView({Key key}) : super(key: key);

  final HomeController controller =
      locator<HomeController>(tag: 'HomeController');

  final GlobalKey searchBarKey = GlobalKey();
  final GlobalKey cartKey = GlobalKey();
  final GlobalKey logoKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) {
          controller.onRefresh();
          controller.showTutorial(context,
              searchBarKey: searchBarKey, logoKey: logoKey);
        },
        builder: (controller) {
          return Scaffold(
            drawerEdgeDragWidth: 0,
            primary: false,
            backgroundColor: backgroundWhiteCreamColor,
            // drawer: HomeDrawer(
            //   logout: () => BaseController.logout(),
            // ),
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
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: appBarIconColor),
              backgroundColor: backgroundWhiteCreamColor,
              bottom: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).padding.top),
                child: AppBar(
                  elevation: 0,
                  iconTheme: IconThemeData(color: appBarIconColor),
                  backgroundColor: backgroundWhiteCreamColor,
                  title: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: SvgPicture.asset(
                        "assets/svg/logo.svg",
                        key: logoKey,
                        color: logoRed,
                        height: 35,
                        width: 35,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => BaseController.gotoSettingsPage(),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () => NavigationService.to(ProfileViewRoute),
                    ),
                    Obx(
                      () => IconButton(
                        key: cartKey,
                        icon: CartIconWithBadge(
                          iconColor: appBarIconColor,
                          count: locator<CartCountController>().count.value,
                        ),
                        onPressed: () => BaseController.cart(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              top: false,
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
                      primary: false,
                      floating: true,
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(color: appBarIconColor),
                      backgroundColor: backgroundWhiteCreamColor,
                      // pinned: true,
                      // actions: <Widget>[
                      //   IconButton(
                      //     tooltip: 'map',
                      //     // icon: Image.asset("assets/images/map.png"),
                      //     icon: Icon(
                      //       FontAwesomeIcons.mapMarkerAlt,
                      //     ),
                      //     onPressed: () {
                      //       BaseController.openmap();
                      //     },
                      //   )
                      // ],
                      actions: [
                        IconButton(
                          icon:
                              Icon(FontAwesomeIcons.solidHeart, color: logoRed),
                          onPressed: () => BaseController.gotoWishlist(),
                        )
                      ],
                      title: InkWell(
                        key: searchBarKey,
                        onTap: () => BaseController.search(),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: backgroundBlueGreyColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  color: appBarIconColor,
                                ),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        "Designers or their Creations",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[600],
                                            fontFamily: "Raleway",
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
