import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
// import 'package:compound/services/analytics_service.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';

class AuthenticationService {
  final APIService _APIService = locator<APIService>();
  // final AnalyticsService _analyticsService = locator<AnalyticsService>();

  User _currentUser;
  User get currentUser => _currentUser;

  Future<dynamic> loginWithPhoneNo({
    @required phoneNo,
    @required resend,
    @required name,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PhoneNo, phoneNo);
    if (!resend) {
      prefs.setString(Name, name);
    }
    return _APIService.sendOTP(phoneNo: phoneNo);
  }

  Future<dynamic> verifyOTP({
    @required otp,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNo = prefs.getString(PhoneNo);
    return _APIService.verifyOTP(phoneNo: phoneNo, otp: otp);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get(Authtoken);
    return token != null;
  }

  // Unwanted APIs
  Future testApi() {
    _APIService.getProducts();
    Fimber.i("INFO Extra error message");
    Fimber.d("DEBUG test my flutter app");
    Fimber.w("WARN");
    Fimber.e("ERROR");
    return null;
  }

  // Future loginWithEmail({
  //   @required String email,
  //   @required String password,
  // }) async {
  // try {
  //   var authResult = await _firebaseAuth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );
  //   await _populateCurrentUser(authResult.user);
  //   return authResult.user != null;
  // } catch (e) {
  //   return e.message;
  // }
  // }

  // Future signUpWithEmail({
  //   @required String email,
  //   @required String password,
  //   @required String fullName,
  //   @required String role,
  // }) async {
  // try {
  //   var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );

  //   // create a new user profile on firestore
  //   _currentUser = User(
  //     id: authResult.user.uid,
  //     email: email,
  //     fullName: fullName,
  //     userRole: role,
  //   );

  //   await _APIService.createUser(_currentUser);
  //   await _analyticsService.setUserProperties(
  //     userId: authResult.user.uid,
  //     userRole: _currentUser.userRole,
  //   );

  //   return authResult.user != null;
  // } catch (e) {
  //   return e.message;
  // }
  // }

  // Future _populateCurrentUser() async {
  //   // if (user != null) {
  //   //   _currentUser = await _APIService.getUser(user.uid);
  //   //   await _analyticsService.setUserProperties(userId: user.uid);
  //   // }
  // }
}
