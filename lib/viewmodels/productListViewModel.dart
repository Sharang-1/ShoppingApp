import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  Future init() {
    return null;
  }

  Future<void> search() async {
    await _navigationService.navigateTo(SearchViewRoute);
  }

  Future<void> cart() async {
    await _navigationService.navigateTo(CartViewRoute);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Authtoken);
    prefs.remove(PhoneNo);
    await _navigationService.navigateReplaceTo(LoginViewRoute);
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  Future openmap() async {
    await _navigationService.navigateTo(MapViewRoute);
  }
}
