import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/route_names.dart';
import '../constants/shared_pref.dart';
import '../locator.dart';
import '../services/analytics_service.dart';
import '../services/api/api_service.dart';
import '../services/authentication_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/error_handling_service.dart';
import '../services/navigation_service.dart';
import '../services/push_notification_service.dart';
import 'base_model.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final APIService _apiService = locator<APIService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final PushNotificationService _notificationService = locator<PushNotificationService>();
  final DynamicLinkService _linkService = locator<DynamicLinkService>();
  final ErrorHandlingService _errorHandlingService = locator<ErrorHandlingService>();

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final productSearchHistoryList =
        prefs.getStringList(ProductSearchHistoryList);
    final sellerSearchHistoryList =
        prefs.getStringList(SellerSearchHistoryList);

    if (productSearchHistoryList == null)
      prefs.setStringList(ProductSearchHistoryList, []);
    if (sellerSearchHistoryList == null)
      prefs.setStringList(SellerSearchHistoryList, []);

    var updateDetails = await _apiService.getAppUpdate();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;

    await _analyticsService.setup();
    await _notificationService.initialise();
    await _linkService.handleDynamicLink();
    await _errorHandlingService.init();

    if (updateDetails.version != version) {
      Get.defaultDialog(
          title: "Update is here !",
          onConfirm: () {
            //ToDo: Go to playstore
          },
          onCancel: () {
            //Close App ??
          });
    } else {
      Future.delayed(Duration(milliseconds: 2000), () async {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString(Authtoken, "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MTo5NDI3MTczMjE2IiwidXNlciI6IntcImFjY291bnROb25Mb2NrZWRcIjp0cnVlLFwiY3JlZGVudGlhbHNOb25FeHBpcmVkXCI6dHJ1ZSxcImFjY291bnROb25FeHBpcmVkXCI6dHJ1ZSxcImVuYWJsZWRcIjp0cnVlLFwidXNlcm5hbWVcIjpcIjkxOjk0MjcxNzMyMTZcIixcInJvbGVzXCI6W1wiUk9MRV9GaXhlZFwiXSxcInVzZXJJZFwiOjEwMjgwNTA5LFwicm9sZUlkXCI6MTAyODA1MDksXCJmYWNlYm9va0xvZ2luXCI6ZmFsc2UsXCJtb2JpbGVMb2dpblwiOnRydWUsXCJyb2xlXCI6e1wicGVybWlzc2lvbnNcIjpbe1widHlwZVwiOntcInR5cGVcIjoxfSxcImxldmVsXCI6e1wibGV2ZWxcIjo0fX0se1widHlwZVwiOntcInR5cGVcIjoxMH0sXCJsZXZlbFwiOntcImxldmVsXCI6MX19LHtcInR5cGVcIjp7XCJ0eXBlXCI6Nn0sXCJsZXZlbFwiOntcImxldmVsXCI6Nn19LHtcInR5cGVcIjp7XCJ0eXBlXCI6OH0sXCJsZXZlbFwiOntcImxldmVsXCI6OH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6OX0sXCJsZXZlbFwiOntcImxldmVsXCI6OH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6Mn0sXCJsZXZlbFwiOntcImxldmVsXCI6NH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6N30sXCJsZXZlbFwiOntcImxldmVsXCI6OH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6NH0sXCJsZXZlbFwiOntcImxldmVsXCI6Nn19LHtcInR5cGVcIjp7XCJ0eXBlXCI6M30sXCJsZXZlbFwiOntcImxldmVsXCI6MH19LHtcInR5cGVcIjp7XCJ0eXBlXCI6MTF9LFwibGV2ZWxcIjp7XCJsZXZlbFwiOjF9fV19fSIsImlhdCI6MTU5MzE0NDEwNywiZXhwIjoxNjAxNzg0MTA3fQ.c4Ii6SKzINf-_qy8tnnz9jPq02FAOzbq4gjlpnoroww");
        var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
        if (hasLoggedInUser) {
          _navigationService.navigateReplaceTo(HomeViewRoute);
        } else {
          _navigationService.navigateReplaceTo(MyHomePageRoute);
        }
      });
    }
  }
}

class ApiService {}
