import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_appstore/open_appstore.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/user_details_controller.dart';
import '../../locator.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/bottom_tag.dart';
import '../widgets/custom_text.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key key}) : super(key: key);

  final Map<int, String> sections = {
    1: "Connect With Us",
    2: "Leave a Review",
    3: "About Us"
  };

  final Map<int, String> settingNameMap = {
    1: "Rate The App",
    2: "Send Feedback",
    3: "Customer Service",
    4: "Terms & Conditions",
    5: "Share with friends",
  };

  final Map<int, IconData> settingIconMap = {
    1: FontAwesomeIcons.solidStar,
    2: FontAwesomeIcons.bookOpen,
    3: FontAwesomeIcons.phoneVolume,
    4: FontAwesomeIcons.solidNewspaper,
    5: Platform.isIOS ? CupertinoIcons.share : Icons.share,
  };

  final Map<int, void Function()> settingOnTapMap = {
    1: () => OpenAppstore.launch(
        androidAppId: "in.dzor.dzor_app", iOSAppId: "1562083632"),
    2: () => OpenAppstore.launch(
        androidAppId: "in.dzor.dzor_app", iOSAppId: "1562083632"),
    3: () => BaseController.launchURL(CONTACT_US_URL),
    4: () => BaseController.launchURL(TERMS_AND_CONDITIONS_URL),
    5: BaseController.shareApp,
  };

  final Map<int, List<int>> sectionsSettingsMap = {
    1: [2, 3, 5],
    2: [1],
    3: [4]
  };

  final AppBar appbar = AppBar(
    elevation: 0,
    // centerTitle: true,
    title: Text(
      "Settings",
      style: TextStyle(
        fontFamily: headingFont,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.black,
      ),
      // textAlign: TextAlign.center,
    ),
    iconTheme: IconThemeData(
      color: appBarIconColor,
    ),
    backgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) => GetBuilder<UserDetailsController>(
        init: UserDetailsController()..getUserDetails(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: newBackgroundColor,
            appBar: appbar,
            body: SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: false,
              child: SingleChildScrollView(
                child: BottomTag(
                  appBarHeight: appbar.preferredSize.height,
                  statusBarHeight: MediaQuery.of(context).padding.top,
                  childWidget: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (locator<HomeController>().isLoggedIn)
                                return await NavigationService.to(
                                  ProfileViewRoute,
                                  arguments: controller,
                                );
                              await BaseController.showLoginPopup(
                                nextView: ProfileViewRoute,
                                shouldNavigateToNextScreen: false,
                              );
                              await controller.getUserDetails();
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: FadeInImage(
                                          width: 50,
                                          height: 50,
                                          fadeInCurve: Curves.easeIn,
                                          placeholder: AssetImage(
                                              "assets/icons/user.png"),
                                          image: NetworkImage(
                                              "$USER_PROFILE_PHOTO_BASE_URL/${controller?.mUserDetails?.key}",
                                              headers: {
                                                "Authorization":
                                                    "Bearer ${controller?.token ?? ''}",
                                              }),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            print(
                                                "User Photo: $USER_PROFILE_PHOTO_BASE_URL/${controller?.mUserDetails?.photo?.name} $error $stackTrace");
                                            return Image.asset(
                                              "assets/icons/user.png",
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: locator<HomeController>()
                                                .isLoggedIn
                                            ? [
                                                CustomText(
                                                  controller?.mUserDetails
                                                          ?.name ??
                                                      '',
                                                  isTitle: true,
                                                  fontSize: 16,
                                                  isBold: true,
                                                ),
                                                CustomText(
                                                  controller
                                                          .mUserDetails
                                                          ?.contact
                                                          ?.phone
                                                          ?.mobile
                                                          ?.replaceRange(
                                                              5, 10, 'XXXXX')
                                                          ?.toString() ??
                                                      '',
                                                  fontSize: 14,
                                                ),
                                              ]
                                            : [
                                                CustomText(
                                                  'Login',
                                                  isTitle: true,
                                                  fontSize: 16,
                                                  isBold: true,
                                                ),
                                              ],
                                      ),
                                    ],
                                  ),
                                  if (locator<HomeController>().isLoggedIn)
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                      onPressed: () => NavigationService.to(
                                        ProfileViewRoute,
                                        arguments: controller,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if ((controller
                                    ?.mUserDetails?.contact?.address?.length ??
                                0) !=
                            0)
                          Divider(
                            color: Colors.grey[400],
                          ),
                        if ((controller
                                    ?.mUserDetails?.contact?.address?.length ??
                                0) !=
                            0)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "My City: ${controller?.mUserDetails?.contact?.city}",
                                  isBold: true,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                        Divider(
                          color: Colors.grey[400],
                        ),
                        SettingsCard(
                          name: "My Orders",
                          color: Colors.black87,
                          iconColor: Colors.black54,
                          onTap: () async =>
                              locator<HomeController>().isLoggedIn
                                  ? await NavigationService.to(MyOrdersRoute)
                                  : await BaseController.showLoginPopup(
                                      nextView: MyOrdersRoute,
                                      shouldNavigateToNextScreen: true,
                                    ),
                          icon: FontAwesomeIcons.pollH,
                        ),
                        SettingsCard(
                          name: "My Appointments",
                          color: Colors.black87,
                          iconColor: Colors.black54,
                          onTap: () async =>
                              locator<HomeController>().isLoggedIn
                                  ? await NavigationService.to(
                                      MyAppointmentViewRoute)
                                  : await BaseController.showLoginPopup(
                                      nextView: MyAppointmentViewRoute,
                                      shouldNavigateToNextScreen: true,
                                    ),
                          icon: Icons.event,
                        ),
                        verticalSpaceSmall,
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Column(
                            children: <Widget>[
                              verticalSpaceTiny_0,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: sections.keys
                                    .map(
                                      (int key) => SectionCard(
                                        name: sections[key],
                                        settingsCards: sectionsSettingsMap[key]
                                            .map(
                                              (int key) => SettingsCard(
                                                name: settingNameMap[key],
                                                onTap: settingOnTapMap[key],
                                                icon: settingIconMap[key],
                                                color: Colors.black87,
                                                iconColor: Colors.black54,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )
                                    .toList(),
                              )
                            ],
                          ),
                        ),
                        if (locator<HomeController>().isLoggedIn)
                          verticalSpaceTiny,
                        locator<HomeController>().isLoggedIn
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FloatingActionButton.extended(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(curve30),
                                      side: BorderSide(
                                          color: logoRed, width: 2.5),
                                    ),
                                    onPressed: BaseController.logout,
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: CustomText(
                                        "Logout",
                                        color: logoRed,
                                        fontSize: 14,
                                        isBold: true,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : verticalSpaceLarge,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
}

class SectionCard extends StatelessWidget {
  final String name;
  final List<SettingsCard> settingsCards;

  SectionCard({this.name, this.settingsCards});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          verticalSpaceTiny,
          Column(
            children: settingsCards,
          ),
        ],
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final void Function() onTap;

  const SettingsCard({
    @required this.name,
    @required this.onTap,
    @required this.icon,
    this.iconColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[400],
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: CustomText(
            name,
            isBold: true,
            fontSize: titleFontSizeStyle,
            color: color ?? Colors.grey[500],
          ),
          trailing: Icon(
            Icons.navigate_next_sharp,
            color: iconColor ?? Colors.grey[500],
            size: 30,
          ),
          onTap: onTap,
        ),
      );
}
