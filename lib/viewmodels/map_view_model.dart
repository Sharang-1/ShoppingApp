import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../locator.dart';
import '../models/sellers.dart';
import '../models/tailors.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/location_service.dart';
import 'base_model.dart';

class MapViewModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();
  final APIService _apiService = locator<APIService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

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
  Future<void> init({String sellerKey}) async {
    currentLocation = _locationService.currentLocation ??
        UserLocation(
            latitude: 23.0204975,
            longitude: 72.43931); //Default Value for current Location
    mapToggle = true;
    populateClients(sellerKey: sellerKey);

    ImageConfiguration configuration = ImageConfiguration(size: Size(1, 1));
    iconT = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/pin.png');
    // iconT = Icons.shopping_cart;
    iconS = await BitmapDescriptor.fromAssetImage(
        configuration, 'assets/images/location.png');

    try {
      await _analyticsService.sendAnalyticsEvent(eventName: "map_opened");
    } catch (e) {}
  }

  populateClients({String sellerKey}) async {
    clients = [];
    Future<Tailors> tailors = _apiService.getTailors();
    Future<Sellers> sellers =
        _apiService.getSellers(queryString: "startIndex=0;limit=1000;");
    List apiData = await Future.wait([tailors, sellers]);

    tData = apiData[0] as Tailors;
    sData = apiData[1] as Sellers;
    sData.items = sData.items
        .where((s) => s?.subscriptionTypeId?.toString() != '2')
        .toList();
    if (sData != null) {
      clientsToggle = true;
    }
    sData.items.shuffle();
    tData.items.shuffle();
    // sData.items = sData.items.sublist(0, 10);
    notifyListeners();

    if (sellerKey != null && sellerKey != '') {
      try {
        currentClient = sData.items.firstWhere((e) => (e.key == sellerKey));
        currentBearing = 90.0;
        zoomInMarker(currentClient?.contact?.geoLocation?.latitude,
            currentClient?.contact?.geoLocation?.longitude);
      } catch (e) {}
    }
  }

  void onMapCreated(controller) {
    mapController = controller;
  }

  void onLocationIconClicked() async {
    try {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 17.0,
        ),
      ));
    } catch (e) {}
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
      try {
        mapController.showMarkerInfoWindow(MarkerId(currentClient?.key));
      } catch (e) {}
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
