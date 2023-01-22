import 'dart:io';

import 'package:compound/models/sellerBackgroundImageModel.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/newSellers.dart';
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
import '../widgets/sellerAppointmentBottomSheet.dart';

class SellerIndi2 extends StatefulWidget {
  final Seller data;
  const SellerIndi2({Key? key, required this.data}) : super(key: key);

  @override
  _SellerIndi2State createState() => _SellerIndi2State();
}

class _SellerIndi2State extends State<SellerIndi2> {
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
  APIService apiService = APIService();
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
    return "${getTime(today.start as int? ?? 0)} - ${getTime(today.end as int? ?? 0)}";
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

  SellerBackImageModel? sellerBackImageModel = SellerBackImageModel();
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
    } catch (e) {
      print(e);
    }
    print(
        ".................. ggggggggggg ........ ${widget.data.toString()}.................");
    
    getImageName();
    // var data2 = apiService.getSellerBackgroundImage();
    // setState(() {
    //   testimg = data2;
    // });
    // print(".................. 123432 ........ $data1.................");
    //if(data1 != null)print(data1["photos"]);
    showTutorial(
      context,
      sellerAboutKey: sellerAboutKey,
      appointmentBtnKey: appointmentBtnKey,
    );
  }

  getImageName() async {
    print(
        ".................. ggggggggggg ........ ${widget.key.toString()}.................");
    if (widget.data != null)
      setState(() async {
        sellerBackImageModel = await apiService.getImageData(widget.data.key!);
      });
    if (sellerBackImageModel != null) {
      print(
          ".................. 123432 ........ ${sellerBackImageModel!.key}.................");
      //print(data1.data.toString());
    }
  }

  late Seller sellerData;
  late Map<String, String> sellerDetails;

  void setupSellerDetails(Seller data) {
    sellerData = data;
    sellerDetails = {
      DESIGNER_DETAILS_KEY.tr: data.key ?? "",
      DESIGNER_DETAILS_NAME.tr: data.name ?? "",
      DESIGNER_DETAILS_TYPE.tr: data.establishmentType?.name?.toString() ?? "",
      // DESIGNER_DETAILS_RATTINGS.tr: data.ratingAverage?.rating?.toString() ?? "",
      // DESIGNER_DETAILS_LAT.tr: data.contact?.geoLocation?.latitude?.toString() ?? "",
      // DESIGNER_DETAILS_LON.tr: data.contact?.geoLocation?.longitude?.toString() ?? "",
      DESIGNER_DETAILS_APPOINTMENT.tr: "false",
      DESIGNER_DETAILS_ADDRESS.tr: data.contact?.address ?? "",
      DESIGNER_DETAILS_CITY.tr: data.contact?.city ?? "",
      // DESIGNER_SCREEN_SPECIALITY.tr: data.known ?? "",
      // DESIGNER_SCREEN_DESIGNES_CREATES.tr: data.designs ?? "",
      // DESIGNER_SCREEN_SERVICES_OFFERED.tr: data.operations ?? "",
      // DESIGNER_SCREEN_WORK_OFFERED.tr: data.works ?? "",
      DESIGNER_SCREEN_TYPE.tr: data.establishmentType?.name ??
          accountTypeValues.reverse[data.accountType ?? AccountType.SELLER]!,
      DESIGNER_DETAILS_NOTE_FROM_DESIGNER.tr: data.intro ?? "",
      // DESIGNER_DETAILS_NOTE_FROM_DESIGNER.tr: data.bio ?? "",
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

    // Timing _timing = sellerData.timing!;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 460,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                            ),
                          ],
                          color: Colors.white,
                          // workingarea
                          image:sellerBackImageModel != null ? DecorationImage(
                            image:
                             NetworkImage(
                                "$SELLER_PROFILE_PHOTO_BASE_URL/${sellerData.key}/profile/${sellerBackImageModel!.photos![0].name}"),
                            //     :AssetImage(
                            //   "assets/images/product_preloading.png",
                            // ),

                            
                            fit: BoxFit.cover,
                          ):DecorationImage(
                            image:
                                AssetImage(
                              "assets/images/product_preloading.png",
                            ),

                            
                            fit: BoxFit.cover,
                          ),
                          // border: Border.all(),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Spacer(),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  // height: 280,
                                  // width: 200,
                                  width: MediaQuery.of(context).size.width - 40,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      verticalSpaceMedium,
                                      CustomText(
                                        sellerDetails[
                                                DESIGNER_DETAILS_NAME.tr] ??
                                            "Seller Name",
                                        textStyle: TextStyle(
                                          fontSize: headFont + 6,
                                          fontFamily: headingFont,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        dotsAfterOverFlow: true,
                                      ),
                                      // verticalSpaceTiny,

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            size: 15,
                                            color: Colors.black54,
                                          ),
                                          horizontalSpaceTiny,
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                sellerDetails[
                                                        DESIGNER_DETAILS_CITY
                                                            .tr] ??
                                                    "Seller City",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: headFont - 3,
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomText(
                                            "${sellerDetails[DESIGNER_DETAILS_TYPE.tr]}",
                                            fontSize: headFont - 3,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: textFont,
                                            dotsAfterOverFlow: true,
                                            maxLines: 4,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),

                                      Text(
                                        "${sellerData.bio ?? 'Seller bio'}",
                                        // "${sellerDetails[DESIGNER_SCREEN_DESIGNES_CREATES.tr]} • ${sellerDetails[DESIGNER_SCREEN_SPECIALITY.tr]} • ${sellerDetails[DESIGNER_SCREEN_WORK_OFFERED.tr]}",
                                        // trimLines: 2,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        // colorClickableText: logoRed,
                                        // trimMode: TrimMode.Line,
                                        style: TextStyle(
                                          fontSize: headFont - 2,
                                          color: Colors.black54,
                                        ),
                                      ),

                                      verticalSpaceMedium,

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Colors.black54,
                                            size: 17,
                                          ),
                                          horizontalSpaceSmall,
                                          CustomText(
                                            "Delivering Across India",
                                            fontSize: headFont - 2,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: textFont,
                                            dotsAfterOverFlow: true,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.currency_rupee,
                                            color: Colors.black54,
                                            size: 17,
                                          ),
                                          horizontalSpaceSmall,
                                          CustomText(
                                            "Delivery fee will apply",
                                            fontSize: headFont - 2,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: textFont,
                                            dotsAfterOverFlow: true,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_shipping_outlined,
                                            color: Colors.black54,
                                            size: 17,
                                          ),
                                          horizontalSpaceSmall,
                                          CustomText(
                                            "All orders will be delivered by Dzor",
                                            fontSize: headFont - 2,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: textFont,
                                            dotsAfterOverFlow: true,
                                            color: Colors.black54,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  top: -40,
                                  child: Container(
                                    // padding: EdgeInsets.all(10),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                        ),
                                      ],
                                      // color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: FadeInImage.assetNetwork(
                                        width: 100 * multiplyer,
                                        height: 100 * multiplyer,
                                        fadeInCurve: Curves.easeIn,
                                        placeholder:
                                            "assets/images/product_preloading.png",
                                        image: sellerData.key != null
                                            ? "$SELLER_PHOTO_BASE_URL/${sellerData.key}"
                                            : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/product_preloading.png",
                                          width: 100 * multiplyer,
                                          height: 100 * multiplyer,
                                          fit: BoxFit.cover,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () => NavigationService.back(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                )
                              ]),
                          margin: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.navigate_before,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 8, top: 8),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                              )
                            ]),
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
                                    "subscription_id": widget
                                        .data.subscriptionType?.id
                                        ?.toString(),
                                    "subscription_name":
                                        widget.data.subscriptionType?.name,
                                    "establishment_id": widget
                                        .data.establishmentType?.id
                                        ?.toString(),
                                    "establishment_name":
                                        widget.data.establishmentType?.name,
                                    "user_id":
                                        locator<HomeController>().details!.key,
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
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      verticalSpace(10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  image: NetworkImage("$designerProfilePicUrl",
                                      headers: {
                                        "Authorization":
                                            "Bearer ${locator<HomeController>().prefs!.getString(Authtoken) ?? ''}",
                                      }),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    print("Image Error: $error $stackTrace");
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomText(
                                    sellerDetails[
                                        DESIGNER_DETAILS_OWNER_NAME.tr]!,
                                    fontWeight: FontWeight.normal,
                                    fontSize: headFont,
                                    dotsAfterOverFlow: true,
                                  ),
                                  // if ((sellerData.education != null) ||
                                  //     (sellerData.designation != null))
                                  //   Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: CustomText(
                                  //           "${sellerData.education ?? ''} ${sellerData.designation ?? ''}",
                                  //           fontSize: subHeadFont,
                                  //           fontWeight: FontWeight.w400,
                                  //           color: Colors.grey.shade600,
                                  //           dotsAfterOverFlow: true,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  ReadMoreText(
                                    sellerData.intro ??
                                        sellerDetails[
                                            DESIGNER_DETAILS_NOTE_FROM_DESIGNER
                                                .tr]!,
                                    trimLines: 2,
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
                      ),
                      verticalSpaceMedium,

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
                      // Container(
                      //   color: Colors.grey[200],
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(left: 0.0),
                      //           child: Text(
                      //             DESIGNER_SCREEN_SIMILAR_DESIGNERS.tr,
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // verticalSpaceSmall,
                      // SectionBuilder(
                      //   key: UniqueKey(),
                      //   context: context,
                      //   layoutType: LayoutType.DESIGNER_ID_3_LAYOUT,
                      //   fromHome: true,
                      //   onEmptyList: () {},
                      //   controller: SellersGridViewBuilderController(
                      //     removeId: sellerData.key!,
                      //     subscriptionType: sellerData.subscriptionTypeId!,
                      //     random: true,
                      //   ),
                      //   scrollDirection: Axis.horizontal,
                      // ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showBottomSheet(context, sellerDetails) {
    print("check this " + MediaQuery.of(context).size.height.toString());
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(curve30))),
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        context: context,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.8,
              child: SellerBottomSheetView(
                sellerData: sellerData,
                context: context,
              ));
        });
  }

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
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
