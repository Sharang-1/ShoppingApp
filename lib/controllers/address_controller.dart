import 'package:get/get.dart';

import '../packages/google_maps_place_picker/google_maps_place_picker.dart';
import 'base_controller.dart';

class AddressController extends BaseController {
  late PickResult selectedResult;
  var googleAddress = "".obs;

  set setSelectedResult(PickResult place) {
    this.selectedResult = place;
    update();
  }

  setGoogleAddress(String s) => googleAddress.value = s;
}
