import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/server_urls.dart';
import '../../controllers/base_controller.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/bottom_tag.dart';
import '../widgets/custom_text.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

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
  };

  final Map<int, IconData> settingIconMap = {
    1: FontAwesomeIcons.solidStar,
    2: FontAwesomeIcons.bookOpen,
    3: FontAwesomeIcons.phoneVolume,
    4: FontAwesomeIcons.solidNewspaper,
  };

  final Map<int, void Function()> settingOnTapMap = {
    1: () => Platform.isAndroid
        ? launchUrlString(
            "https://play.google.com/store/apps/details?id=in.host.host_app&hl=en_IN&gl=US")
        : launchUrlString("https://apps.apple.com/in/app/host/id1562083632"),
    2: () => Platform.isAndroid
        ? launchUrlString(
            "https://play.google.com/store/apps/details?id=in.host.host_app&hl=en_IN&gl=US")
        : launchUrlString("https://apps.apple.com/in/app/host/id1562083632"),
    // 1: () => OpenAppstore.launch(
    //     androidAppId: "in.host.host_app", iOSAppId: "1562083632"),
    // 2: () => OpenAppstore.launch(
    //     androidAppId: "in.host.host_app", iOSAppId: "1562083632"),
    3: () => BaseController.launchURL(CONTACT_US_URL),
    4: () => BaseController.launchURL(TERMS_AND_CONDITIONS_URL),
  };

  final Map<int, List<int>> sectionsSettingsMap = {
    1: [2, 3],
    2: [1],
    3: [4]
  };

  final AppBar appbar = AppBar(
    elevation: 0,
    centerTitle: true,
    title: Image.asset(
      "assets/images/logo.png",
      // color: logoRed,
      height: 35,
      width: 35,
    ),
    iconTheme: IconThemeData(
      color: appBarIconColor,
    ),
    backgroundColor: backgroundWhiteCreamColor,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
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
                padding: EdgeInsets.only(
                    left: screenPadding,
                    right: screenPadding,
                    top: 10,
                    bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    verticalSpace(20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontFamily: headingFont,
                          fontWeight: FontWeight.w700,
                          fontSize: headingFontSizeStyle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    verticalSpace(50),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          verticalSpaceTiny_0,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sections.keys
                                .map(
                                  (int key) => SectionCard(
                                    name: sections[key] ?? "",
                                    settingsCards: sectionsSettingsMap[key]!
                                        .map(
                                          (int key) => SettingsCard(
                                            name: settingNameMap[key] ?? "",
                                            onTap:
                                                settingOnTapMap[key] ?? () {},
                                            icon: settingIconMap[key]!,
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
                    verticalSpace(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton.extended(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(curve30),
                            side: BorderSide(color: logoRed, width: 2.5),
                          ),
                          onPressed: BaseController.logout,
                          label: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomText(
                              "Logout",
                              color: logoRed,
                              isBold: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class SectionCard extends StatelessWidget {
  final String name;
  final List<SettingsCard> settingsCards;

  SectionCard({required this.name, required this.settingsCards});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
  final void Function() onTap;

  const SettingsCard(
      {required this.name, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[400]!,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: CustomText(
            name,
            isBold: true,
            fontSize: subtitleFontSizeStyle,
            color: Colors.grey[500]!,
          ),
          trailing: Icon(
            Icons.navigate_next_sharp,
            color: Colors.grey[500],
            size: 30,
          ),
          onTap: () => onTap,
        ),
      );
}
