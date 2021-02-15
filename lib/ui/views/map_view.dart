// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:compound/models/tailors.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'package:compound/models/sellers.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/viewmodels/map_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fimber/fimber.dart';
import '../shared/shared_styles.dart';

class MapView extends StatelessWidget {
  final CarouselController controller = CarouselController();
  final Map<String, int> carouselMap = {};

  String getStringWithBullet(String s) {
    if (s == null) return "${String.fromCharCode(0x2022)} No Data";
    return "${s == "" ? "" : String.fromCharCode(0x2022)} $s";
  }

  Widget clientCardSeller(MapViewModel model, context, Seller client, int index) {
    const double titleFontSize = titleFontSizeStyle;
    const double subtitleFontSize = subtitleFontSizeStyle - 3;

    // List<String> tags = [
    //   "Excellent",
    //   "superb",
    // ];

    List<String> tempSplitName = client.name.split(" ");
    String shortName = tempSplitName.length > 1 &&
            tempSplitName[tempSplitName.length - 1].length > 1
        ? tempSplitName[0].substring(0, 1) +
            tempSplitName[tempSplitName.length - 1].substring(0, 1)
        : tempSplitName[0].substring(0, 2);
    print(client.operations ?? "No data");
    return Padding(
        padding: EdgeInsets.only(
          top: 0,
        ),
        child: InkWell(
          onTap: () {
            model.currentClient = client;
            model.currentBearing = 90.0;
            model.zoomInMarker(client.contact.geoLocation.latitude,
                client.contact.geoLocation.longitude);
            controller.animateToPage(index);
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 5, 10),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.width * 1.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white),
              child: Row(children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.black,
                                child: Text(
                                  shortName.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ))),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 14.0),
                            child: Tooltip(
                              message: client.name,
                              child: Text(
                                client.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: titleFontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      verticalSpace(12),
                      Expanded(
                        child: Text(
                          getStringWithBullet(client.works),
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: lightGrey,
                            // fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      verticalSpace(5),
                      Expanded(
                        child: Text(
                          getStringWithBullet(client.operations),
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: lightGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                      // Row(children: <Widget>[
                      //   Padding(
                      //       padding: EdgeInsets.only(left: 10),
                      //       child: Text(
                      //         ratings.toString(),
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: ratingCountFontSize,
                      //             fontWeight: FontWeight.w600),
                      //       )),
                      //   SizedBox(
                      //     width: 10,
                      //   ),
                      //   RatingBarIndicator(
                      //     rating: ratings,
                      //     itemCount: 5,
                      //     itemSize: ratingCountFontSize,
                      //     direction: Axis.horizontal,
                      //     itemBuilder: (context, _) => Icon(
                      //       Icons.star,
                      //       color: Colors.amber,
                      //     ),
                      //   ),
                      // ]),
                      // Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Row(
                      //           children: <Widget>[
                      //             Chip(
                      //                 elevation: 2,
                      //                 backgroundColor: Colors.blueGrey,
                      //                 label: Text(
                      //                   tags[0],
                      //                   style: TextStyle(
                      //                       fontSize: tagSize,
                      //                       color: Colors.white,
                      //                       fontWeight: FontWeight.bold),
                      //                 )),
                      //             SizedBox(width: 10),
                      //             Chip(
                      //                 elevation: 2,
                      //                 backgroundColor: Colors.blueGrey,
                      //                 label: Text(
                      //                   tags[1],
                      //                   style: TextStyle(
                      //                       fontSize: tagSize,
                      //                       color: Colors.white,
                      //                       fontWeight: FontWeight.bold),
                      //                 )),
                      //           ],
                      //         ),
                      //       ),
                      //       CircleAvatar(
                      //           radius: 22,
                      //           backgroundColor: Colors.white,
                      //           child: IconButton(
                      //               onPressed: () {
                      //                 print("object");
                      //                 launch("tel://${client.contact}");
                      //               },
                      //               icon: Icon(
                      //                 Icons.phone,
                      //                 color: Colors.black,
                      //               ))),
                      //     ])
                    ],
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async => await model.goToSellerPage(client.key),
                    child: Icon(
                      CupertinoIcons.forward,
                    ),
                  ),
                  // Icon(
                  //   Icons.arrow_right,
                  //   size: 40,
                  // ),
                ),
              ]),
            ),
          ),
        ));
  }

  Widget clientCardTailor(MapViewModel model, context, Tailor client, int index) {
    const double titleFontSize = titleFontSizeStyle;

    List<String> tempSplitName = client.name.split(" ");
    String shortName = tempSplitName.length > 1
        ? tempSplitName[0].substring(0, 1) +
            tempSplitName[tempSplitName.length - 1].substring(0, 1)
        : tempSplitName[0].substring(0, 2);
    return Padding(
        padding: EdgeInsets.only(left: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {
            model.currentClient = client;
            model.currentBearing = 90.0;
            model.zoomInMarker(client.contact.geoLocation.latitude,
                client.contact.geoLocation.longitude);
            controller.animateToPage(index);
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 5, 10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.black,
                              child: Text(
                                shortName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ))),
                      SizedBox(
                        width: 15,
                      ),
                      Tooltip(
                        message: client.name,
                        child: Text(
                          client.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: titleFontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Set<Marker> getMarkers(context, MapViewModel model, showSailors) {
    void createMarker(client, {bool isSeller = true}) {
      if (client.contact.geoLocation == null ||
          client.contact.geoLocation.latitude == null ||
          client.contact.geoLocation.longitude == null) {
        return;
      }

      var markerIdVal = client.key;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        icon: isSeller ? model.iconS : model.iconT,
        position: LatLng(client.contact.geoLocation.latitude,
            client.contact.geoLocation.longitude),
        draggable: false,
        infoWindow: InfoWindow(title: client.name, snippet: '*'),
        onTap: () {
          // showBottomSheet = true;
          model.currentClient = client;
          try{
            if((showSailors && isSeller) || (!showSailors && !isSeller))
            controller.animateToPage(carouselMap[client.key]);
          }catch(e){
            Fimber.e(e.toString());
          }
          // notifyListeners();
          // _navigationService.
          // showBottomSheet(context: GlobalKey<ScaffoldState>(), builder: null)
        },
      );
      model.markers[markerId] = marker;
    }

    if (model.tData != null)
      model.tData.items.forEach((t) {
        createMarker(t, isSeller: false);
      });

    if (model.sData != null)
      model.sData.items.forEach((s) {
        createMarker(s);
      });
    return Set<Marker>.of(model.markers.values);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MapViewModel>.withConsumer(
      viewModel: MapViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Scaffold(
            // appBar: AppBar(
            //   elevation: 0,
            //   backgroundColor: backgroundWhiteCreamColor,
            //   iconTheme: IconThemeData(color: appBarIconColor),
            // ),
            body: Stack(children: <Widget>[
              GoogleMap(
                onMapCreated: model.onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                markers: getMarkers(context, model, model.showSailors),
                initialCameraPosition: CameraPosition(
                  target: new LatLng(model.currentLocation.latitude,
                      model.currentLocation.longitude),
                  zoom: 12,
                ),
                compassEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
              ),
              Positioned(
                // top: MediaQuery.of(context).size.height -
                //     (model.showSailors ? 300.0 : 240.0),
                bottom: 10.0,
                left: 10.0,
                child: model.clientsToggle
                    ? Container(
                        height: model.showSailors ? 240.0 : 180,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(children: <Widget>[
                              SizedBox(width: 16),
                              InkWell(
                                  onTap: () {
                                    model.setClientCardsToSeller(true);
                                  },
                                  child: CustomCategoryChip(
                                      "assets/images/shop.png",
                                      "Designers",
                                      model.showSailors)),
                              SizedBox(width: 12),
                              InkWell(
                                  onTap: () {
                                    model.setClientCardsToSeller(false);
                                  },
                                  child: CustomCategoryChip(
                                      "assets/images/sewing.png",
                                      "Tailors",
                                      !model.showSailors)),
                            ]),
                            Container(
                              height: model.showSailors ? 160.0 : 100.0,
                              width: MediaQuery.of(context).size.width,
                              child: CarouselSlider(
                                carouselController: controller,
                                items: model.showSailors
                                    ? model.sData.items.asMap().entries.map((element) {
                                      carouselMap.addAll({element.value.key.toString(): element.key});
                                        return clientCardSeller(
                                            model, context, element.value, element.key);
                                      }).toList()
                                    : model.tData.items.asMap().entries.map((element) {
                                      carouselMap.addAll({element.value.key.toString(): element.key});
                                        return clientCardTailor(
                                            model, context, element.value, element.key);
                                      }).toList(),
                                options: CarouselOptions(
                                  autoPlay: false,
                                  enableInfiniteScroll: false,
                                ),
                              ),
                            )
                          ],
                        ))
                    : Container(height: 1.0, width: 1.0),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Icon(
                      Icons.navigate_before_rounded,
                      size: 50,
                    ),
                  ),
                ),
              ),
              // model.resetToggle
              //     ? Positioned(
              //         top: MediaQuery.of(context).size.height -
              //             (MediaQuery.of(context).size.height - 50.0),
              //         right: 15.0,
              //         child: FloatingActionButton(
              //           onPressed: model.resetCamera,
              //           mini: true,
              //           backgroundColor: Colors.red,
              //           child: Icon(Icons.refresh),
              //         ))
              //     : Container(),
              // model.resetToggle
              //     ? Positioned(
              //         top: MediaQuery.of(context).size.height -
              //             (MediaQuery.of(context).size.height - 50.0),
              //         right: 60.0,
              //         child: FloatingActionButton(
              //             onPressed: model.addBearing,
              //             mini: true,
              //             backgroundColor: Colors.green,
              //             child: Icon(Icons.rotate_left)))
              //     : Container(),
              // model.resetToggle
              //     ? Positioned(
              //         top: MediaQuery.of(context).size.height -
              //             (MediaQuery.of(context).size.height - 50.0),
              //         right: 110.0,
              //         child: FloatingActionButton(
              //             onPressed: model.removeBearing,
              //             mini: true,
              //             backgroundColor: Colors.blue,
              //             child: Icon(Icons.rotate_right)))
              //     : Container(),
              if (model.showBottomSheet)
                Container(
                  color: Colors.red,
                  height: 50,
                  child: Card(
                    child: InkWell(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(children: <Widget>[
                              Text(model.currentClient.name),
                              Container(
                                height: 200,
                                color: Colors.blue,
                              )
                            ]);
                          }),
                    ),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}

class CustomCategoryChip extends StatelessWidget {
  final String image;
  final String title;
  final bool focused;
  CustomCategoryChip(this.image, this.title, this.focused);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        children: <Widget>[Image.asset(image), SizedBox(width: 8), Text(title)],
      ),
      backgroundColor: Colors.grey[50],
      shape: StadiumBorder(
          side: BorderSide(
        color: Colors.black,
        width: focused ? 2.0 : 0.0,
      )),
    );
  }
}

class TailorIndiView extends StatelessWidget {
  final MapViewModel model;
  const TailorIndiView(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () => {},
        builder: (context) {
          return Column(children: <Widget>[
            Text(model.currentClient.name),
            Container(
              height: 200,
              color: Colors.blue,
            )
          ]);
        });
  }
}
