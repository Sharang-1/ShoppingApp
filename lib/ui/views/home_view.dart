import 'package:compound/ui/views/categories_view.dart';
import 'package:compound/ui/views/home_screen.dart';
import 'package:compound/ui/views/myAppointments_view.dart';
import 'package:compound/ui/views/myorders_view.dart';
import 'package:compound/ui/views/settings_page_view.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import 'bottom_nav_style.dart';

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

int _activeIndex = 2;

  @override
  Widget build(BuildContext context) {
  List _screens = [CategoriesView(),MyOrdersView(), HomeScreen(args: widget.args), MyAppointments(), SettingsView()];

    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) {
          controller.onRefresh(context: context, args: widget.args);
          controller.showTutorial(context, searchKey: searchKey, logoKey: logoKey);
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
                    decoration: BoxDecoration(shape: BoxShape.circle,
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
                    title: NAVBAR_APPOINTMENTS.tr,
                    icon: _activeIndex == 3
                        ? SvgPicture.asset("assets/icons/appointment1.svg")
                        : SvgPicture.asset("assets/icons/appointment0.svg"),
                  ),
                 
                  TabItem(
                    title: NAVBAR_PROFILE.tr,
                    icon: _activeIndex==4? SvgPicture.asset("assets/icons/profile1.svg"): SvgPicture.asset("assets/icons/profile0.svg"),
                  ),
                ],
                backgroundColor: Colors.white,
                activeColor: logoRed,
                disableDefaultTabController: true,
                initialActiveIndex: 2,
                // onTabNotify: controller.bottomNavigationOnTap,
                elevation: 5,
                onTap: (i)=> setState(() {
                  _activeIndex = i;
                }),
              ),
            ),
            body: _screens[_activeIndex],
          );
        });
  }
}
