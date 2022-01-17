import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../constants/route_names.dart';
import 'navigation_service.dart';

class PushNotificationData {
  String? type; //order details or promotion
  String? pageName;

  String? id;
  String? title;
  String? description; //order => updated status, order => changed deliveryDate
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String fcmToken = '';

  Future initialise() async {
    // _fcm.requestNotificationPermissions(
    //   IosNotificationSettings(
    //     alert: true,
    //     badge: true,
    //   ),
    // );

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // _fcm.configure();

    fcmToken = (await _fcm.getToken()) ?? "";
    Fimber.i("FCM Token : $fcmToken");

    _fcm.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      Fimber.i("FCM Token : $fcmToken");
    });

    // _fcm.configure(
    //   // Called when the app is in the foreground and we receive a push notification
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('onMessage: $message');
    //     try {
    //       String title = Platform.isIOS
    //           ? message['aps']['alert']['title']
    //           : message['notification']['title'];
    //       String body = Platform.isIOS
    //           ? message['aps']['alert']['body']
    //           : message['notification']['body'];
    //       showSimpleNotification(
    //         GestureDetector(
    //           child: Container(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   title,
    //                 ),
    //                 Text(
    //                   body,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           onTap: () => _serialiseAndNavigate(message),
    //         ),
    //         duration: Duration(seconds: 3),
    //         background: Colors.white,
    //         foreground: Colors.black,
    //         position: NotificationPosition.top,
    //       );
    //     } catch (e) {
    //       print(e.toString());
    //     }
    //   },
    //   // Called when the app has been closed comlpetely and it's opened
    //   // from the push notification.
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onLaunch: $message');
    //     _serialiseAndNavigate(message);
    //   },
    //   // Called when the app is in the background and it's opened
    //   // from the push notification.
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //     _serialiseAndNavigate(message);
    //   },

    //   onBackgroundMessage: backgroundMessageHandler,
    // );
  }

  static Future backgroundMessageHandler(Map<String, dynamic> message) async {
    print('onBackgroundMessage: $message');
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    try {
      var notificationData = message['data'];
      String contentType = notificationData['type'];
      String id = notificationData['id'];

      print("Push Notification Data : $contentType $id");
      if (contentType != null) {
        Map<String, String> data = {
          "contentType": contentType,
          "id": id,
        };
        NavigationService.to(DynamicContentViewRoute, arguments: data);
      }
    } catch (e) {
      Fimber.e("Error");
    }
  }
}
