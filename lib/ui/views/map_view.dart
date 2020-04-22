import 'package:compound/models/sellers.dart';
import 'package:compound/models/tailors.dart';
import 'package:compound/viewmodels/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';

class MapView extends StatelessWidget {
  Widget clientCard(model, Seller client) {
    return Padding(
        padding: EdgeInsets.only(left: 2.0, top: 10.0),
        child: InkWell(
            onTap: () {
              model.currentClient = client;
              model.currentBearing = 90.0;
              model.zoomInMarker(client);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 160.0,
                  width: 255.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Center(child: Text(client.name))),
            )));
  }

  Set<Marker> getMarkers(context,MapViewModel model) {

    void createMarker(client,icon,{bool isSeller = true}) {
      var markerIdVal = client.key;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        icon: isSeller ? model.iconS : model.iconT,
        position: LatLng(
          client.contact.geoLocation.latitude,
          client.contact.geoLocation.longitude
        ),
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
   
    if(model.tData != null)
    model.tData.items.forEach((t) {
      createMarker(t,Icons.access_alarms,isSeller: false);
    });

    if(model.sData != null)
    model.sData.items.forEach((s) {
      createMarker(s,Icons.search);
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
                            return clientCard(model, element);
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
          if(model.showBottomSheet)
              Container(
                color: Colors.red,
                height: 50,
                child: Card(
                  child: InkWell(onTap: () =>  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(children: <Widget>[
                        Text(model.currentClient.name),
                        Container(
                          height: 200,
                          color: Colors.blue,
                        )
                      ]);
                    }),),),
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
