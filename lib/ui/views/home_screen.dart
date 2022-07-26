import 'package:compound/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../locator.dart';
import '../shared/app_colors.dart';
import '../widgets/cart_icon_badge.dart';
import 'home_view_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.args}) : super(key: key);
  final args;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = locator<HomeController>();

  final GlobalKey searchKey = GlobalKey();

  final GlobalKey cartKey = GlobalKey();

  final GlobalKey logoKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      initState: (state) {
        controller.onRefresh(context: context, args: widget.args);
        controller.showTutorial(context, searchKey: searchKey, logoKey: logoKey);
      },
      builder: (controller) {
        return SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: RefreshIndicator(
            displacement: 10,
            edgeOffset: 50,
            onRefresh: () async {
              await controller.onRefresh();
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.white),
                  backgroundColor: logoRed,
                  actions: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    InkWell(
                      key: searchKey,
                      onTap: () {
                        BaseController.search();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                            // margin: EdgeInsets.only(right: 8.0),
                            padding: EdgeInsets.symmetric(vertical: 2),
                            height: 25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: newBackgroundColor2,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  "assets/images/search.png",
                                  color: Colors.black,
                                ),
                                
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Search for products, designers..",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            )),
                      ),
                    ),
                    Spacer(),
                    Obx(() {
                      return Center(
                        child: InkWell(
                          key: cartKey,
                          child: Container(
                            margin: EdgeInsets.only(right: 12.0),
                            padding: EdgeInsets.all(4.0),
                            // height: 35,
                            // width: 35,
                            decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(radius: 0.7,colors: [Colors.white, logoRed])),
                            child: Center(
                              child: CartIconWithBadge(
                                iconColor: Colors.black,
                                count: locator<CartCountController>().count.value,
                              ),
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
                  pinned: false,
                  primary: false,
                  floating: true,
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
        );
      },
    );
  }
}
