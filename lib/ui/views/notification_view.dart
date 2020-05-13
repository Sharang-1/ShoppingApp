import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:compound/ui/views/cart_payment_method_view.dart';
import 'package:compound/ui/widgets/cart_icon_badge.dart';
import 'package:compound/ui/widgets/custom_stepper.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

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
    4: "Notification 5"
  };
  Map<int, bool> imageAvailableMap = {
    0: true,
    1: false,
    2: true,
    3: true,
    4: false
  };

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundWhiteCreamColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backgroundWhiteCreamColor,
                actions: <Widget>[
                  IconButton(
                    icon: CartIconWithBadge(
                      IconColor: appBarIconColor,
                    ),
                    onPressed: () => model.cart(),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
                iconTheme: IconThemeData(
                  color: appBarIconColor,
                ),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                      child: Padding(
                padding:
                    EdgeInsets.only(left: screenPadding, right: screenPadding, top: 10, bottom: 10),
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
                              fontSize: 30),
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
                                            borderRadius:
                                                BorderRadius.circular(curve15),
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
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 15),
                                              child: CustomText(
                                                notificationMap[key],
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 15),
                                              child: CustomText(
                                                notificationMap[key],
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                    IconButton(
                                      icon: Icon(Icons.keyboard_arrow_right),
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
              ))),
            ));
  }
}
