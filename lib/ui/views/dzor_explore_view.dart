
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/dzor_explore_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import '../widgets/cart_icon_badge.dart';
import '../widgets/custom_text.dart';
import '../widgets/section_builder.dart';

class DzorExploreView extends StatefulWidget {
  @override
  _DzorExploreViewState createState() => _DzorExploreViewState();
}

class _DzorExploreViewState extends State<DzorExploreView> {
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    // try {
    //   locator<AnalyticsService>().sendAnalyticsEvent(
    //       eventName: "dzor_explore_view",
    //       parameters: <String, dynamic>{
    //         "user_id": locator<HomeController>().details!.key,
    //         "user_name": locator<HomeController>().details!.name,
    //       });
    // } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DzorExploreController>(
      global: false,
      init: DzorExploreController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.expand_more),
            iconSize: 40,
            onPressed: () => NavigationService.back(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/images/wishlist.png",
                color: Colors.grey.shade900,
              ),
              onPressed: () async => locator<HomeController>().isLoggedIn
                  ? await BaseController.gotoWishlist()
                  : await BaseController.showLoginPopup(
                      nextView: WishListRoute,
                      shouldNavigateToNextScreen: true,
                    ),
            ),
            Obx(
              () => IconButton(
                icon: CartIconWithBadge(
                  iconColor: Colors.grey.shade900,
                  count: locator<CartCountController>().count.value,
                ),
                onPressed: () async => locator<HomeController>().isLoggedIn
                    ? await BaseController.cart()
                    : await BaseController.showLoginPopup(
                        nextView: CartViewRoute,
                        shouldNavigateToNextScreen: true,
                      ),
              ),
            ),
          ],
          centerTitle: true,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo_red.png",
                    height: 20,
                    width: 20,
                  ),
                  horizontalSpaceSmall,
                  Text(
                    "Dzor Explore",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CustomText(
                "Explore Best Listings on Dzor",
                fontSize: 10,
              ),
            ],
          ),
          iconTheme: IconThemeData(color: appBarIconColor),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
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
              child: SingleChildScrollView(

                child: Column(
                  children: [

                    SectionBuilder(
                      context: context,
                      header: SectionHeader(title: RECOMMENDED_DESIGNERS.tr, subTitle: " "),
                      onEmptyList: () {},
                      layoutType: LayoutType.EXPLORE_DESIGNER_LAYOUT,
                      scrollDirection: Axis.horizontal,
                      controller: SellersGridViewBuilderController(
                          random: true, removeId: ''),
                    ),
                    verticalSpaceSmall,

                    SectionBuilder(
                      context: context,
                      // header: SectionHeader(title: " ", subTitle: " "),
                      layoutType: LayoutType.PRODUCT_LAYOUT_3,
                      onEmptyList: () {},
                      scrollDirection: Axis.vertical,
                      controller: ProductsGridViewBuilderController(
                          randomize: true, limit: 100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
