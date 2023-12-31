import '../locator.dart';
import '../models/user_details.dart';
import '../services/address_service.dart';
import 'base_controller.dart';

class CartSelectDeliveryController extends BaseController {
  final AddressService _addressService = locator<AddressService>();

  List<UserDetailsContact> addresses = [];

  void onInit() async {
    super.onInit();

    addresses = await _addressService.getAddresses();
    update();
  }

  Future<void> addAddress(UserDetailsContact address) async {
    final res = await _addressService.addAddresses(address);
    print("res : " + res.toString());
    if (res == true) {
      addresses = await _addressService.getAddresses();
      update();
    }
    return;
  }
}
