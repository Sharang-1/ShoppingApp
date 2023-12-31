// import 'package:compound/utils/lang/translation_keys.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
// import 'package:get/get.dart';

// import '../constants/route_names.dart';
// import '../constants/shared_pref.dart';
// import '../locator.dart';
// import '../models/sellers.dart';
// import '../models/tailors.dart';
// import '../services/analytics_service.dart';
// import '../services/api/api_service.dart';
// import '../services/location_service.dart';
// import '../services/navigation_service.dart';
// import '../ui/shared/app_colors.dart';
// import 'base_controller.dart';
// import 'home_controller.dart';

// class hostMapController extends BaseController {
//   final LocationService _locationService = locator<LocationService>();
//   final APIService _apiService = locator<APIService>();
//   final AnalyticsService _analyticsService = locator<AnalyticsService>();

//   late GoogleMapController? mapController;

//   bool mapToggle = false;
//   bool clientsToggle = false;
//   bool resetToggle = false;
//   bool showBottomSheet = false;
//   bool showSailors = true;
//   var clients = [];
//   dynamic currentClient;
//   var currentBearing;
//   UserLocation currentLocation = UserLocation();
//   String cityName = locator<HomeController>().cityName;

//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   BitmapDescriptor? iconS, iconT;

//   Tailors? tData;
//   Sellers? sData;

//   final String sellerKey;
//   final BuildContext context;
//   final GlobalKey _cardsKey = GlobalKey();

//   GlobalKey get cardsKey => _cardsKey;

//   hostMapController(this.context,
//       {required this.sellerKey,
//       this.sData,
//       this.tData,
//       this.iconS,
//       this.iconT,
//       this.mapController});

//   final List<TabItem> navigationItems = [
//     TabItem(
//       title: NAVBAR_CATEGORIES.tr,
//       icon: Padding(
//         padding: const EdgeInsets.only(top: 4.0),
//         child: Image.asset(
//           "assets/images/nav_categories.png",
//           color: newBackgroundColor,
//         ),
//       ),
//     ),
//     TabItem(
//       title: NAVBAR_ORDERS.tr,
//       icon: Padding(
//         padding: const EdgeInsets.only(top: 4.0),
//         child: Image.asset(
//           "assets/images/nav_orders.png",
//           color: newBackgroundColor,
//         ),
//       ),
//     ),
//     TabItem(
//       title: '',
//       icon: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Image.asset(
//           "assets/images/logo.png",
//           // color: logoRed,
//           height: 15,
//           width: 15,
//         ),
//       ),
//     ),
//     TabItem(
//       title: NAVBAR_APPOINTMENTS.tr,
//       icon: Padding(
//         padding: const EdgeInsets.only(top: 4.0),
//         child: Image.asset(
//           "assets/images/nav_appointment.png",
//           color: newBackgroundColor,
//         ),
//       ),
//     ),
//     TabItem(
//       title: NAVBAR_MAPS.tr,
//       icon: Padding(
//         padding: const EdgeInsets.only(top: 4.0),
//         child: Image.asset(
//           "assets/images/nav_map.png",
//           color: newBackgroundColor,
//         ),
//       ),
//     ),
//   ];

//   bool bottomNavigationOnTap(int i) {
//     switch (i) {
//       case 0:
//         NavigationService.to(CategoriesRoute);
//         break;
//       case 1:
//         NavigationService.to(MyOrdersRoute);
//         break;
//       case 2:
//         // NavigationService.to(hostExploreViewRoute);
//         break;
//       case 3:
//         NavigationService.to(MyAppointmentViewRoute);
//         break;
//       case 4:
//         break;
//       default:
//         break;
//     }
//     return false;
//   }

//   void onCityNameTap() async {
//     await locator<HomeController>().onCityNameTap();
//     cityName = locator<HomeController>().cityName;
//     update();
//   }

//   @override
//   void onInit() async {
//     super.onInit();

//     currentLocation = (await _locationService.getLocation()) ??
//         UserLocation(latitude: 23.0204975, longitude: 72.43931);
//     mapToggle = true;
//     populateClients(sellerKey: sellerKey);

//     update();

//     ImageConfiguration configuration = ImageConfiguration(size: Size(1, 1));
//     iconT = await BitmapDescriptor.fromAssetImage(
//       configuration,
//       'assets/images/pin.png',
//     );
//     iconS = await BitmapDescriptor.fromAssetImage(
//         configuration, 'assets/images/pin2.png');

//     try {
//       await _analyticsService
//           .sendAnalyticsEvent(eventName: "map_opened", parameters: {});
//     } catch (e) {}
//   }

//   populateClients({String? sellerKey}) async {
//     clients = [];
//     Future<Tailors> tailors = _apiService.getTailors();
//     Future<Sellers> sellers =
//         _apiService.getSellers(queryString: "startIndex=0;limit=1000;");
//     List apiData = await Future.wait([tailors, sellers]);

//     tData = apiData[0] as Tailors;
//     sData = apiData[1] as Sellers;
//     sData!.items = sData!.items!
//         .where((s) => s.subscriptionTypeId?.toString() != '2')
//         .toList();
//     tData!.items = tData!.items!
//         .where((t) => (t.contact?.geoLocation?.latitude != null))
//         .toList();

//     if (sData != null) {
//       clientsToggle = true;
//     }

//     sData!.items!.shuffle();
//     tData!.items!.shuffle();
//     update();

//     if (sellerKey != null && sellerKey != '') {
//       try {
//         currentClient = sData!.items!.firstWhere((e) => (e.key == sellerKey));
//         currentBearing = 90.0;
//         zoomInMarker(currentClient?.contact?.geoLocation?.latitude,
//             currentClient?.contact?.geoLocation?.longitude);
//       } catch (e) {}
//     }

//     showTutorial(context, cardsKey: _cardsKey);
//   }

//   void onMapCreated(controller) {
//     mapController = controller;
//   }

//   void onLocationIconClicked() async {
//     try {
//       mapController!.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(
//           bearing: 0,
//           target: LatLng(
//             currentLocation.latitude ?? 23.0204975,
//             currentLocation.longitude ?? 72.43931,
//           ),
//           zoom: 17.0,
//         ),
//       ));
//     } catch (e) {}
//   }

//   setClientCardsToSeller(bool toSeller) {
//     showSailors = toSeller;
//     update();
//   }

//   zoomIn() async {
//     mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//             target: currentClient == null
//                 ? LatLng(
//                     currentLocation.latitude ?? 23.0204975,
//                     currentLocation.longitude ?? 72.43931,
//                   )
//                 : LatLng(
//                     currentClient.contact.geoLocation.latitude,
//                     currentClient.contact.geoLocation.longitude,
//                   ),
//             zoom: (await mapController!.getZoomLevel()) + 2),
//       ),
//     );
//   }

//   zoomOut() async {
//     mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//             target: currentClient == null
//                 ? LatLng(
//                     currentLocation.latitude ?? 23.0204975,
//                     currentLocation.longitude ?? 72.43931,
//                   )
//                 : LatLng(
//                     currentClient.contact.geoLocation.latitude,
//                     currentClient.contact.geoLocation.longitude,
//                   ),
//             zoom: (await mapController!.getZoomLevel()) - 2),
//       ),
//     );
//   }

//   zoomInMarker(double latitude, double longitude) {
//     mapController!
//         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(latitude, longitude),
//             zoom: 17.0,
//             bearing: 90.0,
//             tilt: 45.0)))
//         .then((val) {
//       resetToggle = true;
//       try {
//         mapController!.showMarkerInfoWindow(MarkerId(currentClient?.key));
//       } catch (e) {}
//       update();
//     });
//   }

//   resetCamera() {
//     mapController!
//         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(currentLocation.latitude ?? 23.0204975,
//                 currentLocation.longitude ?? 72.43931),
//             zoom: 10.0)))
//         .then((val) {
//       resetToggle = false;
//       update();
//     });
//   }

//   addBearing() {
//     mapController!
//         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(currentClient.contact.geoLocation.latitude,
//                 currentClient.contact.geoLocation.longitude),
//             bearing: currentBearing == 360.0
//                 ? currentBearing
//                 : currentBearing + 90.0,
//             zoom: 17.0,
//             tilt: 45.0)))
//         .then((val) {
//       if (currentBearing == 360.0) {
//       } else {
//         currentBearing = currentBearing + 90.0;
//       }

//       update();
//     });
//   }

//   removeBearing() {
//     mapController!
//         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(currentClient.contact.geoLocation.latitude,
//                 currentClient.contact.geoLocation.longitude),
//             bearing:
//                 currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
//             zoom: 17.0,
//             tilt: 45.0)))
//         .then((val) {
//       if (currentBearing == 0.0) {
//       } else {
//         currentBearing = currentBearing - 90.0;
//       }
//       update();
//     });
//   }

//   String getStringWithBullet(String s) {
//     if (s == null) return "${String.fromCharCode(0x2022)} No Data";
//     return "${s == "" ? "" : String.fromCharCode(0x2022)} $s";
//   }

//   void showTutorial(BuildContext context, {GlobalKey? cardsKey}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getBool(ShouldShowMapTutorial) ?? true) {
//       late TutorialCoachMark tutorialCoachMark;
//       List<TargetFocus> targets = <TargetFocus>[
//         TargetFocus(
//           identify: "Map Target",
//           keyTarget: cardsKey,
//           shape: ShapeLightFocus.RRect,
//           contents: [
//             TargetContent(
//               align: ContentAlign.top,
//               child: GestureDetector(
//                 onTap: () {
//                   tutorialCoachMark.next();
//                 },
//                 child: Container(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "host Map",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20.0,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Text(
//                           "Find Designers and Tailor Near You",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ];
//       tutorialCoachMark = TutorialCoachMark(
//         context,
//         targets: targets,
//         colorShadow: Colors.black45,
//         hideSkip: true,
//         paddingFocus: 5,
//         onClickOverlay: (targetFocus) => tutorialCoachMark.next(),
//         onClickTarget: (targetFocus) => tutorialCoachMark.next(),
//         onFinish: () async => await prefs.setBool(ShouldShowMapTutorial, false),
//       )..show();
//     }
//   }
// }
