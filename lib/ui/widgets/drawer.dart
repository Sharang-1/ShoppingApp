import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_text.dart';
import '../shared/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  final Function logout;

  HomeDrawer({Key key, this.logout}) : super(key: key);

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(Name);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                    child: FutureBuilder(
                      future: getName(),
                      builder: (c, s) =>
                          s.connectionState == ConnectionState.done
                              ? Column(
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
                                      s.data,
                                      color: Colors.white,
                                      isBold: true,
                                      fontSize: 18,
                                      dotsAfterOverFlow: true,
                                    ),
                                  ],
                                )
                              : Container(),
                    ),
                  ),
                ],
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
                      _navigationService.navigateTo(HomeViewRoute);
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
                      _navigationService.navigateTo(CategoriesRoute);
                    },
                  ),
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CustomText(
                        'Map',
                        color: Colors.grey[800],
                        isBold: true,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      _navigationService.navigateTo(MapViewRoute);
                    },
                  ),
                  Divider(),
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
                      _navigationService.navigateTo(MyOrdersRoute);
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
                      _navigationService.navigateTo(WhishListRoute);
                    },
                  ),
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CustomText(
                        'Profile',
                        color: Colors.grey[800],
                        isBold: true,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      _navigationService.navigateTo(ProfileViewRoute);
                    },
                  ),
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
                      _navigationService.navigateTo(MyAppointmentViewRoute);
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CustomText(
                        'Notifications',
                        color: Colors.grey[800],
                        isBold: true,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      _navigationService.navigateTo(NotifcationViewRoute);
                    },
                  ),
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
                      onTap: () => launch('https://dzor.in/#/partner-with-us')
                  ),
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
                      _navigationService.navigateTo(SettingsRoute);
                    },
                  ),
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CustomText(
                        'Logout',
                        color: Colors.grey[800],
                        isBold: true,
                        fontSize: 18,
                      ),
                    ),
                    onTap: logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
