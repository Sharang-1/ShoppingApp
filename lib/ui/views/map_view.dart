import 'package:carousel_slider/carousel_slider.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/dzor_map_controller.dart';
import '../../models/sellers.dart';
import '../../models/tailors.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class MapView extends StatelessWidget {
  final CarouselController carouselController = CarouselController();
  final Map<String, int> carouselMap = {};
  final String sellerKey;

  MapView({this.sellerKey});

  Widget clientCardSeller(
      DzorMapController dzorMapController, context, Seller client, int index) {
    const double titleFontSize = titleFontSizeStyle;
    const double subtitleFontSize = subtitleFontSizeStyle - 3;

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
            dzorMapController.currentClient = client;
            dzorMapController.currentBearing = 90.0;
            dzorMapController.zoomInMarker(client.contact.geoLocation.latitude,
                client.contact.geoLocation.longitude);
            carouselController.animateToPage(index);
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
                            backgroundColor: darkRedSmooth,
                            child: Text(
                              shortName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: backgroundWhiteCreamColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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
                          dzorMapController.getStringWithBullet(client.works),
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: lightGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      verticalSpace(5),
                      Expanded(
                        child: Text(
                          dzorMapController
                              .getStringWithBullet(client.operations),
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
                    onTap: () async =>
                        await BaseController.goToSellerPage(client.key),
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

  Widget clientCardTailor(
      DzorMapController dzorMapController, context, Tailor client, int index) {
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
          dzorMapController.currentClient = client;
          dzorMapController.currentBearing = 90.0;
          dzorMapController.zoomInMarker(client.contact.geoLocation.latitude,
              client.contact.geoLocation.longitude);
          carouselController.animateToPage(index);
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: backgroundWhiteCreamColor,
                            child: Text(
                              shortName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: darkRedSmooth,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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
                    if (client?.contact?.primaryNumber?.mobile != null &&
                        client?.contact?.primaryNumber?.mobile != '0000000000')
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              String contactNo =
                                  client?.contact?.primaryNumber?.mobile;
                              return await launch("tel://$contactNo");
                            },
                            child: Icon(Icons.call_outlined,
                                size: 30, color: Colors.green),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> getMarkers(
      context, DzorMapController dzorMapController, showSailors) {
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
        icon: isSeller ? dzorMapController.iconS : dzorMapController.iconT,
        position: LatLng(client.contact.geoLocation.latitude,
            client.contact.geoLocation.longitude),
        draggable: false,
        infoWindow: InfoWindow(title: client.name),
        onTap: () {
          // showBottomSheet = true;
          dzorMapController.currentClient = client;
          try {
            if ((showSailors && isSeller) || (!showSailors && !isSeller))
              carouselController.animateToPage(carouselMap[client.key]);
          } catch (e) {
            Fimber.e(e.toString());
          }
          // notifyListeners();
          // _navigationService.
          // showBottomSheet(context: GlobalKey<ScaffoldState>(), builder: null)
        },
      );
      dzorMapController.markers[markerId] = marker;
    }

    if (dzorMapController.tData != null)
      dzorMapController.tData.items.forEach((t) {
        createMarker(t, isSeller: false);
      });

    if (dzorMapController.sData != null)
      dzorMapController.sData.items.forEach((s) {
        createMarker(s);
      });
    return Set<Marker>.of(dzorMapController.markers.values);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DzorMapController>(
      init: DzorMapController(context, sellerKey: sellerKey),
      builder: (dzorMapController) => Scaffold(
        body: SafeArea(
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: dzorMapController.onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  markers: getMarkers(context, dzorMapController,
                      dzorMapController.showSailors),
                  initialCameraPosition: CameraPosition(
                    target: new LatLng(
                      dzorMapController?.currentLocation?.latitude ??
                          23.0204975,
                      dzorMapController?.currentLocation?.longitude ?? 72.43931,
                    ),
                    zoom: 12,
                  ),
                  compassEnabled: false,
                  mapToolbarEnabled: true,
                  zoomControlsEnabled: false,
                ),
                // Positioned(child: SearchWidget(
                //   dataList: List.generate(dzorMapController.clients.length, (i) => Text(dzorMapController.clients[i].name)),
                // )),
                Positioned(
                  bottom: 10.0,
                  child: dzorMapController.clientsToggle
                      ? Container(
                          key: dzorMapController.cardsKey,
                          height: dzorMapController.showSailors ? 240.0 : 180,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        SizedBox(width: 16),
                                        InkWell(
                                            onTap: () {
                                              dzorMapController
                                                  .setClientCardsToSeller(true);
                                            },
                                            child: CustomCategoryChip(
                                                "assets/images/shop.png",
                                                "Designers",
                                                dzorMapController.showSailors)),
                                        SizedBox(width: 12),
                                        InkWell(
                                            onTap: () {
                                              dzorMapController
                                                  .setClientCardsToSeller(
                                                      false);
                                            },
                                            child: CustomCategoryChip(
                                                "assets/images/sewing.png",
                                                "Tailors",
                                                !dzorMapController
                                                    .showSailors)),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: () => dzorMapController
                                            .onLocationIconClicked(),
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(),
                                          child: Icon(
                                            Icons.gps_fixed_rounded,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: dzorMapController.showSailors
                                    ? 160.0
                                    : 100.0,
                                width: MediaQuery.of(context).size.width,
                                child: CarouselSlider(
                                  carouselController: carouselController,
                                  items: dzorMapController.showSailors
                                      ? dzorMapController.sData.items
                                          .asMap()
                                          .entries
                                          .map((element) {
                                          carouselMap.addAll({
                                            element.value.key.toString():
                                                element.key
                                          });
                                          return clientCardSeller(
                                              dzorMapController,
                                              context,
                                              element.value,
                                              element.key);
                                        }).toList()
                                      : dzorMapController.tData.items
                                          .asMap()
                                          .entries
                                          .map((element) {
                                          carouselMap.addAll({
                                            element.value.key.toString():
                                                element.key
                                          });
                                          return clientCardTailor(
                                              dzorMapController,
                                              context,
                                              element.value,
                                              element.key);
                                        }).toList(),
                                  options: CarouselOptions(
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    initialPage: carouselMap[sellerKey] ?? 0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
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
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                //     child: InkWell(
                //       onTap: () => dzorMapController.onLocationIconClicked(),
                //       child: Container(
                //         padding: EdgeInsets.all(8.0),
                //         decoration: BoxDecoration(),
                //         child: Icon(
                //           Icons.gps_fixed_rounded,
                //           size: 30,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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
                if (dzorMapController.showBottomSheet)
                  Container(
                    color: Colors.red,
                    height: 50,
                    child: Card(
                      child: InkWell(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(children: <Widget>[
                                Text(dzorMapController.currentClient.name),
                                Container(
                                  height: 200,
                                  color: Colors.blue,
                                )
                              ]);
                            }),
                      ),
                    ),
                  )
              ],
            ),
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
        children: <Widget>[
          Image.asset(
            image,
            color: focused ? Colors.white : logoRed,
          ),
          SizedBox(width: 8),
          Text(title, style: TextStyle(color: focused ? Colors.white : logoRed))
        ],
      ),
      backgroundColor: focused ? logoRed : Colors.grey[50],
      shape: StadiumBorder(
          side: BorderSide(
        color: focused ? backgroundWhiteCreamColor : logoRed,
        width: focused ? 2.0 : 0.0,
      )),
    );
  }
}

class TailorIndiView extends StatelessWidget {
  final DzorMapController dzorMapController;
  const TailorIndiView(this.dzorMapController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () => {},
        builder: (context) {
          return Column(children: <Widget>[
            Text(dzorMapController.currentClient.name),
            Container(
              height: 200,
              color: Colors.blue,
            )
          ]);
        });
  }
}
