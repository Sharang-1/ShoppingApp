import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/grid_view_builder_filter_models/sellerFilter.dart';
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/sellers.dart';
import '../../services/analytics_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/navigation_service.dart';
import '../../viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import '../../viewmodels/grid_view_builder_view_models/sellers_grid_view_builder_view.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/ProductTileUI.dart';
import '../widgets/custom_text.dart';
import '../widgets/newcarddesigns/seller_profile_slider.dart';
import '../widgets/reviews.dart';
import '../widgets/sellerAppointmentBottomSheet.dart';
import '../widgets/sellerTileUi.dart';
import '../widgets/seller_status.dart';
import '../widgets/writeReview.dart';

class SellerIndi extends StatefulWidget {
  final Seller data;
  const SellerIndi({Key key, this.data}) : super(key: key);

  @override
  _SellerIndiState createState() => _SellerIndiState();
}

class _SellerIndiState extends State<SellerIndi> {
  final productKey = new UniqueKey();
  bool showExploreSection = true;

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
    return "${getTime(today.start)} - ${getTime(today.end)} (Today)";
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
  }

  @override
  Widget build(BuildContext context) {
    double media = ((MediaQuery.of(context).size.width - 100) / 2);
    double multiplyer = 0.8;

    Map<String, String> sellerDetails = {
      "key": widget.data.key,
      "name": widget.data.name,
      "type": widget?.data?.establishmentType?.name?.toString(),
      "rattings": widget.data.ratingAverage?.rating?.toString() ?? "",
      "lat": widget?.data?.contact?.geoLocation?.latitude?.toString(),
      "lon": widget?.data?.contact?.geoLocation?.longitude?.toString(),
      "appointment": "false",
      "Address": widget?.data?.contact?.address,
      "Speciality": widget.data.known,
      "Designs & Creates": widget.data.designs,
      "Services offered": widget.data.operations,
      "Works Offered": widget.data.works,
      "Type": widget.data?.establishmentType?.name ??
          accountTypeValues
              .reverse[widget.data?.accountType ?? AccountType.SELLER],
      "Note from Seller": widget.data.bio
    };

    Timing _timing = widget.data.timing;

    return Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        appBar: null,
        // appBar: AppBar(
        //   elevation: 0,
        //   backgroundColor: backgroundWhiteCreamColor,
        //   iconTheme: IconThemeData(color: appBarIconColor),
        //   centerTitle: true,
        //   title: Image.asset(
        //     "assets/images/logo_red.png",
        //     color: logoRed,
        //     height: 40,
        //     width: 40,
        //   ),
        // ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
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
                  // side: BorderSide(
                  //     color: Colors.black, width: 0.5)
                ),
              ),
              onPressed: () {
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
                image: widget?.data?.key != null
                    ? "$SELLER_PHOTO_BASE_URL/${widget.data.key}"
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
                    verticalSpace(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CustomText(
                                sellerDetails["name"],
                                fontSize: headFont,
                                fontFamily: headingFont,
                                isBold: true,
                                dotsAfterOverFlow: true,
                              ),
                              verticalSpaceSmall,
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
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            if (sellerDetails["rattings"] != "")
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: green,
                                    borderRadius:
                                        BorderRadius.circular(curve30)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CustomText(
                                      sellerDetails["rattings"],
                                      color: Colors.white,
                                      isBold: true,
                                      fontSize: 15,
                                    ),
                                    horizontalSpaceTiny,
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            verticalSpaceSmall,
                            GestureDetector(
                              onTap: () async {
                                await Share.share(await _dynamicLinkService
                                    .createLink(sellerLink + widget.data?.key));
                                try {
                                  await _analyticsService.sendAnalyticsEvent(
                                      eventName: "seller_shared",
                                      parameters: <String, dynamic>{
                                        "seller_id": widget?.data?.key,
                                        "seller_name": widget?.data?.name,
                                      });
                                } catch (e) {}
                              },
                              child: Image.asset(
                                "assets/images/share_icon.png",
                                width: 30,
                                height: 30,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    verticalSpace(30),
                    Row(children: <Widget>[
                      Image(image: AssetImage("assets/images/mask.png")),
                      SizedBox(width: 5),
                      Text(
                        "Masks and social distancing - Mandatory ",
                        style: TextStyle(fontFamily: "OpenSans-Light"),
                      ),
                    ]),
                    verticalSpace(10),
                    Row(children: <Widget>[
                      Image(
                          image:
                              AssetImage("assets/images/hand-sanitizer.png")),
                      SizedBox(width: 5),
                      Text(
                        "Disinfecting hands necessary. ",
                        style: TextStyle(fontFamily: "OpenSans-Light"),
                      ),
                    ]),
                    verticalSpace(10),
                    SellerStatus(
                      isOpen: isOpenNow(_timing),
                      time: getTimeString(_timing),
                    ),
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
                            GestureDetector(
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
                                      onPressed: () {
                                        _navigationService.navigateTo(
                                            MapViewRoute,
                                            arguments: widget?.data?.key);
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
                    verticalSpace(30),
                    ReviewWidget(id: sellerDetails["key"]),
                    verticalSpaceMedium,
                    WriteReviewWidget(sellerDetails["key"]),
                    verticalSpace(25),
                    CustomText(
                      "Everything About ${sellerDetails["name"]}",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                width: MediaQuery.of(context)
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
                    verticalSpace(20),
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
                            CustomText(
                              sellerDetails["Note from Seller"],
                              fontSize: smallFont,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpace(30),
                    Row(children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
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
                    SizedBox(
                      height: 190,
                      child: GridListWidget<Sellers, Seller>(
                        key: UniqueKey(),
                        context: context,
                        filter: new SellerFilter(),
                        gridCount: 1,
                        childAspectRatio: 0.60,
                        viewModel: SellersGridViewBuilderViewModel(
                          removeId: widget.data.key,
                          subscriptionType: widget.data.subscriptionTypeId,
                          random: true,
                        ),
                        disablePagination: true,
                        scrollDirection: Axis.horizontal,
                        emptyListWidget: Container(),
                        tileBuilder: (BuildContext context, data, index,
                            onDelete, onUpdate) {
                          return GestureDetector(
                            onTap: () => {},
                            child: SellerTileUi(
                              data: data,
                              fromHome: true,
                            ),
                          );
                        },
                      ),
                    ),
                    if (widget.data.subscriptionTypeId == 1) verticalSpace(20),
                    if (widget.data.subscriptionTypeId == 1 &&
                        showExploreSection)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 8.0),
                              child: Text(
                                "Explore Designer's Collection",
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSizeStyle,
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
                                  subCategory: widget.data.name,
                                  queryString: "accountKey=${widget.data.key};",
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    if (widget.data.subscriptionTypeId == 1 &&
                        showExploreSection)
                      verticalSpace(5),
                    if (widget.data.subscriptionTypeId == 1 &&
                        showExploreSection)
                      SizedBox(
                        height: 200,
                        child: GridListWidget<Products, Product>(
                          key: productKey,
                          context: context,
                          filter: ProductFilter(
                            accountKey: widget.data.key,
                          ),
                          gridCount: 2,
                          viewModel: ProductsGridViewBuilderViewModel(
                              randomize: true, limit: 6),
                          childAspectRatio: 1.35,
                          scrollDirection: Axis.horizontal,
                          disablePagination: false,
                          emptyListWidget: Container(),
                          onEmptyList: () async {
                            await Future.delayed(
                                Duration(milliseconds: 500),
                                () => setState(() {
                                      showExploreSection = false;
                                    }));
                          },
                          tileBuilder: (BuildContext context, productData,
                              index, onUpdate, onDelete) {
                            return ProductTileUI(
                              data: productData,
                              onClick: () => _navigationService.navigateTo(
                                ProductIndividualRoute,
                                arguments: productData,
                              ),
                              index: index,
                              cardPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            );
                          },
                        ),
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
              heightFactor: MediaQuery.of(context).size.height > 600
                  ? MediaQuery.of(context).size.height > 800
                      ? 0.650
                      : 0.7
                  : 0.8,
              child: SellerBottomSheetView(
                sellerData: widget.data,
                context: context,
              ));
          // heightFactor: 0.9,
          // // heightFactor: MediaQuery.of(context).size.height > 600
          // //     ? MediaQuery.of(context).size.height > 800
          // //         ? 0.650
          // //         : 0.7
          // //     : 0.8,
          // child: SellerBottomSheetView(sellerData: widget.data));
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
