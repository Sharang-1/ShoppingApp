import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/authentication_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future init() async {    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final productSearchHistoryList = prefs.getStringList(ProductSearchHistoryList);
    final sellerSearchHistoryList = prefs.getStringList(SellerSearchHistoryList);

    if(productSearchHistoryList == null) prefs.setStringList(ProductSearchHistoryList, []);
    if(sellerSearchHistoryList == null) prefs.setStringList(SellerSearchHistoryList, []);

    Future.delayed(Duration(milliseconds: 2000), () async {
      var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

      if (hasLoggedInUser) {
        _navigationService.navigateReplaceTo(HomeViewRoute);
      } else {
        _navigationService.navigateReplaceTo(LoginViewRoute);
      }
    });
  }
}
