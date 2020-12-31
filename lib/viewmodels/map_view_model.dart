import 'package:compound/locator.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/tailors.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_model.dart';

class MapViewModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();
  final APIService _apiService = locator<APIService>();

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;
  bool showBottomSheet = false;
  bool showSailors = true;
  UserLocation currentLocation;
  var clients = [];
  dynamic currentClient;
  var currentBearing;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor iconS, iconT;
  GoogleMapController mapController;

  Tailors tData;
  Sellers sData;
  Future<void> init() async {
    currentLocation = _locationService.currentLocation ??
        UserLocation(
            latitude: 23.0204975,
            longitude: 72.43931); //Default Value for current Location
    mapToggle = true;
    populateClients();

    ImageConfiguration configuration = ImageConfiguration(size: Size(2, 2));
    iconT = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/location.png');
    // iconT = Icons.shopping_cart;
    iconS = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/pin.png');
  }

  populateClients() async {
    clients = [];
    Future<Tailors> tailors = _apiService.getTailors();
    Future<Sellers> sellers = _apiService.getSellers();
    List apiData = await Future.wait([tailors, sellers]);

    tData = apiData[0] as Tailors;
    sData = apiData[1] as Sellers;
    sData.items = sData.items.where((s) => s.accountType != '2').toList();
    if (sData != null) {
      clientsToggle = true;
    }
    notifyListeners();
  }

  void onMapCreated(controller) {
    mapController = controller;
  }

  setClientCardsToSeller(bool toSeller) {
    showSailors = toSeller;
    notifyListeners();
  }

  zoomInMarker(double latitude, double longitude) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 17.0,
            bearing: 90.0,
            tilt: 45.0)))
        .then((val) {
      resetToggle = true;
      notifyListeners();
    });
  }

  resetCamera() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 10.0)))
        .then((val) {
      resetToggle = false;
      notifyListeners();
    });
  }

  addBearing() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentClient.contact.geoLocation.latitude,
                currentClient.contact.geoLocation.longitude),
            bearing: currentBearing == 360.0
                ? currentBearing
                : currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      if (currentBearing == 360.0) {
      } else {
        currentBearing = currentBearing + 90.0;
      }

      notifyListeners();
    });
  }

  removeBearing() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(currentClient.contact.geoLocation.latitude,
                currentClient.contact.geoLocation.longitude),
            bearing:
                currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      if (currentBearing == 0.0) {
      } else {
        currentBearing = currentBearing - 90.0;
      }
      notifyListeners();
    });
  }
}
