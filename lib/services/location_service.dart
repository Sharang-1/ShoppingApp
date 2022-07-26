import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';

class UserLocation {
  final double? latitude;
  final double? longitude;

  UserLocation({this.latitude, this.longitude});
}

class LocationService {
  // Keep track of current Location
  late UserLocation currentLocation;
  Location location = Location();
  // Continuously emit location updates
  StreamController<UserLocation> _locationController = StreamController<UserLocation>.broadcast();

  LocationService() {
    // getUserLocation();
    location.requestPermission().then((granted) {
        if (granted == PermissionStatus.granted) {
          location.onLocationChanged.listen(((locationData) {
            if (locationData != null) {
              currentLocation = UserLocation(
                latitude: locationData.latitude,
                longitude: locationData.longitude,
              );
              _locationController.add(currentLocation);
              // Fimber.d("location update-> " + locationData.toString());
            }
          }));
        } else {
          // TODO : handle loaction permission denied

        }
      });
  }

  // Future<dynamic> getUserLocation() async {
  //   bool serviceStatus = await location.serviceEnabled();
  //   PermissionStatus _permissionStatus;
  //   LocationData _locationData;

  //   if (serviceStatus) {
  //     _permissionStatus = await location.requestPermission();
  //     if (_permissionStatus == PermissionStatus.denied ||
  //         _permissionStatus == PermissionStatus.deniedForever) {
        
  //     }else{
  //       _locationData = await location.getLocation();
  //       if (_locationData != null) {
  //         currentLocation =
  //             UserLocation(longitude: _locationData.longitude, latitude: _locationData.latitude);
  //         _locationController.add(currentLocation);
  //       }
  //     }

  //     location.requestPermission().then((granted) {
  //       if (granted == PermissionStatus.granted) {
  //         location.onLocationChanged.listen(((locationData) {
  //           if (locationData != null) {
  //             currentLocation = UserLocation(
  //               latitude: locationData.latitude,
  //               longitude: locationData.longitude,
  //             );
  //             _locationController.add(currentLocation);
  //             // Fimber.d("location update-> " + locationData.toString());
  //           }
  //         }));
  //       } else {
  //         // TODO : handle loaction permission denied

  //       }
  //     });
  //   }
  // }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation?> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
      Fimber.d("location -> " + userLocation.toString());
    } catch (e) {
      print('Could not get the location: $e');
      return null;
    }

    return currentLocation;
  }
}
