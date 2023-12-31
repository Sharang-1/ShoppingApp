import 'dart:io';

import 'package:compound/ui/widgets/sliver_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/sellers.dart';
import '../../services/analytics_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import '../widgets/reviews.dart';
import '../widgets/section_builder.dart';
import '../widgets/seller_profile_slider.dart';

class SellerIndi extends StatefulWidget {
  final Seller data;
  const SellerIndi({Key? key, required this.data}) : super(key: key);

  @override
  _SellerIndiState createState() => _SellerIndiState();
}

class _SellerIndiState extends State<SellerIndi> {
  final productKey = new UniqueKey();
  Key reviewKey = UniqueKey();
  bool showExploreSection = true;

  GlobalKey sellerAboutKey = GlobalKey();
  GlobalKey appointmentBtnKey = GlobalKey();

  var allDetails = [
    DESIGNER_SCREEN_SPECIALITY.tr,
    DESIGNER_SCREEN_DESIGNES_CREATES.tr,
    DESIGNER_SCREEN_SERVICES_OFFERED.tr,
    DESIGNER_SCREEN_WORK_OFFERED.tr,
    DESIGNER_SCREEN_TYPE.tr
  ];

  Map<String, String> icons = {
    DESIGNER_SCREEN_SPECIALITY.tr: "assets/svg/tumblr_badge.svg",
    DESIGNER_SCREEN_DESIGNES_CREATES.tr: "assets/svg/fabric.svg",
    DESIGNER_SCREEN_SERVICES_OFFERED.tr: "assets/svg/crease.svg",
    DESIGNER_SCREEN_WORK_OFFERED.tr: "assets/svg/dressmaker.svg",
    DESIGNER_SCREEN_TYPE.tr: "assets/svg/online.svg",
  };

  // Map<int, String> icons = {
  //   1: "assets/svg/tumblr_badge.svg",
  //   2: "assets/svg/fabric.svg",
  //   3: "assets/svg/crease.svg",
  //   4: "assets/svg/dressmaker.svg",
  //   5: "assets/svg/online.svg",
  // };

  final double headFont = 16;
  final double subHeadFont = 12;
  final double smallFont = 10;
  String? selectedTime;
  int? selectedIndex;

  late TutorialCoachMark tutorialCoachMark;

  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String getTime(int time) {
    String meridien = "AM";
    print("time132  $time");
    if ((time ~/ 12).isOdd) {
      time = (time % 12);
      meridien = "PM";
      print("time1321  $time");
    }
    time = (time == 0) ? 12 : time;
    print("time1322  $time");
    return "${time.toString()} ${meridien.toString()}";
  }

  String getTimeString(Timing timing) {
    DateTime _dateTime = DateTime.now();
    Map<String, dynamic> timingJson = timing.toJson();
    Day today = Day.fromJson(
        timingJson[DateFormat('EEEE').format(_dateTime).toLowerCase()]);
    if (today.start == 0 && today.end == 0) return "";
    return "${getTime(today.start ?? 0)} - ${getTime(today.end ?? 0)}";
  }

  bool isOpenNow(Timing timing) {
    DateTime _dateTime = DateTime.now();
    Map<String, dynamic> timingJson = timing.toJson();
    Day today = Day.fromJson(
        timingJson[DateFormat('EEEE').format(_dateTime).toLowerCase()]);
    if (today.open ?? false) {
      if ((_dateTime.hour >= today.start!) && (_dateTime.hour < today.end!))
        return true;
      else
        return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    try {
      _analyticsService.sendAnalyticsEvent(
          eventName: "seller_view",
          parameters: <String, dynamic>{
            "seller_id": widget.data.key,
            "seller_name": widget.data.name,
            "subscription_id": widget.data.subscriptionType?.id?.toString(),
            "subscription_name": widget.data.subscriptionType?.name,
            "establishment_id": widget.data.establishmentType?.id?.toString(),
            "establishment_name": widget.data.establishmentType?.name,
            "user_id": locator<HomeController>().details!.key,
            "user_name": locator<HomeController>().details!.name,
          });
    } catch (e) {}
    showTutorial(
      context,
      sellerAboutKey: sellerAboutKey,
      appointmentBtnKey: appointmentBtnKey,
    );
  }

  late Seller sellerData;
  late Map<String, String> sellerDetails;

  void setupSellerDetails(Seller data) {
    sellerData = data;
    sellerDetails = {
      DESIGNER_DETAILS_KEY.tr: data.key ?? "",
      DESIGNER_DETAILS_NAME.tr: data.name ?? "",
      DESIGNER_DETAILS_TYPE.tr: data.establishmentType?.name?.toString() ?? "",
      DESIGNER_DETAILS_RATTINGS.tr:
          data.ratingAverage?.rating?.toString() ?? "",
      DESIGNER_DETAILS_LAT.tr:
          data.contact?.geoLocation?.latitude?.toString() ?? "",
      DESIGNER_DETAILS_LON.tr:
          data.contact?.geoLocation?.longitude?.toString() ?? "",
      DESIGNER_DETAILS_APPOINTMENT.tr: "false",
      DESIGNER_DETAILS_ADDRESS.tr: data.contact?.address ?? "",
      DESIGNER_DETAILS_CITY.tr: data.contact?.city ?? "",
      DESIGNER_SCREEN_SPECIALITY.tr: data.known ?? "",
      DESIGNER_SCREEN_DESIGNES_CREATES.tr: data.designs ?? "",
      DESIGNER_SCREEN_SERVICES_OFFERED.tr: data.operations ?? "",
      DESIGNER_SCREEN_WORK_OFFERED.tr: data.works ?? "",
      DESIGNER_SCREEN_TYPE.tr: data.establishmentType?.name ??
          accountTypeValues.reverse[data.accountType ?? AccountType.SELLER]!,
      DESIGNER_DETAILS_NOTE_FROM_DESIGNER.tr: data.bio ?? "",
      DESIGNER_DETAILS_OWNER_NAME.tr: data.owner!.name ?? "",
    };
  }

  void showTutorial(BuildContext context,
      {GlobalKey? sellerAboutKey, GlobalKey? appointmentBtnKey}) {
    SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs.getBool(ShouldShowDesignerProfileTutorial) ?? true) {
          List<TargetFocus> targets = <TargetFocus>[
            TargetFocus(
              identify: "Seller About",
              keyTarget: sellerAboutKey,
              paddingFocus: 15,
              shape: ShapeLightFocus.RRect,
              contents: [
                TargetContent(
                  align: ContentAlign.bottom,
                  child: Container(),
                ),
              ],
            ),
            TargetFocus(
              identify: "Appointment",
              keyTarget: appointmentBtnKey,
              shape: ShapeLightFocus.RRect,
              contents: [
                TargetContent(
                  align: ContentAlign.top,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          DESIGNER_DETAILS_BOOK_APPOINTMENT.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ];

          tutorialCoachMark = TutorialCoachMark(
            targets: targets,
            colorShadow: Colors.black45,
            paddingFocus: 5,
            onClickOverlay: (targetFocus) => tutorialCoachMark.next(),
            onClickTarget: (targetFocus) => tutorialCoachMark.next(),
            onFinish: () async =>
                await prefs.setBool(ShouldShowDesignerProfileTutorial, false),
            hideSkip: true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // double media = ((MediaQuery.of(context).size.width - 100) / 2);
    double multiplyer = 0.8;

    setupSellerDetails(widget.data);

    String designerProfilePicUrl =
        "$DESIGNER_PROFILE_PHOTO_BASE_URL/${sellerData.owner?.key}";

    Timing _timing = sellerData.timing!;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        bottomNavigationBar: Container(
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 4.0, top: 4.0),
            child: Container(
              key: appointmentBtnKey,
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            sellerDetails[DESIGNER_DETAILS_APPOINTMENT.tr] !=
                                    "true"
                                ? logoRed
                                : textIconOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        BaseController.vibrate(duration: 50);
                        // _showBottomSheet(context, sellerDetails);
                        if (sellerDetails[DESIGNER_DETAILS_APPOINTMENT.tr] !=
                            "true") {}
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: sellerDetails[DESIGNER_DETAILS_APPOINTMENT.tr] !=
                                "true"
                            ? CustomText(
                                DESIGNER_DETAILS_BOOK_APPOINTMENT.tr,
                                align: TextAlign.center,
                                color: Colors.white,
                                isBold: true,
                                fontSize: 14,
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomText(
                                    DESIGNER_DETAILS_APPOINTMENT_BOOKED.tr,
                                    align: TextAlign.center,
                                    color: Colors.white,
                                    isBold: true,
                                    fontSize: 14,
                                  ),
                                  verticalSpace(10),
                                  CustomText(
                                    "(12/6/20 4:25 am)",
                                    align: TextAlign.center,
                                    color: Colors.white,
                                    isBold: true,
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  if (widget.data.subscriptionType != null &&
                      widget.data.subscriptionType!.id != 3)
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async => await BaseController
                            .goToProductListPage(ProductPageArg(
                                subCategory:
                                    sellerDetails[DESIGNER_DETAILS_NAME.tr],
                                queryString:
                                    "accountKey=${sellerDetails[DESIGNER_DETAILS_KEY.tr]};",
                                sellerPhoto:
                                    "$SELLER_PHOTO_BASE_URL/${sellerDetails[DESIGNER_DETAILS_KEY.tr]}")),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: CustomText(
                            DESIGNER_EXPLORE_COLLECTION.tr,
                            align: TextAlign.center,
                            color: Colors.black,
                            isBold: true,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        body: SliverFab(
          floatingWidget: Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(left: 15.0),
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                width: 100 * multiplyer,
                height: 100 * multiplyer,
                fadeInCurve: Curves.easeIn,
                placeholder: "assets/images/product_preloading.png",
                image: sellerData.key != null
                    ? "$SELLER_PHOTO_BASE_URL/${sellerData.key}"
                    : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/product_preloading.png",
                  width: 100 * multiplyer,
                  height: 100 * multiplyer,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(255, 255, 255, 1),
                width: 8.0,
              ),
              boxShadow: [BoxShadow(color: Colors.black)],
            ),
          ),
          floatingPosition: FloatingPosition(top: -22, right: 20),
          expandedHeight: 250.0,
          slivers: [
            SliverAppBar(
              elevation: 0,
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              leading: InkWell(
                onTap: () => NavigationService.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.navigate_before,
                    size: 40,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 4.0),
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: InkWell(
                    onTap: () async {
                      await Share.share(await _dynamicLinkService
                              .createLink(sellerLink + sellerData.key!) ??
                          "");
                      try {
                        await _analyticsService.sendAnalyticsEvent(
                            eventName: "seller_shared",
                            parameters: <String, dynamic>{
                              "seller_id": sellerData.key,
                              "seller_name": sellerData.name,
                              "subscription_id":
                                  widget.data.subscriptionType?.id?.toString(),
                              "subscription_name":
                                  widget.data.subscriptionType?.name,
                              "establishment_id":
                                  widget.data.establishmentType?.id?.toString(),
                              "establishment_name":
                                  widget.data.establishmentType?.name,
                              "user_id": locator<HomeController>().details!.key,
                              "user_name":
                                  locator<HomeController>().details!.name,
                            });
                      } catch (e) {}
                    },
                    child: Icon(
                      Platform.isIOS ? CupertinoIcons.share : Icons.share,
                      size: 25,
                    ),
                  ),
                ),
              ],
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: appBarIconColor),
              flexibleSpace: FlexibleSpaceBar(
                background: SellerProfilePhotos(
                  accountId: sellerDetails[DESIGNER_DETAILS_KEY.tr]!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (Get.width / 2) - 80,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                      horizontalSpaceTiny,
                                      Expanded(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            sellerDetails[
                                                DESIGNER_DETAILS_CITY.tr]!,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  verticalSpaceTiny,
                                  Wrap(
                                    direction: Axis.horizontal,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 14,
                                        color: isOpenNow(_timing)
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      horizontalSpaceTiny,
                                      Text(
                                        isOpenNow(_timing)
                                            ? DESIGNER_OPEN_NOW.tr
                                            : DESIGNER_CLOSED_NOW.tr,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (isOpenNow(_timing))
                                        horizontalSpaceTiny,
                                      if (isOpenNow(_timing))
                                        Text(
                                          "(${getTimeString(_timing)})",
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // horizontalSpaceSmall,
                          // FutureBuilder<Reviews?>(
                          //   future: locator<APIService>().getReviews(
                          //       sellerDetails[DESIGNER_DETAILS_KEY.tr]!,
                          //       isSellerReview: true),
                          //   builder: (context, snapshot) =>
                          //       ((snapshot.connectionState == ConnectionState.done) &&
                          //               ((snapshot.data?.ratingAverage?.rating ?? 0) > 0))
                          //           ? FittedBox(
                          //               fit: BoxFit.scaleDown,
                          //               child: Column(
                          //                 children: [
                          //                   Container(
                          //                     padding: EdgeInsets.symmetric(
                          //                       vertical: 5,
                          //                       horizontal: 10,
                          //                     ),
                          //                     decoration: BoxDecoration(
                          //                       border: Border.all(
                          //                         color: Tools.getColorAccordingToRattings(
                          //                           snapshot.data!.ratingAverage!.rating ?? 0,
                          //                         ),
                          //                       ),
                          //                       borderRadius: BorderRadius.circular(5),
                          //                     ),
                          //                     child: CustomText(
                          //                       snapshot.data!.ratingAverage!.rating!
                          //                           .toStringAsFixed(1),
                          //                       color: Tools.getColorAccordingToRattings(
                          //                         snapshot.data!.ratingAverage!.rating ?? 0,
                          //                       ),
                          //                       isBold: true,
                          //                       fontSize: 16,
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             )
                          //           : Container(),
                          // ),
                        ],
                      ),
                    ),
                    verticalSpace(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          sellerDetails[
                                              DESIGNER_DETAILS_NAME.tr]!,
                                          textStyle: TextStyle(
                                            fontSize: headFont + 2,
                                            fontFamily: headingFont,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          dotsAfterOverFlow: true,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/mask.png",
                                              height: 30,
                                              width: 30,
                                            ),
                                            horizontalSpaceTiny,
                                            Image.asset(
                                              "assets/images/sanitiser.png",
                                              height: 30,
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider(
                                //   color: Colors.grey,
                                //   thickness: 1,
                                // ),
                                verticalSpaceSmall,
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 2,
                                        ),
                                      ]),
                                  child: CustomText(
                                    sellerDetails[DESIGNER_DETAILS_TYPE.tr]!,
                                    fontSize: subHeadFont,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: textFont,
                                    dotsAfterOverFlow: true,
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpaceMedium,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 16),
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: CustomText(
                              DESIGNER_SCREEN_KNOW_THE_DESIGNER.tr,
                              textStyle: TextStyle(
                                  fontSize: headFont,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          verticalSpace(10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: FadeInImage(
                                      width: 50,
                                      height: 50,
                                      fadeInCurve: Curves.easeIn,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          AssetImage("assets/images/user.png"),
                                      image: NetworkImage(
                                          "$designerProfilePicUrl",
                                          headers: {
                                            "Authorization":
                                                "Bearer ${locator<HomeController>().prefs!.getString(Authtoken) ?? ''}",
                                          }),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            "Image Error: $error $stackTrace");
                                        return Image.asset(
                                          "assets/images/user.png",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        );
                                      }),
                                ),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        sellerDetails[
                                            DESIGNER_DETAILS_OWNER_NAME.tr]!,
                                        fontWeight: FontWeight.normal,
                                        fontSize: headFont,
                                        dotsAfterOverFlow: true,
                                      ),
                                      if ((sellerData.education != null) ||
                                          (sellerData.designation != null))
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomText(
                                                "${sellerData.education ?? ''} ${sellerData.designation ?? ''}",
                                                fontSize: subHeadFont,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey.shade600,
                                                dotsAfterOverFlow: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ReadMoreText(
                                        sellerData.intro ??
                                            sellerDetails[
                                                DESIGNER_DETAILS_NOTE_FROM_DESIGNER
                                                    .tr]!,
                                        trimLines:
                                            ((sellerData.education == null) &&
                                                    (sellerData.designation ==
                                                        null))
                                                ? 3
                                                : 2,
                                        colorClickableText: logoRed,
                                        trimMode: TrimMode.Line,
                                        style: TextStyle(
                                          fontSize: subHeadFont - 2,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          verticalSpaceSmall,
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: logoRed,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: Get.width * 0.8,
                                  child: Text(
                                    sellerDetails[DESIGNER_DETAILS_ADDRESS.tr]!,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: subtitleFontSize,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                          // CustomText(
                          //   DESIGNER_SCREEN_LOCATION.tr,
                          //   fontSize: subHeadFont,
                          //   color: Colors.black,
                          // ),
                          // verticalSpaceSmall,

                          // verticalSpaceSmall,
                          // InkWell(
                          //   onTap: () {
                          //     MapUtils.openMap(
                          //         double.parse(sellerDetails[DESIGNER_DETAILS_LAT.tr] ?? "0"),
                          //         double.parse(sellerDetails[DESIGNER_DETAILS_LON.tr] ?? "0"));
                          //   },
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: <Widget>[
                          //       Container(
                          //         padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          //         decoration: BoxDecoration(
                          //           border: Border.all(
                          //             color: logoRed,
                          //           ),
                          //           borderRadius: BorderRadius.circular(5),
                          //         ),
                          //         child: Row(
                          //           children: <Widget>[
                          //             Icon(
                          //               Icons.directions,
                          //               color: logoRed,
                          //             ),
                          //             horizontalSpaceTiny,
                          //             CustomText(
                          //               DESIGNER_SCREEN_DIRECTION.tr,
                          //               fontSize: subHeadFont,
                          //               color: logoRed,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    verticalSpaceMedium,
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: CustomText(
                        DESIGNER_DETAILS.tr,
                        fontSize: headFont,
                        fontFamily: headingFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 220,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Center(
                        child: Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: allDetails.map(
                            (String key) {
                              return Container(
                                height: 100,
                                width: Get.width / 3 - 15,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12, blurRadius: 1),
                                    ],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    key == DESIGNER_SCREEN_SPECIALITY.tr
                                        ? SvgPicture.asset(
                                            icons[key]!,
                                            height: 30,
                                            width: 30,
                                            color: Colors.blue[500],
                                          )
                                        : SvgPicture.asset(
                                            icons[key]!,
                                            height: 25,
                                            width: 25,
                                          ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          verticalSpace(5),
                                          CustomText(
                                            key,
                                            fontSize: titleFontSize,
                                            align: TextAlign.center,
                                            color: Colors.black,
                                          ),
                                          verticalSpaceTiny,
                                          CustomText(
                                            sellerDetails[key]!,
                                            fontSize: subtitleFontSize,
                                            color: Colors.black45,
                                            align: TextAlign.center,
                                          ),
                                          key == DESIGNER_SCREEN_TYPE.tr
                                              ? Container()
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                    verticalSpaceMedium,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ReviewWidget(
                          key: reviewKey,
                          id: sellerDetails[DESIGNER_DETAILS_KEY.tr],
                          isSeller: true,
                          onSubmit: () {
                            setState(() {
                              reviewKey = UniqueKey();
                            });
                          }),
                    ),
                    if (sellerData.subscriptionTypeId == 1 &&
                        showExploreSection)
                      Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    DESIGNER_SCREEN_EXPLORE_DESIGNER_COLLECTION
                                        .tr,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text(
                                  'View All',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize - 2,
                                    color: textIconBlue,
                                  ),
                                ),
                              ),
                              onTap: () {
                                NavigationService.to(
                                  ProductsListRoute,
                                  arguments: ProductPageArg(
                                    subCategory: sellerData.name,
                                    queryString:
                                        "accountKey=${sellerData.key};",
                                    sellerPhoto:
                                        "$SELLER_PHOTO_BASE_URL/${sellerData.key}",
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    if (sellerData.subscriptionTypeId == 1 &&
                        showExploreSection)
                      verticalSpace(5),
                    if (sellerData.subscriptionTypeId == 1 &&
                        showExploreSection)
                      SectionBuilder(
                        key: productKey,
                        context: context,
                        filter: ProductFilter(
                          accountKey: sellerData.key,
                        ),
                        layoutType: LayoutType.PRODUCT_LAYOUT_2,
                        controller: ProductsGridViewBuilderController(
                            randomize: true, limit: 6),
                        scrollDirection: Axis.horizontal,
                        onEmptyList: () async {
                          await Future.delayed(
                            Duration(milliseconds: 500),
                            () => setState(
                              () {
                                showExploreSection = false;
                              },
                            ),
                          );
                        },
                      ),
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                DESIGNER_SCREEN_SIMILAR_DESIGNERS.tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    verticalSpaceSmall,
                    SectionBuilder(
                      key: UniqueKey(),
                      context: context,
                      layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                      fromHome: true,
                      onEmptyList: () {},
                      controller: SellersGridViewBuilderController(
                        removeId: sellerData.key!,
                        subscriptionType: sellerData.subscriptionTypeId!,
                        random: true,
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // void _showBottomSheet(context, sellerDetails) {
  //   print("check this " + MediaQuery.of(context).size.height.toString());
  //   showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(curve30))),
  //       isScrollControlled: true,
  //       clipBehavior: Clip.antiAlias,
  //       context: context,
  //       builder: (context) {
  //         return FractionallySizedBox(
  //             heightFactor: 0.8,
  //             child: SellerBottomSheetView(
  //               sellerData: sellerData,
  //               context: context,
  //             ));
  //       });
  // }

  Widget sectionDivider({double? thickness}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(
          color: Colors.grey[300],
          thickness: thickness ?? 5,
        ),
      );

  Widget elementDivider({double? thickness}) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 50,
        ),
        child: Divider(
          color: Colors.grey[400],
          thickness: thickness ?? 1,
        ),
      );
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
