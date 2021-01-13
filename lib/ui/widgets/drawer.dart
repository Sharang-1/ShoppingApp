import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';
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
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.setName(),
        builder: (context, model, child) => Drawer(
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Container(
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
                                  '${model.name}',
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
                              _navigationService.pop();
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
                              _navigationService.navigateTo(CategoriesRoute,
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
                            onTap: () {
                              _navigationService.navigateTo(MapViewRoute,
                                  popNavbar: true);
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
                              _navigationService.navigateTo(
                                  MyAppointmentViewRoute,
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
                              _navigationService.navigateTo(MyOrdersRoute,
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
                              _navigationService.navigateTo(WhishListRoute,
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
                              _navigationService.navigateTo(ProfileViewRoute,
                                  popNavbar: true);
                            },
                          ),
                          Divider(),
                          // ListTile(
                          //   title: Padding(
                          //     padding: EdgeInsets.only(left: 20),
                          //     child: CustomText(
                          //       'Notifications',
                          //       color: Colors.grey[800],
                          //       isBold: true,
                          //       fontSize: 18,
                          //     ),
                          //   ),
                          //   onTap: () {
                          //     _navigationService.navigateTo(
                          //         NotifcationViewRoute,
                          //         popNavbar: true);
                          //   },
                          // ),
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
                              onTap: () =>
                                  launch('https://dzor.in/#/partner-with-us')),
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
                              _navigationService.navigateTo(SettingsRoute,
                                  popNavbar: true);
                            },
                          ),
                          /*ListTile(
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
                  ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
