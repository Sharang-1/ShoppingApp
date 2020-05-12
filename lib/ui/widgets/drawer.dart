import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text.dart';
import '../shared/app_colors.dart';

class HomeDrawer extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              color: textIconBlue,
              child: CustomText(
                'Hello ,\n Rohan',
                color: Colors.white,
                isBold: true,
                fontSize: 18,
                dotsAfterOverFlow: true,
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 10),
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
                padding: EdgeInsets.only(left: 10),
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
                padding: EdgeInsets.only(left: 10),
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
                padding: EdgeInsets.only(left: 10),
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
                padding: EdgeInsets.only(left: 10),
                child: CustomText(
                  'Cart',
                  color: Colors.grey[800],
                  isBold: true,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                _navigationService.navigateTo(CartViewRoute);
              },
            ),
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 10),
                child: CustomText(
                  'Wishlist',
                  color: Colors.grey[800],
                  isBold: true,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // _navigationService.navigateTo(routeName)
              },
            ),
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 10),
                child: CustomText(
                  'Profile',
                  color: Colors.grey[800],
                  isBold: true,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // _navigationService.navigateTo(routeName)
              },
            ),
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 10),
                child: CustomText(
                  'My Appoinments',
                  color: Colors.grey[800],
                  isBold: true,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // _navigationService.navigateTo(routeName)
              },
            ),
            Divider(),
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 10),
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
                padding: EdgeInsets.only(left: 10),
                child: CustomText(
                  'Sell On Dzor',
                  color: Colors.grey[800],
                  isBold: true,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // _navigationService.navigateTo(routeName)
              },
            ),
            ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 10),
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
          ],
        ),
      ),
    );
  }
}
