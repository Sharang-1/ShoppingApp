import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readmore/readmore.dart';

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
import '../../models/sellers.dart';
import '../../services/analytics_service.dart';
import '../../services/api/api_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/navigation_service.dart';
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

  final double headFont = 22;
  final double subHeadFont = 18;
  final double smallFont = 16;
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
        backgroundColor: backgroundWhiteCreamColor,
        appBar: null,
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            key: appointmentBtnKey,
            color: backgroundWhiteCreamColor,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: sellerDetails["appointment"] != "true"
                    ? darkRedSmooth
                    : textIconOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                BaseController.vibrate(duration: 50);
                _showBottomSheet(context, sellerDetails);
                if (sellerDetails["appointment"] != "true") {}
              },
              child: Container(
                // width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: sellerDetails["appointment"] != "true"
                    ? CustomText(
                        "Book Appointment",
                        align: TextAlign.center,
                        color: Colors.white,
                        isBold: true,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomText(
                            "Your Appointment is Booked",
                            align: TextAlign.center,
                            color: Colors.white,
                            isBold: true,
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
              actions: [
                IconButton(
                  onPressed: () async {
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
                  icon: Image.asset(
                    "assets/images/share_icon.png",
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
              backgroundColor: backgroundWhiteCreamColor,
              iconTheme: IconThemeData(color: appBarIconColor),
              flexibleSpace: FlexibleSpaceBar(
                background: SellerProfilePhotos(
                  accountId: sellerDetails["key"],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // HomeSlider(),
                    verticalSpace(30),
                    Row(
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
                                  CustomText(
                                    sellerDetails["name"],
                                    fontSize: headFont,
                                    fontFamily: headingFont,
                                    isBold: true,
                                    dotsAfterOverFlow: true,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset("assets/images/mask.png"),
                                      horizontalSpaceSmall,
                                      Image.asset(
                                          "assets/images/hand-sanitizer.png"),
                                      horizontalSpaceSmall,
                                      Icon(Icons.info, color: Colors.grey[500]),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: logoRed,
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 18,
                                            color: isOpenNow(_timing)
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          horizontalSpaceTiny,
                                          Text(
                                            isOpenNow(_timing)
                                                ? "Open Now"
                                                : "Closed Now",
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'OpenSans-Light'),
                                          ),
                                          if (isOpenNow(_timing))
                                            horizontalSpaceTiny,
                                          if (isOpenNow(_timing))
                                            Text(
                                              "(${getTimeString(_timing)})",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans-Light'),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: <Widget>[
                        //     // if (sellerDetails["rattings"] != "")
                        //     //   Container(
                        //     //     padding: EdgeInsets.symmetric(
                        //     //         vertical: 5, horizontal: 10),
                        //     //     decoration: BoxDecoration(
                        //     //         color: green,
                        //     //         borderRadius:
                        //     //             BorderRadius.circular(curve30)),
                        //     //     child: Row(
                        //     //       crossAxisAlignment: CrossAxisAlignment.center,
                        //     //       children: <Widget>[
                        //     //         CustomText(
                        //     //           sellerDetails["rattings"],
                        //     //           color: Colors.white,
                        //     //           isBold: true,
                        //     //           fontSize: 15,
                        //     //         ),
                        //     //         horizontalSpaceTiny,
                        //     //         Icon(
                        //     //           Icons.star,
                        //     //           color: Colors.white,
                        //     //           size: 15,
                        //     //         )
                        //     //       ],
                        //     //     ),
                        //     //   ),
                        //     // verticalSpaceSmall,
                        //     // FutureBuilder<Reviews>(
                        //     //   future: locator<APIService>().getReviews(
                        //     //       widget.data.key,
                        //     //       isSellerReview: true),
                        //     //   builder: (context, snapshot) {
                        //     //     if (snapshot.connectionState ==
                        //     //             ConnectionState.done &&
                        //     //         tutorialCoachMark != null) {
                        //     //       Future.delayed(
                        //     //         Duration(milliseconds: 500),
                        //     //         () {
                        //     //           Scrollable.ensureVisible(
                        //     //             sellerAboutKey.currentContext,
                        //     //             alignment: 0.7,
                        //     //           );
                        //     //           tutorialCoachMark.show();
                        //     //         },
                        //     //       );
                        //     //     }
                        //     //     return ((snapshot.connectionState ==
                        //     //                 ConnectionState.done) &&
                        //     //             (snapshot.data.ratingAverage.rating >
                        //     //                 0))
                        //     //         ? Align(
                        //     //             alignment: Alignment.centerRight,
                        //     //             child: Padding(
                        //     //               padding:
                        //     //                   const EdgeInsets.only(top: 8.0),
                        //     //               child: FittedBox(
                        //     //                 alignment: Alignment.centerLeft,
                        //     //                 fit: BoxFit.scaleDown,
                        //     //                 child: Container(
                        //     //                   decoration: BoxDecoration(
                        //     //                     color: Colors.green,
                        //     //                     borderRadius:
                        //     //                         BorderRadius.circular(15),
                        //     //                   ),
                        //     //                   padding: EdgeInsets.symmetric(
                        //     //                       vertical: 5.0,
                        //     //                       horizontal: 12.0),
                        //     //                   child: Row(
                        //     //                     children: [
                        //     //                       Text(
                        //     //                         "${snapshot?.data?.ratingAverage?.rating?.toString() ?? 0} ",
                        //     //                         style: TextStyle(
                        //     //                           fontWeight:
                        //     //                               FontWeight.w600,
                        //     //                           color: Colors.white,
                        //     //                           fontSize: 16,
                        //     //                         ),
                        //     //                       ),
                        //     //                       Icon(
                        //     //                         Icons.star,
                        //     //                         color: Colors.white,
                        //     //                         size: 12,
                        //     //                       ),
                        //     //                     ],
                        //     //                   ),
                        //     //                 ),
                        //     //               ),
                        //     //             ),
                        //     //           )
                        //     //         : Container();
                        //     //   },
                        //     // ),
                        //   ],
                        // ),
                      ],
                    ),
                    verticalSpace(30),
                    // Row(children: <Widget>[
                    //   Image(image: AssetImage("assets/images/mask.png")),
                    //   SizedBox(width: 5),
                    //   Text(
                    //     "Masks and social distancing - Mandatory ",
                    //     style: TextStyle(fontFamily: "OpenSans-Light"),
                    //   ),
                    // ]),
                    // verticalSpace(10),
                    // Row(children: <Widget>[
                    //   Image(
                    //       image:
                    //           AssetImage("assets/images/hand-sanitizer.png")),
                    //   SizedBox(width: 5),
                    //   Text(
                    //     "Disinfecting hands necessary. ",
                    //     style: TextStyle(fontFamily: "OpenSans-Light"),
                    //   ),
                    // ]),
                    // verticalSpace(10),
                    Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(curve15),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              "Note from Designer",
                              fontSize: subHeadFont,
                              isBold: true,
                              color: Colors.black,
                            ),
                            verticalSpace(10),
                            ReadMoreText(
                              sellerDetails["Note from Seller"],
                              trimLines: 3,
                              colorClickableText: logoRed,
                              trimMode: TrimMode.Line,
                              style: TextStyle(
                                fontSize: smallFont,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // verticalSpace(30),
                    // SellerStatus(
                    //   isOpen: isOpenNow(_timing),
                    //   time: getTimeString(_timing),
                    // ),
                    verticalSpace(10),
                    Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(curve15),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CustomText(
                              "Address",
                              fontSize: subHeadFont,
                              isBold: true,
                              color: Colors.grey[700],
                            ),
                            verticalSpaceTiny,
                            CustomText(
                              sellerDetails["Address"],
                              fontSize: smallFont,
                              color: Colors.grey,
                            ),
                            verticalSpaceSmall,
                            Divider(
                              thickness: 1,
                              color: Colors.grey[400].withOpacity(0.1),
                            ),
                            verticalSpaceTiny,
                            InkWell(
                              onTap: () {
                                MapUtils.openMap(
                                    double.parse(sellerDetails["lat"]),
                                    double.parse(sellerDetails["lon"]));
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.directions,
                                        color: textIconBlue,
                                      ),
                                      horizontalSpaceTiny,
                                      CustomText(
                                        "Direction",
                                        fontSize: subHeadFont,
                                        color: textIconBlue,
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        var status = await Location()
                                            .requestPermission();
                                        if (status ==
                                            PermissionStatus.GRANTED) {
                                          _navigationService.navigateTo(
                                              MapViewRoute,
                                              arguments: sellerData?.key);
                                        }
                                        return;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: BorderSide(
                                                width: 1.5, color: logoRed)
                                            // side: BorderSide(
                                            //     color: Colors.black, width: 0.5)
                                            ),
                                      ),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          child: Row(children: <Widget>[
                                            Icon(
                                              Icons.add_location,
                                              size: 16,
                                              color: logoRed,
                                            ),
                                            horizontalSpaceSmall,
                                            CustomText(
                                              "Locate",
                                              isBold: true,
                                              fontSize: 14,
                                              color: logoRed,
                                            )
                                          ]))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpaceTiny,
                    Center(
                      child: InkWell(
                        onTap: () async => await BaseController
                            .goToProductListPage(ProductPageArg(
                                subCategory: sellerDetails['name'],
                                queryString:
                                    "accountKey=${sellerDetails['key']};",
                                sellerPhoto:
                                    "$SELLER_PHOTO_BASE_URL/${sellerDetails['key']}")),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(
                                    0,
                                    3,
                                  ), // changes position of shadow
                                ),
                              ],
                              color: logoRed,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            child: Text(
                              "Explore Designer's Collection",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: subtitleFontSizeStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(30),
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
                        }),
                    verticalSpace(10),
                    Container(
                      key: sellerAboutKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Everything About \n${sellerDetails["name"]}",
                            fontSize: headFont - 2,
                            fontFamily: headingFont,
                            isBold: true,
                          ),
                          // verticalSpace(5),
                          // CustomText(
                          //   sellerDetails["name"],
                          //   fontSize: headFont - 2,
                          //   fontFamily: headingFont,
                          //   isBold: true,
                          // ),
                          verticalSpace(10),
                          Card(
                            elevation: 5,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(curve15),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                                fontSize: smallFont - 2,
                                                align: TextAlign.left,
                                                color: Colors.grey,
                                              ),
                                              verticalSpaceSmall,
                                              CustomText(
                                                sellerDetails[key],
                                                // isBold: true,
                                                fontSize: subHeadFont - 2,
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
                    if (sellerData.subscriptionTypeId == 1) verticalSpace(20),
                    if (sellerData.subscriptionTypeId == 1 &&
                        showExploreSection)
                      Row(
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
                                  fontSize: subtitleFontSize - 8,
                                  fontWeight: FontWeight.bold,
                                  color: textIconBlue,
                                ),
                              ),
                            ),
                            onTap: () {
                              return _navigationService.navigateTo(
                                ProductsListRoute,
                                arguments: ProductPageArg(
                                  subCategory: sellerData.name,
                                  queryString: "accountKey=${sellerData.key};",
                                  sellerPhoto:
                                      "$SELLER_PHOTO_BASE_URL/${sellerData.key}",
                                ),
                              );
                            },
                          ),
                        ],
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
                    verticalSpace(20),
                    Row(children: <Widget>[
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
                    ]),
                    verticalSpaceSmall,
                    SectionBuilder(
                      key: UniqueKey(),
                      context: context,
                      layoutType: LayoutType.DESIGNER_LAYOUT_1,
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
