import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/reviews.dart';
import '../../models/sellers.dart';
import '../../services/analytics_service.dart';
import '../../services/api/api_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import '../widgets/newcarddesigns/seller_profile_slider.dart';
import '../widgets/reviews.dart';
import '../widgets/section_builder.dart';
import '../widgets/sellerAppointmentBottomSheet.dart';
import '../widgets/writeReview.dart';

class SellerIndi extends StatefulWidget {
  final Seller data;
  const SellerIndi({Key key, this.data}) : super(key: key);

  @override
  _SellerIndiState createState() => _SellerIndiState();
}

class _SellerIndiState extends State<SellerIndi> {
  final productKey = new UniqueKey();
  Key reviewKey = UniqueKey();
  Key writeReviewKey = UniqueKey();
  bool showExploreSection = true;

  GlobalKey sellerAboutKey = GlobalKey();
  GlobalKey appointmentBtnKey = GlobalKey();

  var allDetials = [
    "Speciality",
    "Designs & Creates",
    "Services offered",
    "Works Offered",
    "Type",
  ];

  Map<String, String> icons = {
    "Works Offered": "assets/svg/dressmaker.svg",
    "Services offered": "assets/svg/crease.svg",
    "Designs & Creates": "assets/svg/fabric.svg",
    "Type": "assets/svg/online.svg",
    "Speciality": "assets/svg/tumblr_badge.svg",
  };

  final double headFont = 16;
  final double subHeadFont = 14;
  final double smallFont = 10;
  String selectedTime;
  int selectedIndex;

  TutorialCoachMark tutorialCoachMark;

  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String getTime(int time) {
    String meridien = "AM";
    if ((time ~/ 12).isOdd) {
      time = (time % 12);
      meridien = "PM";
    }
    time = (time == 0) ? 12 : time;
    return "${time.toString()} ${meridien.toString()}";
  }

  String getTimeString(Timing timing) {
    DateTime _dateTime = DateTime.now();
    Map<String, dynamic> timingJson = timing.toJson();
    Day today = Day.fromJson(
        timingJson[DateFormat('EEEE').format(_dateTime).toLowerCase()]);
    if (today.start == 0 && today.end == 0) return "";
    return "${getTime(today.start)} - ${getTime(today.end)}";
  }

  bool isOpenNow(Timing timing) {
    DateTime _dateTime = DateTime.now();
    Map<String, dynamic> timingJson = timing.toJson();
    Day today = Day.fromJson(
        timingJson[DateFormat('EEEE').format(_dateTime).toLowerCase()]);
    if (today.open) {
      if ((_dateTime.hour >= today.start) && (_dateTime.hour < today.end))
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
            "seller_id": widget?.data?.key,
            "seller_name": widget?.data?.name,
          });
    } catch (e) {}
    showTutorial(
      context,
      sellerAboutKey: sellerAboutKey,
      appointmentBtnKey: appointmentBtnKey,
    );
  }

  Seller sellerData;
  Map<String, String> sellerDetails;

  void setupSellerDetails(Seller data) {
    sellerData = data;
    sellerDetails = {
      "key": data.key,
      "name": data.name,
      "type": data?.establishmentType?.name?.toString(),
      "rattings": data.ratingAverage?.rating?.toString() ?? "",
      "lat": data?.contact?.geoLocation?.latitude?.toString(),
      "lon": data?.contact?.geoLocation?.longitude?.toString(),
      "appointment": "false",
      "Address": data?.contact?.address,
      "City": data?.contact?.city,
      "Speciality": data.known,
      "Designs & Creates": data.designs,
      "Services offered": data.operations,
      "Works Offered": data.works,
      "Type": data?.establishmentType?.name ??
          accountTypeValues.reverse[data?.accountType ?? AccountType.SELLER],
      "Note from Seller": data.bio
    };
  }

  void showTutorial(BuildContext context,
      {GlobalKey sellerAboutKey, GlobalKey appointmentBtnKey}) {
    SharedPreferences.getInstance().then(
      (prefs) {
        if (prefs?.getBool(ShouldShowDesignerProfileTutorial) ?? true) {
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
                          "Book Appointment",
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
            context,
            targets: targets,
            colorShadow: Colors.black45,
            paddingFocus: 5,
            onClickOverlay: (targetFocus) => tutorialCoachMark.next(),
            onClickTarget: (targetFocus) => tutorialCoachMark.next(),
            onFinish: () async =>
                await prefs?.setBool(ShouldShowDesignerProfileTutorial, false),
            hideSkip: true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double media = ((MediaQuery.of(context).size.width - 100) / 2);
    double multiplyer = 0.8;

    setupSellerDetails(widget?.data);

    Timing _timing = sellerData.timing;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            key: appointmentBtnKey,
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: sellerDetails["appointment"] != "true"
                          ? lightGreen
                          : textIconOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      BaseController.vibrate(duration: 50);
                      _showBottomSheet(context, sellerDetails);
                      if (sellerDetails["appointment"] != "true") {}
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: sellerDetails["appointment"] != "true"
                          ? CustomText(
                              "Book Appointment",
                              align: TextAlign.center,
                              color: Colors.white,
                              isBold: true,
                              fontSize: 14,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomText(
                                  "Your Appointment is Booked",
                                  align: TextAlign.center,
                                  color: Colors.white,
                                  isBold: true,
                                  fontSize: 14,
                                ),
                                verticalSpace(10),
                                CustomText(
                                  "(12/6/20 4:30 am)",
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
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async =>
                        await BaseController.goToProductListPage(ProductPageArg(
                            subCategory: sellerDetails['name'],
                            queryString: "accountKey=${sellerDetails['key']};",
                            sellerPhoto:
                                "$SELLER_PHOTO_BASE_URL/${sellerDetails['key']}")),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CustomText(
                        "Explore Collection",
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
                image: sellerData?.key != null
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
                color: Color.fromRGBO(255, 255, 255, 0.1),
                width: 8.0,
              ),
            ),
          ),
          floatingPosition: FloatingPosition(left: media - 10, top: -22),
          expandedHeight: 250.0,
          slivers: [
            SliverAppBar(
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
                    size: 30,
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
                          .createLink(sellerLink + sellerData?.key));
                      try {
                        await _analyticsService.sendAnalyticsEvent(
                            eventName: "seller_shared",
                            parameters: <String, dynamic>{
                              "seller_id": sellerData?.key,
                              "seller_name": sellerData?.name,
                            });
                      } catch (e) {}
                    },
                    child: Icon(
                      Icons.share,
                      size: 30,
                    ),
                  ),
                ),
              ],
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: appBarIconColor),
              flexibleSpace: FlexibleSpaceBar(
                background: SellerProfilePhotos(
                  accountId: sellerDetails["key"],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder<Reviews>(
                            future: locator<APIService>().getReviews(
                                sellerDetails["key"],
                                isSellerReview: true),
                            builder: (context, snapshot) => ((snapshot
                                            .connectionState ==
                                        ConnectionState.done) &&
                                    ((snapshot?.data?.ratingAverage?.rating ??
                                            0) >
                                        0))
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Tools
                                                  .getColorAccordingToRattings(
                                                snapshot
                                                    .data.ratingAverage.rating,
                                              ),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CustomText(
                                                snapshot
                                                    .data.ratingAverage.rating
                                                    .toStringAsFixed(1),
                                                color: Tools
                                                    .getColorAccordingToRattings(
                                                  snapshot.data.ratingAverage
                                                      .rating,
                                                ),
                                                isBold: true,
                                                fontSize: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                          SizedBox(
                            width: (Get.width / 2) - 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    horizontalSpaceSmall,
                                    Expanded(
                                      child: Text(
                                        sellerDetails["City"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 16,
                                      color: isOpenNow(_timing)
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    horizontalSpaceSmall,
                                    Text(
                                      isOpenNow(_timing)
                                          ? "Open Now"
                                          : "Closed Now",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    if (isOpenNow(_timing)) horizontalSpaceTiny,
                                    if (isOpenNow(_timing))
                                      Text(
                                        "(${getTimeString(_timing)})",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        sellerDetails["name"],
                                        fontSize: headFont,
                                        fontFamily: headingFont,
                                        isBold: true,
                                        dotsAfterOverFlow: true,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/mask.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                          horizontalSpaceTiny,
                                          Image.asset(
                                            "assets/images/hand-sanitizer.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                          horizontalSpaceTiny,
                                          Icon(
                                            Icons.info,
                                            color: Colors.grey[500],
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      sellerDetails["type"],
                                      fontSize: subHeadFont,
                                      fontFamily: headingFont,
                                      dotsAfterOverFlow: true,
                                      isBold: true,
                                      color: textIconOrange,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // DefaultTabController(
                    //   length: 4,
                    //   child: TabBar(
                    //     labelStyle: TextStyle(fontWeight: FontWeight.w700),
                    //     indicatorSize: TabBarIndicatorSize.label,
                    //     labelColor: logoRed,
                    //     unselectedLabelColor: Color(0xff5f6368),
                    //     isScrollable: true,
                    //     indicator: MD2Indicator(
                    //       indicatorHeight: 3,
                    //       indicatorColor: logoRed,
                    //       indicatorSize: MD2IndicatorSize.normal,
                    //     ),
                    //     tabs: <Widget>[
                    //       Tab(
                    //         text: "OverView",
                    //       ),
                    //       Tab(
                    //         text: "Designer's Details",
                    //       ),
                    //       Tab(
                    //         text: "Reviews",
                    //       ),
                    //       Tab(
                    //         text: "Collections",
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    sectionDivider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            "Know The Designer".toUpperCase(),
                            fontSize: subHeadFont,
                            color: Colors.black,
                          ),
                          verticalSpace(10),
                          ReadMoreText(
                            sellerDetails["Note from Seller"],
                            trimLines: 3,
                            colorClickableText: logoRed,
                            trimMode: TrimMode.Line,
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: Colors.grey[600],
                            ),
                          ),
                          elementDivider(),
                          CustomText(
                            "Address".toUpperCase(),
                            fontSize: subHeadFont,
                            color: Colors.black,
                          ),
                          verticalSpaceSmall,
                          CustomText(
                            sellerDetails["Address"],
                            fontSize: subtitleFontSize,
                            color: Colors.grey,
                          ),
                          verticalSpaceSmall,
                          InkWell(
                            onTap: () {
                              MapUtils.openMap(
                                  double.parse(sellerDetails["lat"]),
                                  double.parse(sellerDetails["lon"]));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: logoRed,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.directions,
                                        color: logoRed,
                                      ),
                                      horizontalSpaceTiny,
                                      CustomText(
                                        "Direction",
                                        fontSize: subHeadFont,
                                        color: logoRed,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var status =
                                        await Location().requestPermission();
                                    if (status == PermissionStatus.GRANTED) {
                                      _navigationService.navigateTo(
                                          MapViewRoute,
                                          arguments: sellerData?.key);
                                    }
                                    return;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: logoRed,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.directions,
                                          color: logoRed,
                                        ),
                                        horizontalSpaceTiny,
                                        CustomText(
                                          "Locate",
                                          fontSize: subHeadFont,
                                          color: logoRed,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    sectionDivider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            "Designer Details".toUpperCase(),
                            fontSize: headFont - 2,
                            fontFamily: headingFont,
                          ),
                          verticalSpace(20),
                          Card(
                            elevation: 0,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(curve15),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: allDetials.map(
                                  (String key) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        key == "Speciality"
                                            ? SvgPicture.asset(
                                                icons[key],
                                                height: 30,
                                                width: 30,
                                                color: Colors.blue[500],
                                              )
                                            : SvgPicture.asset(
                                                icons[key],
                                                height: 30,
                                                width: 30,
                                              ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              verticalSpace(5),
                                              CustomText(
                                                key,
                                                fontSize: titleFontSize,
                                                align: TextAlign.left,
                                                color: Colors.grey,
                                              ),
                                              verticalSpaceSmall,
                                              CustomText(
                                                sellerDetails[key],
                                                fontSize: subtitleFontSize,
                                                color: Colors.grey[700],
                                                align: TextAlign.left,
                                              ),
                                              key == "Type"
                                                  ? Container()
                                                  : Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      child: Divider(
                                                        thickness: 1,
                                                        color: Colors.grey[400]
                                                            .withOpacity(0.1),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    sectionDivider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          ReviewWidget(
                            key: reviewKey,
                            id: sellerDetails["key"],
                            isSeller: true,
                          ),
                          verticalSpaceMedium,
                          FutureBuilder<bool>(
                            key: writeReviewKey,
                            future: locator<APIService>()
                                .hasReviewed(sellerData.key, isSeller: true),
                            builder: (context, snapshot) {
                              return ((snapshot.connectionState ==
                                          ConnectionState.done) &&
                                      !snapshot.data)
                                  ? Column(
                                      children: [
                                        WriteReviewWidget(
                                          sellerDetails["key"],
                                          isSeller: true,
                                          onSubmit: () {
                                            setState(() {
                                              reviewKey = UniqueKey();
                                              writeReviewKey = UniqueKey();
                                            });
                                          },
                                        ),
                                        verticalSpace(15),
                                      ],
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (sellerData.subscriptionTypeId == 1) sectionDivider(),
                    if (sellerData.subscriptionTypeId == 1 &&
                        showExploreSection)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                    "Explore Designer's Collection",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: titleFontSizeStyle,
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
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: textIconBlue,
                                  ),
                                ),
                              ),
                              onTap: () {
                                return NavigationService.to(
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
                        key: productKey ?? UniqueKey(),
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
                    sectionDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                'Similar Designers',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
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
                      controller: SellersGridViewBuilderController(
                        removeId: sellerData.key,
                        subscriptionType: sellerData.subscriptionTypeId,
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
              // heightFactor: MediaQuery.of(context).size.height > 600
              //     ? MediaQuery.of(context).size.height > 800
              //         ? 0.650
              //         : 0.7
              //     : 0.8,
              heightFactor: 0.8,
              child: SellerBottomSheetView(
                sellerData: sellerData,
                context: context,
              ));
        });
  }

  Widget sectionDivider({double thickness}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Divider(
          color: Colors.grey[400],
          thickness: thickness ?? 5,
        ),
      );

  Widget elementDivider({double thickness}) => Padding(
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
