// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:compound/models/cart.dart';
// import 'package:compound/models/categorys.dart';
// import 'package:compound/ui/views/categories_view.dart';
// import 'package:compound/ui/widgets/GridListWidget.dart';
// import 'package:compound/ui/widgets/categoryTileUI.dart';
// import 'package:compound/viewmodels/grid_view_builder_view_models/categories_view_builder_view_model.dart';
import 'package:flutter/material.dart';

import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/widgets/sellerTileUi.dart';

import '../shared/shared_styles.dart';
import '../widgets/top_picks_deals_card.dart';
import './home_view_slider.dart';

class HomeViewList extends StatelessWidget {
  final gotoCategory;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    // 'https://images.unsplash.com/photo-15x`19125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  final Map<String, String> sellerCardDetails = {
    "name": "Sejal Works",
    "type": "SELLER",
    "sells": "Dresses , Kurtas",
    "discount": "10% Upto 30%",
  };
  final Map<String, String> boutiqueCardDetails = {
    "name": "Ketan Works",
    "type": "BOUTIQUE",
    "Speciality": "Spec1 , Spec2 , Spec3 , Spec4 , Spec5",
    "WorksOffered": "Work1 , Work2 , Work3 , Work4",
  };

  final List<Map<String, String>> bestDealsDataMap = [
    {
      "name": "Nike shoes",
      "sellerName": "Nike",
      "price": "500",
      "discountedPrice": "400",
      "isDiscountAvailable": "true"
    },
    {
      "name": "Kurta",
      "sellerName": "Nike",
      "price": "200",
      "isDiscountAvailable": "false"
    },
    {
      "name": "Sari",
      "sellerName": "Nike",
      "price": "300",
      "discountedPrice": "200",
      "isDiscountAvailable": "true"
    }
  ];
  final List<Map<String, String>> sameDayDeliveryDataMap = [
    {
      "name": "Nike shoes",
      "sellerName": "Nike",
      "price": "500",
      "discountedPrice": "400",
      "isDiscountAvailable": "true",
      "isSameDayDelivery": "true"
    },
    {
      "name": "Kurta",
      "sellerName": "Nike",
      "price": "200",
      "isDiscountAvailable": "false",
      "isSameDayDelivery": "true"
    },
  ];
  final List<Map<String, String>> topPicksDataMap = [
    {
      "name": "Nike shoes",
      "sellerName": "Nike",
      "price": "500",
    },
    {
      "name": "Kurta",
      "sellerName": "Nike",
      "price": "200",
    },
    {
      "name": "Sari",
      "sellerName": "Nike",
      "price": "300",
    }
  ];
  final List<Map<String, String>> productAwedDataMap = [
    {
      "name": "Nike shoes",
      "sellerName": "Nike",
      "price": "500",
      "discountedPrice": "400",
      "isDiscountAvailable": "true",
      "isExclusive": "true"
    },
    {
      "name": "Sari",
      "sellerName": "Nike",
      "price": "300",
      "isExclusive": "true"
    },
    {
      "name": "Kurta",
      "sellerName": "Nike",
      "price": "200",
      "isDiscountAvailable": "false",
      "isExclusive": "true"
    },
  ];

  final List<String> categories = [
    "Kurtas",
    "Dresses",
    "Gowns",
    "Chaniya Cholis"
  ];
  final String singleImage =
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';

  HomeViewList({Key key, @required this.gotoCategory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // const double headingFontSize=25;
    // const double titleFontSize=20;
    const double subtitleFontSize = subtitleFontSizeStyle + 2;

    return Container(
      padding: EdgeInsets.fromLTRB(screenPadding, 10, screenPadding, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), child: HomeSlider()),
          ),
          verticalSpace(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Shop By Category',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.w700)),
              InkWell(
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textIconBlue,
                  ),
                ),
                onTap: () {
                  gotoCategory();
                },
              ),
            ],
          ),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories
                  .map((category) => SizedBox(
                      width: 192,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                        child: InkWell(
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.grey,
                            child: Stack(children: <Widget>[
                              Positioned.fill(
                                  child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.srcATop),
                                child: FadeInImage.assetNetwork(
                                    fit: BoxFit.fill,
                                    fadeInCurve: Curves.easeIn,
                                    placeholder:
                                        'assets/images/placeholder.png',
                                    image:
                                        // photoName == null?

                                        'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                                    // : photoName

                                    ),
                              )),
                              Positioned.fill(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CustomText(category,
                                          align: TextAlign.center,
                                          color: Colors.white,
                                          fontSize: subtitleFontSize - 2,
                                          fontWeight: FontWeight.w600),
                                    ]),
                              ))
                            ]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(curve15),
                            ),
                            elevation: 5,
                          ),
                          onTap: () {},
                        ),
                      )))
                  .toList(),
            ),
          ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Great Sellers Near You',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            padding: EdgeInsets.only(left: 0),
            height: 175,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
              ],
            ),
          ),
          verticalSpace(40),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
                height: (MediaQuery.of(context).size.width - 40) * 0.8,
                width: MediaQuery.of(context).size.width - 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(curve15),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg"),
                  ),
                )),
          ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Top Picks For You',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: topPicksDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: topPicksDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          verticalSpace(40),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
                height: (MediaQuery.of(context).size.width - 40) * 0.8,
                width: MediaQuery.of(context).size.width - 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(curve15),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://previews.123rf.com/images/3art/3art1703/3art170300446/73904198-banner-or-poster-design-for-indian-festival-happy-holi-.jpg"),
                  ),
                )),
          ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Best Deals Today',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: bestDealsDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: bestDealsDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Boutiques Near You',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            padding: EdgeInsets.only(left: 0),
            height: 175,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SellerTileUi(
                  data: boutiqueCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: boutiqueCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: boutiqueCardDetails,
                  fromHome: true,
                ),
              ],
            ),
          ),
          verticalSpace(40),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
                height: (MediaQuery.of(context).size.width - 40) * 0.8,
                width: MediaQuery.of(context).size.width - 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(curve15),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://mir-s3-cdn-cf.behance.net/projects/404/8417d853121653.Y3JvcCwxNjAzLDEyNTUsMCww.png"),
                  ),
                )),
          ),
          verticalSpace(40),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Products Delivered The Same Day',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          Container(
            height: 180,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: sameDayDeliveryDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          verticalSpace(30),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Products That Awed Us',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: productAwedDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: productAwedDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          verticalSpace(30),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Popular Categories Near You',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories
                    .map((category) => SizedBox(
                        width: 192,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                          child: InkWell(
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.grey,
                              child: Stack(children: <Widget>[
                                Positioned.fill(
                                    child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.srcATop),
                                  child: FadeInImage.assetNetwork(
                                      fit: BoxFit.fill,
                                      fadeInCurve: Curves.easeIn,
                                      placeholder:
                                          'assets/images/placeholder.png',
                                      image:
                                          // photoName == null?

                                          'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                                      // : photoName

                                      ),
                                )),
                                Positioned.fill(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CustomText(category,
                                            align: TextAlign.center,
                                            color: Colors.white,
                                            fontSize: subtitleFontSizeStyle - 2,
                                            fontWeight: FontWeight.w600),
                                      ]),
                                ))
                              ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(curve15),
                              ),
                              elevation: 5,
                            ),
                            onTap: () {},
                          ),
                        )))
                    .toList(),
              )),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Sellers Delivering To You',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            padding: EdgeInsets.only(left: 0),
            height: 175,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ))
          ]),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                      elevation: 5,
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             SelectAddress()));
                      },
                      color: darkRedSmooth,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(curve30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Locate Tailors ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )))
            ],
          ),
          verticalSpaceLarge_1
        ],
      ),
    );
  }
}
