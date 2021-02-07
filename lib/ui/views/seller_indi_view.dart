import 'package:compound/constants/route_names.dart';
import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/grid_view_builder_filter_models/sellerFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';
import 'package:compound/ui/widgets/reviews.dart';
import 'package:compound/ui/widgets/newcarddesigns/seller_profile_slider.dart';
import 'package:compound/ui/widgets/sellerAppointmentBottomSheet.dart';
import 'package:compound/ui/widgets/sellerTileUi.dart';
import 'package:compound/ui/widgets/writeReview.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/sellers_grid_view_builder_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import 'package:share/share.dart';
import 'package:compound/constants/dynamic_links.dart';
import 'package:compound/services/dynamic_link_service.dart';
import 'package:compound/locator.dart';

class SellerIndi extends StatefulWidget {
  final Seller data;
  const SellerIndi({Key key, this.data}) : super(key: key);

  @override
  _SellerIndiState createState() => _SellerIndiState();
}

class _SellerIndiState extends State<SellerIndi> {
  final productKey = new UniqueKey();

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
    "Speciality": "assets/svg/tumblr-badge.svg",
  };

  final double headFont = 22;

  final double subHeadFont = 18;

  final double smallFont = 16;

  String selectedTime;

  int selectedIndex;

  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    Map<String, String> sellerDetails = {
      "key": widget.data.key,
      "name": widget.data.name,
      "type": widget?.data?.establishmentType?.name?.toString(),
      "rattings": widget.data.ratingAverage?.rating?.toString() ?? "",
      "lat": widget?.data?.contact?.geoLocation?.latitude?.toString(),
      "lon": widget?.data?.contact?.geoLocation?.longitude?.toString(),
      "appointment": "false",
      "Address": widget.data.operations,
      "Speciality": widget.data.known,
      "Designs & Creates": widget.data.designs,
      "Services offered": widget.data.operations,
      "Works Offered": widget.data.works,
      "Type": widget.data?.establishmentType?.name ??
          accountTypeValues
              .reverse[widget.data?.accountType ?? AccountType.SELLER],
      "Note from Seller": widget.data.bio
    };

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
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
                _showBottomSheet(context, sellerDetails);
                if (sellerDetails["appointment"] != "true") {}
              },
              color: sellerDetails["appointment"] != "true"
                  ? darkRedSmooth
                  : textIconOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                // side: BorderSide(
                //     color: Colors.black, width: 0.5)
              ),
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
        body: CustomScrollView(
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
                    verticalSpace(20),
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
                                  RaisedButton(
                                      onPressed: () {},
                                      color: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          side: BorderSide(
                                              width: 1.5, color: logoRed)
                                          // side: BorderSide(
                                          //     color: Colors.black, width: 0.5)
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
                              "Note from Seller",
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
                            'Similar Sellers',
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
                    if (widget.data.subscriptionTypeId == 1)
                      Text(
                        "   Products From Seller",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSizeStyle),
                      ),
                    if (widget.data.subscriptionTypeId == 1) verticalSpace(5),
                    if (widget.data.subscriptionTypeId == 1)
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
                            randomize: true,
                          ),
                          childAspectRatio: 1.35,
                          scrollDirection: Axis.horizontal,
                          disablePagination: false,
                          emptyListWidget: Container(),
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
