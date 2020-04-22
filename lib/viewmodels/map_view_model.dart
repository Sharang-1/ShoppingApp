
import 'package:compound/locator.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/models/tailors.dart';
import 'package:compound/services/analytics_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/location_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_model.dart';

class MapViewModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final APIService _apiService = locator<APIService>();

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;
  bool showBottomSheet = false;
  UserLocation currentLocation;
  var clients = [];
  Tailor currentClient;
  var currentBearing;
  
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor iconS,iconT; 
  GoogleMapController mapController;

  Tailors tData;
  Sellers sData ;
  Future<void> init() async {
    currentLocation = _locationService.currentLocation;
    mapToggle = true;
    populateClients();
    
    ImageConfiguration configuration = ImageConfiguration();
    iconT = await BitmapDescriptor.fromAssetImage(configuration, 'assets/marker.png');
    iconS = await BitmapDescriptor.fromAssetImage(configuration, 'assets/marker2.png');
    return;
  }

   populateClients() async {
    clients = [];
    Future<Tailors> tailors = _apiService.getTailors();
    Future<Sellers> sellers = _apiService.getSellers();
    List apiData = await Future.wait([tailors,sellers]);

    tData = apiData[0];
    sData = apiData[1];
    
    if(sData != null){
      clientsToggle = true;
      // for (int i = 0; i < tData.tailors.length; ++i) {
      //   Tailor ct = tData.tailors[i];
      //   Fimber.d("Tailors Data - >" + ct.contact.geoLocation.latitude.toString() + " " + ct.contact.geoLocation.longitude.toString()) ;
      //   if(ct.contact.geoLocation !=null && ct.contact.geoLocation.latitude != null && ct.contact.geoLocation.longitude != null){
      //   }
      // }
      // sData.items.forEach((Seller cs) {
      //   if(cs.contact.geoLocation !=null && cs.contact.geoLocation.latitude != null && cs.contact.geoLocation.longitude != null){
      //     clients.add(cs);
      //   }
      // });
    }
    notifyListeners();
  }

  
   void onMapCreated(controller) {
      mapController = controller;
  }

  zoomInMarker(Tailor client) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
                client.contact.geoLocation.latitude, client.contact.geoLocation.longitude),
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
        .animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(currentLocation.latitude,currentLocation.longitude), zoom: 10.0)))
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
