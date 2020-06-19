import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/services/push_notification_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService = locator<PushNotificationService>();

  Future init() async {
    // Register for push notifications
    // await _pushNotificationService.initialise();
    // _authenticationService.testApi();
    // var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final productSearchHistoryList = prefs.getStringList(ProductSearchHistoryList);
    final sellerSearchHistoryList = prefs.getStringList(SellerSearchHistoryList);

    if(productSearchHistoryList == null) prefs.setStringList(ProductSearchHistoryList, []);
    if(sellerSearchHistoryList == null) prefs.setStringList(SellerSearchHistoryList, []);

    Future.delayed(Duration(milliseconds: 2000), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(Authtoken, "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MTo3MDE2NzM4NDQyIiwidXNlciI6IntcImFjY291bnROb25Mb2NrZWRcIjp0cnVlLFwiY3JlZGVudGlhbHNOb25FeHBpcmVkXCI6dHJ1ZSxcImFjY291bnROb25FeHBpcmVkXCI6dHJ1ZSxcImVuYWJsZWRcIjp0cnVlLFwidXNlcm5hbWVcIjpcIjkxOjcwMTY3Mzg0NDJcIixcInJvbGVzXCI6W1wiUk9MRV9GaXhlZFwiXSxcInVzZXJJZFwiOjg1MjkyLFwicm9sZUlkXCI6ODUyOTIsXCJmYWNlYm9va0xvZ2luXCI6ZmFsc2UsXCJtb2JpbGVMb2dpblwiOnRydWUsXCJyb2xlXCI6e1wicGVybWlzc2lvbnNcIjpbe1widHlwZVwiOntcInR5cGVcIjoyfSxcImxldmVsXCI6e1wibGV2ZWxcIjo0fX0se1widHlwZVwiOntcInR5cGVcIjoxMH0sXCJsZXZlbFwiOntcImxldmVsXCI6MX19LHtcInR5cGVcIjp7XCJ0eXBlXCI6OH0sXCJsZXZlbFwiOntcImxldmVsXCI6OH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6M30sXCJsZXZlbFwiOntcImxldmVsXCI6MH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6OX0sXCJsZXZlbFwiOntcImxldmVsXCI6OH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6MX0sXCJsZXZlbFwiOntcImxldmVsXCI6NH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6Nn0sXCJsZXZlbFwiOntcImxldmVsXCI6Nn19LHtcInR5cGVcIjp7XCJ0eXBlXCI6MTF9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjF9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjR9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjZ9fSx7XCJ0eXBlXCI6e1widHlwZVwiOjd9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjh9fV19fSIsImlhdCI6MTU5MDMwMjEyMSwiZXhwIjoxNTk4OTQyMTIxfQ.zbG-1N03nvxWtYnK_j-t3D7ZXWwtgrDBBriGw2ncxQU");
      var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
      if (hasLoggedInUser) {
        _navigationService.navigateReplaceTo(HomeViewRoute);
      } else {
        _navigationService.navigateReplaceTo(LoginViewRoute);
      }
    });
  }
}
