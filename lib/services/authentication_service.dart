import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref.dart';
import '../locator.dart';
import '../models/user.dart';
import 'api/api_service.dart';
import 'push_notification_service.dart';

class AuthenticationService {
  final APIService _apiService = locator<APIService>();

  late User _currentUser;
  User get currentUser => _currentUser;

  Future<dynamic> loginWithPhoneNo({
    required phoneNo,
    required resend,
    required name,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PhoneNo, phoneNo);
    if (!resend) {
      prefs.setString(Name, name);
    }
    return _apiService.sendOTP(phoneNo: phoneNo);
  }

  Future<dynamic> verifyOTP({
    required otp,
    required name,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNo = prefs.getString(PhoneNo) ?? "";
    return _apiService.verifyOTP(
      phoneNo: phoneNo,
      otp: otp,
      name: name,
      fcm: locator<PushNotificationService>().fcmToken,
    );
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(Authtoken);
    return token != null && token.isNotEmpty;
  }
}
