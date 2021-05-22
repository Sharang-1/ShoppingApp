import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';

class HomeDrawer extends StatelessWidget {
  final Function logout;

  HomeDrawer({Key key, this.logout}) : super(key: key);

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Name);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: locator<HomeController>(tag: "HomeController"),
      builder: (controller) => FutureBuilder<Object>(
        future: controller.setName(),
        builder: (context, snapshot) {
          return Drawer(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      NavigationService.to(ProfileViewRoute, popNavbar: true);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      color: logoRed,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 50,
                          ),
                          horizontalSpaceSmall,
                          horizontalSpaceSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  'Hello,',
                                  color: Colors.white,
                                  isBold: true,
                                  fontSize: 18,
                                  dotsAfterOverFlow: true,
                                ),
                                verticalSpace(3),
                                CustomText(
                                  '${controller.name}',
                                  color: Colors.white,
                                  isBold: true,
                                  fontSize: 18,
                                  dotsAfterOverFlow: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 10,
                        color: logoRed,
                      ),
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(curve15),
                              topRight: Radius.circular(curve15),
                            )),
                      )
                    ],
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'Home',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.back();
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'Categories',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.to(CategoriesRoute,
                                popNavbar: true);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'Dzor Map',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () async {
                            var status = await Location().requestPermission();
                            if (status == PermissionStatus.GRANTED) {
                              NavigationService.to(MapViewRoute,
                                  popNavbar: true);
                            }
                            return;
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'My Appointments',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.to(MyAppointmentViewRoute,
                                popNavbar: true);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'My Orders',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.to(MyOrdersRoute,
                                popNavbar: true);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'Wishlist',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.to(WishListRoute,
                                popNavbar: true);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'My Profile',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.to(ProfileViewRoute,
                                popNavbar: true);
                          },
                        ),
                        Divider(),
                        ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: CustomText(
                                'Sell On Dzor',
                                color: Colors.grey[800],
                                isBold: true,
                                fontSize: 18,
                              ),
                            ),
                            onTap: () => launch(PARTNER_WITH_US_URL)),
                        ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: CustomText(
                              'Settings',
                              color: Colors.grey[800],
                              isBold: true,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            NavigationService.to(SettingsRoute,
                                popNavbar: true);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
