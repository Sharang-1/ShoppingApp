import 'package:cached_network_image/cached_network_image.dart';
import 'package:compound/ui/widgets/sellerTileUi.dart';
import 'package:flutter/material.dart';
import '../shared/shared_styles.dart';

import './home_view_slider.dart';

class HomeViewList extends StatelessWidget {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    // 'https://images.unsplash.com/photo-15x`19125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  Map<String, String> sellerCardDetails = {
    "name": "Sejal Works",
    "type": "SELLER",
    "sells": "Dresses , Kurtas",
    "discount": "10% Upto 30%",
  };
  Map<String, String> boutiqueCardDetails = {
    "name": "Ketan Works",
    "type": "BOUTIQUE",
    "Speciality": "Spec1 , Spec2 , Spec3 , Spec4 , Spec5",
    "WorksOffered": "Work1 , Work2 , Work3 , Work4",
  };
  final String singleImage =
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';
  @override
  Widget build(BuildContext context) {
    // const double headingFontSize=25;
    // const double titleFontSize=20;
    const double subtitleFontSize = subtitleFontSizeStyle;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HomeSlider(),
          Padding(
            padding: EdgeInsets.only(
              top: 14.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              'Sellers Near You',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
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
                  data: boutiqueCardDetails,
                  fromHome: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 14.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              'New Arrivals',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            height: 240.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: imgList.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: 140.0,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/products',
                              arguments: i,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 160,
                                child: Hero(
                                  tag: '$i',
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: i,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Two Gold Rings',
                                  style:
                                      TextStyle(fontSize: subtitleFontSize - 4),
                                ),
                                subtitle: Text(
                                  '\$200',
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                top: 6.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(singleImage),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Text('Shop By Category',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 8.0, left: 8.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/categorise',
                    );
                  },
                ),
              )
            ],
          ),
          Container(
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.only(top: 8, left: 6, right: 6, bottom: 12),
              children: List.generate(
                4,
                (index) {
                  return Container(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.width / 2) - 80,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: imgList[index],
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Two Gold Rings',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: subtitleFontSize - 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                top: 6.0,
                left: 8.0,
                right: 8.0,
                bottom: 10,
              ),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(singleImage),
              ),
            ),
          )
        ],
      ),
    );
  }
}
