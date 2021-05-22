// import 'package:compound/constants/route_names.dart';
// import 'package:compound/services/navigation_service.dart';
import 'package:compound/controllers/base_controller.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/address_service.dart';
import 'package:compound/services/dialog_service.dart';

class CartSelectDeliveryController extends BaseController {
  // final NavigationService _navigationService = locator<NavigationService>();
  final AddressService _addressService = locator<AddressService>();

  List<UserDetailsContact> addresses = [];

  void onInit() async {
    super.onInit();
    
    addresses = await _addressService.getAddresses();
    update();
  }

  Future<void> addAddress(UserDetailsContact address) async {
    if (address.city.toUpperCase() != "AHMEDABAD") {
      DialogService.showNotDeliveringDialog();
      return;
    }
    print("ViewModel: addAddress");
    final res = await _addressService.addAddresses(address);
    print("res : " + res.toString());
    if (res == true) {
      addresses = await _addressService.getAddresses();
      update();
    }
    return;
  }
}
