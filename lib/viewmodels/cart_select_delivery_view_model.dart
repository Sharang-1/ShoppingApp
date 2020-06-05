import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/address_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class CartSelectDeliveryViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AddressService _addressService = locator<AddressService>();

  List<String> addresses = [];

  Future init() async {
    addresses = await _addressService.getAddresses();
    notifyListeners();
    return null;
  }

  Future<void> addAddress(String address) async {
    print("ViewModel: addAddress");
    final res = await _addressService.addAddresses(address);
    print("res : " + res.toString());
    if (res == true) {
      addresses = await _addressService.getAddresses();
      notifyListeners();
    }
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

  Future openmap() async {
    await _navigationService.navigateTo(MapViewRoute);
  }
}
