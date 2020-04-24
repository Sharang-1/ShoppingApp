import 'package:compound/models/sellers.dart';
import 'package:compound/viewmodels/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider_architecture/provider_architecture.dart';

class MapView extends StatelessWidget {
  String getTruncatedString(int length, String str) {
    return str.length <= length ? str : '${str.substring(0, length)}...';
  }

  Widget clientCard(MapViewModel model, context, Seller client) {
    double titleFontSize = 20.0;
    double priceFontSize = 18.0;
    final double ratings = 4;
    double ratingCountFontSize = 20.0;
    double tagSize = 14.0;
    int titleLength = 3;

    List<String> tags = [
      "Excellent",
      "superb",
    ];

    List<String> tempSplitName = client.name.split(" ");
    String shortName = tempSplitName.length > 1
        ? tempSplitName[0].substring(0, 1) +
            tempSplitName[tempSplitName.length - 1].substring(0, 1)
        : tempSplitName[0].substring(0, 2);

    return InkWell(
        onTap: () {
          model.currentClient = client;
          model.currentBearing = 90.0;
          model.zoomInMarker(client);
        },
        child: Container(
          padding: EdgeInsets.only(left: 2, top: 5),
          width: 300,
          child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                // side: BorderSide(color: Colors.black, width: 1)
              ),
              elevation: 5,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Tooltip(
                                  message: client.name,
                                  child: Text(
                                      getTruncatedString(
                                          titleLength, client.name),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: titleFontSize))),
                              // Text(
                              //   tailor.price.toString() + "\u20B9",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: priceFontSize,
                              //       color: Colors.black),
                              // ),
                            ])),
                    Flexible(
                        flex: 1,
                        child: Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                ratings.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ratingCountFontSize,
                                    fontWeight: FontWeight.w800),
                              )),
                          RatingBarIndicator(
                            rating: ratings,
                            itemCount: 5,
                            itemSize: ratingCountFontSize,
                            direction: Axis.horizontal,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                        ])),
                    Flexible(
                        flex: 1,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: tags.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                                padding:
                                                    EdgeInsets.only(right: 3),
                                                child: Chip(
                                                    elevation: 2,
                                                    backgroundColor:
                                                        Colors.amberAccent[700],
                                                    label: Text(
                                                      tags[index],
                                                      style: TextStyle(
                                                          fontSize: tagSize,
                                                          color: Colors.black),
                                                    )));
                                          }))),
                              CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ))),
                            ]))
                  ],
                ),
              )),
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
                  height: 125.0,
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

