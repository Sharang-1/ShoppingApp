// ignore_for_file: unnecessary_cast

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/user_details_controller.dart';
import '../../locator.dart';
import '../../services/localization_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/bottom_tag.dart';
import '../widgets/custom_text.dart';
import '../widgets/profile_setup_indicator.dart';
import 'help_view.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late String selectedLang;
  late Map<int, String> sections;
  late Map<int, String> settingNameMap;
  late Map<int, IconData> settingIconMap;
  late Map<int, void Function()> settingOnTapMap;
  late Map<int, List<int>> sectionsSettingsMap;
  late AppBar appbar;

  @override
  void initState() {
    selectedLang = locator<HomeController>().getCurrentLang();
    setupSettings();
    super.initState();
  }

  void setupSettings() {
    sections = {
      1: SETTINGS_CONNECT_WITH_US.tr,
      2: SETTINGS_LEAVE_REVIEW.tr,
      3: SETTINGS_ABOUT_host.tr,
    };

    settingNameMap = {
      1: SETTINGS_RATE_APP.tr,
      2: SETTINGS_SEND_FEEDBACK.tr,
      3: SETTINGS_CUSTOMER_SUPPORT.tr,
      4: SETTINGS_TERMS_AND_CONDITIONS.tr,
      5: SETTINGS_SHARE_WITH_FRIENDS.tr,
      6: SETTINGS_ABOUT_host.tr,
    };

    settingIconMap = {
      1: FontAwesomeIcons.solidStar,
      2: FontAwesomeIcons.bookOpen,
      3: FontAwesomeIcons.phoneVolume,
      4: FontAwesomeIcons.solidNewspaper,
      5: Platform.isIOS ? CupertinoIcons.share : Icons.share,
      6: FontAwesomeIcons.infoCircle,
    };

    settingOnTapMap = {
      1: () => Platform.isAndroid
          ? launchUrlString(
              "https://play.google.com/store/apps/details?id=in.host.host_app&hl=en_IN&gl=US")
          : launchUrlString("https://apps.apple.com/in/app/host/id1562083632"),
      2: () => Platform.isAndroid
          ? launchUrlString(
              "https://play.google.com/store/apps/details?id=in.host.host_app&hl=en_IN&gl=US")
          : launchUrlString("https://apps.apple.com/in/app/host/id1562083632"),
      3: () => Get.bottomSheet(
            HelpView(),
            backgroundColor: Colors.white,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(curve10),
              ),
            ),
            clipBehavior: Clip.antiAlias,
          ),
      4: () => BaseController.launchURL(TERMS_AND_CONDITIONS_URL),
      5: BaseController.shareApp,
      6: () => launchUrlString("https://host.in/main/about-us.html"),
    };

    sectionsSettingsMap = {
      1: [2, 3, 5],
      2: [1],
      3: [4, 6]
    };
  }

  @override
  Widget build(BuildContext context) => GetBuilder<UserDetailsController>(
        init: UserDetailsController()..getUserDetails(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: newBackgroundColor2,
            // appBar: appbar,
            appBar: AppBar(
                elevation: 0,
                title: Text(
                  SETTINGS_APPBAR_TITLE.tr,
                  style: TextStyle(
                    fontFamily: headingFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                iconTheme: IconThemeData(
                  color: appBarIconColor,
                ),
                backgroundColor: Colors.white,
                actions: [
                  DropdownButton(
                      icon: Icon(Icons.arrow_drop_down),
                      value: selectedLang,
                      elevation: 0,
                      items: LocalizationService.langs
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (e) async {
                        await locator<HomeController>()
                            .changeLocale(e as String);
                        setState(() {
                          selectedLang = e;
                          setupSettings();
                        });
                      }),
                ]),
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
                                      Stack(
                                        children: [
                                          ClipOval(
                                            child: FadeInImage(
                                              width: 50,
                                              height: 50,
                                              fadeInCurve: Curves.easeIn,
                                              placeholder: AssetImage(
                                                  "assets/images/user.png"),
                                              image: (locator<HomeController>()
                                                      .isLoggedIn)
                                                  ? NetworkImage(
                                                      "$USER_PROFILE_PHOTO_BASE_URL/${controller.mUserDetails?.key}",
                                                      headers: {
                                                          "Authorization":
                                                              "Bearer ${locator<HomeController>().prefs!.getString(Authtoken) ?? ''}",
                                                        }) as ImageProvider
                                                  : AssetImage(
                                                          "assets/images/user.png")
                                                      as ImageProvider,
                                              imageErrorBuilder:
                                                  (context, error, stackTrace) {
                                                print(
                                                    "User Photo: $error $stackTrace");
                                                return Image.asset(
                                                  "assets/images/user.png",
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          if (!locator<HomeController>()
                                              .isProfileComplete)
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: ProfileSetupIndicator(
                                                height: 14,
                                                width: 14,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            locator<HomeController>().isLoggedIn
                                                ? [
                                                    CustomText(
                                                      controller.mUserDetails
                                                              ?.name ??
                                                          '',
                                                      isTitle: true,
                                                      fontSize: 16,
                                                      isBold: true,
                                                    ),
                                                    CustomText(
                                                      controller.mUserDetails !=
                                                              null
                                                          ? controller
                                                                  .mUserDetails!
                                                                  .contact
                                                                  ?.phone
                                                                  ?.mobile
                                                                  ?.replaceRange(
                                                                      5,
                                                                      10,
                                                                      'XXXXX')
                                                                  .toString() ??
                                                              ''
                                                          : '',
                                                      fontSize: 14,
                                                    ),
                                                  ]
                                                : [
                                                    CustomText(
                                                      SETTINGS_LOG_IN.tr,
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
                                        size: 20,
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
                                    .mUserDetails?.contact?.address?.length ??
                                0) !=
                            0)
                          Divider(
                            color: Colors.grey[400],
                          ),
                        if ((controller
                                    .mUserDetails?.contact?.address?.length ??
                                0) !=
                            0)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CustomText(
                                  // "${SETTINGS_MY_CITY.tr}: ${controller.mUserDetails?.contact?.city}",
                                  "${SETTINGS_MY_CITY.tr}: ${controller.mUserDetails?.contact?.city ?? " Ahemdabad "}",

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
                          name: "${SETTINGS_MY_ORDER.tr}",
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
                          name: "${SETTINGS_MY_APPOINTMENT.tr}",
                          color: Colors.black87,
                          iconColor: Colors.black54,
                          onTap: () async {
                            print("123");
                            locator<HomeController>().isLoggedIn
                                ? await NavigationService.to(
                                    MyAppointmentViewRoute)
                                : await BaseController.showLoginPopup(
                                    nextView: MyAppointmentViewRoute,
                                    shouldNavigateToNextScreen: true,
                                  );
                          },
                          icon: Icons.event,
                        ),
                        SettingsCard(
                          name: "${SETTINGS_MY_WISHLIST.tr}",
                          color: Colors.black87,
                          iconColor: Colors.black54,
                          onTap: () => BaseController.gotoWishlist(),
                          icon: FontAwesomeIcons.heart,
                        ),
                        verticalSpaceSmall,
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
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
                                                name: settingNameMap[key]!,
                                                onTap: settingOnTapMap[key]!,
                                                icon: settingIconMap[key]!,
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
                                        SETTINGS_LOG_OUT.tr,
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
  final Color? color;
  final Color? iconColor;
  final void Function() onTap;

  const SettingsCard({
    required this.name,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[400]!,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: Icon(icon),
            title: CustomText(
              name,
              isBold: true,
              fontSize: titleFontSizeStyle,
              color: color ?? Colors.grey[500]!,
            ),
            trailing: Icon(
              Icons.navigate_next_sharp,
              color: iconColor ?? Colors.grey[500],
              size: 30,
            ),
            onTap: () {
              onTap();
            },
          ),
        ),
      );
}
