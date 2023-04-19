import 'package:compound/ui/views/categories_view.dart';
import 'package:compound/ui/views/home_screen.dart';
import 'package:compound/ui/views/myorders_view.dart';
import 'package:compound/ui/views/settings_page_view.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import 'bottom_nav_style.dart';
import 'category_list_page.dart';
import 'product_wishlist_view.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key, this.args}) : super(key: key);

  final args;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final HomeController controller = locator<HomeController>();

  final GlobalKey searchKey = GlobalKey();

  final GlobalKey cartKey = GlobalKey();

  final GlobalKey logoKey = GlobalKey();

  late final VideoPlayerController videoController;

  int _activeIndex = 2;

  @override
  void initState() {
    videoController = VideoPlayerController.asset('assets/videos/test.mp4')
      ..setVolume(0.5);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        controller.onRefresh(context: context, args: widget.args);
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List _screens = [
      CategoryListPage(),
      MyOrdersView(),
      // AllConfettiWidget(child: HomeScreen(args: widget.args)),
      HomeScreen(args: widget.args),
      // MyAppointments(),
      WishList(),
      SettingsView(),
    ];

    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) {
          controller.onRefresh(context: context, args: widget.args);
          controller.showTutorial(context,
              searchKey: searchKey, logoKey: logoKey);
        },
        builder: (controller) {
          return Container(
              color: logoRed,
              child: SafeArea(
                top: true,
                bottom: false,
                child: Scaffold(
                  // floatingActionButton: Container(
                  //     height: 200,
                  //     width: 150,
                  //     child: FlickVideoPlayer(
                  //       flickVideoWithControls: FlickVideoWithControls(
                  //         backgroundColor: Colors.white,
                  //         controls: FlickPortraitControls(),
                  //       ),
                  //       flickManager: FlickManager(
                  //         videoPlayerController: videoController,
                  //         autoPlay: true,
                  //       ),
                  //     )),
                  drawerEdgeDragWidth: 0,
                  primary: true,
                  backgroundColor: Colors.white,
                  bottomNavigationBar: StyleProvider(
                    style: BottomNavigationStyle(),
                    child: ConvexAppBar(
                      style: TabStyle.fixedCircle,
                      color: logoRed,
                      items: [
                        TabItem(
                          title: NAVBAR_CATEGORIES.tr,
                          icon: _activeIndex == 0
                              ? SvgPicture.asset("assets/icons/categ1.svg")
                              : SvgPicture.asset("assets/icons/categ0.svg"),
                        ),
                        TabItem(
                          title: NAVBAR_ORDERS.tr,
                          icon: _activeIndex == 1
                              ? SvgPicture.asset("assets/icons/orders1.svg")
                              : SvgPicture.asset("assets/icons/orders0.svg"),
                        ),
                        TabItem(
                          title: '',
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: backgroundWhiteCreamColor,
                            ),
                            child: Padding(
                              key: logoKey,
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                "assets/images/logo.png",
                                // color: logoRed,
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                        ),
                        TabItem(
                          title: NAVBAR_WISHLIST.tr,
                          icon: _activeIndex == 3
                              ? SvgPicture.asset("assets/icons/wish1.svg")
                              : SvgPicture.asset("assets/icons/wish0.svg"),
                        ),
                        TabItem(
                          title: NAVBAR_PROFILE.tr,
                          icon: _activeIndex == 4
                              ? SvgPicture.asset("assets/icons/profile1.svg")
                              : SvgPicture.asset("assets/icons/profile0.svg"),
                        ),
                      ],
                      backgroundColor: Colors.white,
                      activeColor: logoRed,
                      disableDefaultTabController: true,
                      initialActiveIndex: 2,
                      // onTabNotify: controller.bottomNavigationOnTap,
                      elevation: 5,
                      onTap: (i) async {
                        setState(() {
                          _activeIndex = i;
                        });
                        if (i == 1 || i == 3) {
                          controller.isLoggedIn
                              // ignore: unnecessary_statements
                              ? () {}
                              : await BaseController.showLoginPopup(
                                  nextView: HomeViewRoute,
                                  shouldNavigateToNextScreen: true,
                                );
                        }
                      },
                    ),
                  ),
                  body: _screens[_activeIndex],
                ),
              ));
        });
  }
}
