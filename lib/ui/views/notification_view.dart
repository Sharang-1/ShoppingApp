import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

import '../../viewmodels/home_view_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  Map<int, String> notificationMap = {
    0: "Notification 1 is to inform about ur doings and outings ",
    1: "Notification 2 Notification 1 is to inform about ur doings and outings ",
    2: "Notification 3",
    3: "Notification 4",
    4: "Notification 5",
    5: "Notification 2 Notification 1 is to inform about ur doings and outings ",
    6: "Notification 3",
    7: "Notification 4",
    8: "Notification 5"
  };
  Map<int, bool> imageAvailableMap = {
    0: true,
    1: false,
    2: true,
    3: true,
    4: false,
    5: true,
    6: false,
    7: true,
    8: true,
  };

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundWhiteCreamColor,
              body: SafeArea(
                  child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  floating: true,
                  snap: true,
                  backgroundColor: backgroundWhiteCreamColor,
                  centerTitle: true,
                  iconTheme: IconThemeData(color: appBarIconColor),
                ),
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => childWidget(),
                    childCount: 1,
                  ),
                ),
                //
              ])),
            ));
  }

  Widget childWidget() {
    const double headingFontSize = headingFontSizeStyle + 5;
    const double subtitleFontSize = subtitleFontSizeStyle - 2;
    return Padding(
      padding: EdgeInsets.only(
          left: screenPadding, right: screenPadding, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          verticalSpace(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Notifications",
                style: TextStyle(
                    fontFamily: headingFont,
                    fontWeight: FontWeight.w700,
                    fontSize: headingFontSize),
              ),
              Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeTrackColor: darkRedSmooth.withOpacity(0.37),
                  activeColor: darkRedSmooth)
            ],
          ),
          verticalSpace(20),
          Column(
            children: notificationMap.keys.map((int key) {
              return Container(
                  margin: EdgeInsets.only(bottom: spaceBetweenCards),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(curve15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          imageAvailableMap[key]
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(curve15),
                                  child: FadeInImage.assetNetwork(
                                    width: 50,
                                    height: 50,
                                    fadeInCurve: Curves.easeIn,
                                    placeholder:
                                        "assets/images/placeholder.png",
                                    image:
                                        "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                    fit: BoxFit.fill,
                                  ))
                              : Container(),
                          imageAvailableMap[key]
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 15),
                                    child: CustomText(
                                      notificationMap[key],
                                      fontSize: subtitleFontSize,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, left: 15),
                                    child: CustomText(
                                      notificationMap[key],
                                      fontSize: subtitleFontSize,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            color: Colors.grey,
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ));
            }).toList(),
          )
        ],
      ),
    );
  }
}
