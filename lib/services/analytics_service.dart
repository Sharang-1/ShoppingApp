import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../constants/server_urls.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties(
      {required String userId, required String userRole}) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
  }

  Future logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  Future logPostCreated({required bool hasImage}) async {
    await _analytics.logEvent(
      name: 'create_post',
      parameters: {'has_image': hasImage},
    );
  }

  Future setup() async {
    await Firebase.initializeApp();
    await _analytics.setAnalyticsCollectionEnabled(releaseMode);
    await setupCrashlytics();
    await setupFirebasePerformance();
  }

  Future setupFirebasePerformance() async {
    // FirebasePerformance _performance = FirebasePerformance.instance;
  }

  Future setupCrashlytics() async {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(releaseMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.log("App started");
  }

  Future sendAnalyticsEvent(
      {required String eventName,
      required Map<String, dynamic> parameters}) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }
}
