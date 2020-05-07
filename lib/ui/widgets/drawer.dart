import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('DZOR'),
            onTap: null,
            enabled: false,
          ),
          Divider(),
          ListTile(
            title: Text('Categories'),
            onTap: () {
              _navigationService.navigateTo(CategoriesRoute);
            },
          ),
          Divider(),
          ListTile(
            title: Text('My Orders'),
            onTap: () {
              _navigationService.navigateTo(MyOrdersRoute);
            },
          ),
          ListTile(
            title: Text('Cart'),
            onTap: () {
              // _navigationService.navigateTo(routeName)
            },
          ),
          ListTile(
            title: Text('Wishlist'),
            onTap: () {
              // _navigationService.navigateTo(routeName)
            },
          ),
          Divider(),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              // _navigationService.navigateTo(routeName)
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // _navigationService.navigateTo(routeName)
            },
          ),
        ],
      ),
    );
  }
}
