import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();


  int cartCount = 0;

  Future init() async {
    await setUpCartCount();
    return null;
  }

  Future<void> setUpCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Cart res = await _apiService.getCart();
    if (res != null) {
      final count = res.items.length;
      prefs.setInt(CartCount, count);
      cartCount = count;
      notifyListeners();
      return;
    }
    prefs.setInt(CartCount, 0);
    cartCount = 0;
    notifyListeners();
    return;
  }

  Future<void> search() async {
    await _navigationService.navigateTo(SearchViewRoute);
  }

  Future<void> cart() async {
    await _navigationService.navigateTo(CartViewRoute);
  }

  Future<void> category() async {
    await _navigationService.navigateTo(CategoriesRoute);
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
