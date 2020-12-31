import 'dart:io';

import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationData {
  String type; //order details or promotion
  String pageName;

  String id;
  String title;
  String description; //order => updated status, order => changed deliveryDate
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();

  Future initialise() async {
    _fcm.requestNotificationPermissions();
    _fcm.configure();

    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      // Called when the app has been closed comlpetely and it's opened
      // from the push notification.
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        // _serialiseAndNavigate(message);
      },
      // Called when the app is in the background and it's opened
      // from the push notification.
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        // _serialiseAndNavigate(message);
      },

      onBackgroundMessage: (Map<String, dynamic> message) async {
        print('onBackgroundMessage: $message');
        // _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var type = notificationData['type'];

    if (type != null) {
      // Navigate to the create post view
      // if (view == 'create_post') {
      //   _navigationService.navigateTo(CreatePostViewRoute);
      // }
      switch (type) {
        case 1:
        case 2:
          //Todo : Add my order detail route, call data api based on order it
          _navigationService.navigateTo(MyOrdersRoute);
          break;
        case 3:
          _navigationService.navigateTo(PromotionProductRoute,
              arguments:
                  new PromotionProductsPageArg(promoTitle: message['id']));
          break;
        default:
      }
    }
  }
}
