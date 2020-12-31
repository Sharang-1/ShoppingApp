// import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/address_service.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';

class CartSelectDeliveryViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final AddressService _addressService = locator<AddressService>();

  List<UserDetailsContact> addresses = [];

  Future init() async {
    addresses = await _addressService.getAddresses();
    notifyListeners();
    return null;
  }

  Future<void> addAddress(UserDetailsContact address) async {
    print("ViewModel: addAddress");
    final res = await _addressService.addAddresses(address);
    print("res : " + res.toString());
    if (res == true) {
      addresses = await _addressService.getAddresses();
      notifyListeners();
    }
    return;
  }
}
