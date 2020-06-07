// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';

import 'package:compound/models/sellers.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/viewmodels/map_view_model.dart';

import '../shared/shared_styles.dart';

class MapView extends StatelessWidget {
  String getTruncatedString(int length, String str) {
    return (str.length <= length ? str : '${str.substring(0, length)}...')
        .replaceAll("\n", " ");
  }

  Widget clientCard(MapViewModel model, context, Seller client) {
    const double titleFontSize = titleFontSizeStyle;
    const double subtitleFontSize = subtitleFontSizeStyle - 3;

    // List<String> tags = [
    //   "Excellent",
    //   "superb",
    // ];

    List<String> tempSplitName = client.name.split(" ");
    String shortName = tempSplitName.length > 1
        ? tempSplitName[0].substring(0, 1) +
            tempSplitName[tempSplitName.length - 1].substring(0, 1)
        : tempSplitName[0].substring(0, 2);
    print(client.operations ?? "No data");
    return Padding(
        padding: EdgeInsets.only(left: 10.0, top: 10.0),
        child: InkWell(
          onTap: () {
            model.currentClient = client;
            model.currentBearing = 90.0;
            model.zoomInMarker(client);
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
                        SizedBox(
                          width: 15,
                        ),
                        Tooltip(
                            message: client.name,
                            child: Text(getTruncatedString(20, client.name),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: titleFontSize))),
                      ]),
                      verticalSpace(15),
                      Text(
                          getTruncatedString(
                              100, client.operations ?? "No Data"),
                          style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: Colors.red[300])),

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
                Center(child: Icon(CupertinoIcons.forward)
                    // Icon(
                    //   Icons.arrow_right,
                    //   size: 40,
                    // ),
                    )
              ]),
            ),
          ),
        ));
  }

  Set<Marker> getMarkers(context, MapViewModel model) {
    void createMarker(client, icon, {bool isSeller = true}) {
      if (client.contact.geoLocation == null ||
          client.contact.geoLocation.latitude == null ||
          client.contact.geoLocation.longitude == null) {
        return;
      }

      var markerIdVal = client.key;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        // icon: isSeller ? model.iconS : model.iconT,
        position: LatLng(client.contact.geoLocation.latitude,
            client.contact.geoLocation.longitude),
        draggable: false,
        infoWindow: InfoWindow(title: client.name, snippet: '*'),
        onTap: () {
          // showBottomSheet = true;
          model.currentClient = client;
          // notifyListeners();
          // _navigationService.
          // showBottomSheet(context: GlobalKey<ScaffoldState>(), builder: null)
        },
      );
      model.markers[markerId] = marker;
    }

    if (model.tData != null)
      model.tData.items.forEach((t) {
        createMarker(t, Icons.access_alarms, isSeller: false);
      });

    if (model.sData != null)
      model.sData.items.forEach((s) {
        createMarker(s, Icons.search);
      });
    return Set<Marker>.of(model.markers.values);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MapViewModel>.withConsumer(
      viewModel: MapViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: model.onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            markers: getMarkers(context, model),
            initialCameraPosition: CameraPosition(
              target: new LatLng(model.currentLocation.latitude,
                  model.currentLocation.longitude),
              zoom: 8,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height - 250.0,
              left: 10.0,
              child: Container(
                  height: 180.0,
                  width: MediaQuery.of(context).size.width,
                  child: model.clientsToggle
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8.0),
                          children: model.sData.items.map((element) {
                            return clientCard(model, context, element);
                          }).toList(),
                        )
                      : Container(height: 1.0, width: 1.0))),
          model.resetToggle
              ? Positioned(
                  top: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height - 50.0),
                  right: 15.0,
                  child: FloatingActionButton(
                    onPressed: model.resetCamera,
                    mini: true,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.refresh),
                  ))
              : Container(),
          model.resetToggle
              ? Positioned(
                  top: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height - 50.0),
                  right: 60.0,
                  child: FloatingActionButton(
                      onPressed: model.addBearing,
                      mini: true,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.rotate_left)))
              : Container(),
          model.resetToggle
              ? Positioned(
                  top: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height - 50.0),
                  right: 110.0,
                  child: FloatingActionButton(
                      onPressed: model.removeBearing,
                      mini: true,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.rotate_right)))
              : Container(),
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
