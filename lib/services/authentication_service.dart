import 'package:compound/locator.dart';
import 'package:compound/models/user.dart';
// import 'package:compound/services/analytics_service.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';

class AuthenticationService {
  final APIService _apiService = locator<APIService>();
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
    return _apiService.sendOTP(phoneNo: phoneNo);
  }

  Future<dynamic> verifyOTP({
    @required otp,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNo = prefs.getString(PhoneNo);
    return _apiService.verifyOTP(phoneNo: phoneNo, otp: otp);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Authtoken, "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MTo4ODY2NTM4MjA0IiwidXNlciI6IntcImFjY291bnROb25Mb2NrZWRcIjp0cnVlLFwiY3JlZGVudGlhbHNOb25FeHBpcmVkXCI6dHJ1ZSxcImFjY291bnROb25FeHBpcmVkXCI6dHJ1ZSxcImVuYWJsZWRcIjp0cnVlLFwidXNlcm5hbWVcIjpcIjkxOjg4NjY1MzgyMDRcIixcInJvbGVzXCI6W1wiUk9MRV9GaXhlZFwiXSxcInVzZXJJZFwiOjM5ODc4MTE4LFwicm9sZUlkXCI6Mzk4NzgxMTgsXCJmYWNlYm9va0xvZ2luXCI6ZmFsc2UsXCJtb2JpbGVMb2dpblwiOnRydWUsXCJyb2xlXCI6e1wicGVybWlzc2lvbnNcIjpbe1widHlwZVwiOntcInR5cGVcIjo3fSxcImxldmVsXCI6e1wibGV2ZWxcIjo4fX0se1widHlwZVwiOntcInR5cGVcIjoxfSxcImxldmVsXCI6e1wibGV2ZWxcIjo0fX0se1widHlwZVwiOntcInR5cGVcIjozfSxcImxldmVsXCI6e1wibGV2ZWxcIjowfX0se1widHlwZVwiOntcInR5cGVcIjo4fSxcImxldmVsXCI6e1wibGV2ZWxcIjo4fX0se1widHlwZVwiOntcInR5cGVcIjoyfSxcImxldmVsXCI6e1wibGV2ZWxcIjo0fX0se1widHlwZVwiOntcInR5cGVcIjo5fSxcImxldmVsXCI6e1wibGV2ZWxcIjo4fX0se1widHlwZVwiOntcInR5cGVcIjo0fSxcImxldmVsXCI6e1wibGV2ZWxcIjo2fX0se1widHlwZVwiOntcInR5cGVcIjo2fSxcImxldmVsXCI6e1wibGV2ZWxcIjo2fX0se1widHlwZVwiOntcInR5cGVcIjoxMH0sXCJsZXZlbFwiOntcImxldmVsXCI6MX19LHtcInR5cGVcIjp7XCJ0eXBlXCI6MTF9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjF9fV19fSIsImlhdCI6MTU4ODI2NDM4NSwiZXhwIjoxNTk2OTA0Mzg1fQ.DRRsyHhWR6CfPbCfAg1IzNmefs5chf1Vt9eOF0axx30");
    var token = prefs.get(Authtoken);
    return token != null;
  }

  // Unwanted APIs
  Future testApi() {
    _apiService.getProducts();
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

  //   await _apiService.createUser(_currentUser);
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
  //   //   _currentUser = await _apiService.getUser(user.uid);
  //   //   await _analyticsService.setUserProperties(userId: user.uid);
  //   // }
  // }
}
