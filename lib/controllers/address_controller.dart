import 'package:get/get.dart';

import '../google_maps_place_picker/google_maps_place_picker.dart';
import 'base_controller.dart';

class AddressController extends BaseController {
  PickResult selectedResult;
  var googleAddress = "".obs;

  set setSelectedResult(PickResult place) {
    this.selectedResult = place;
    update();
  }

  setGoogleAddress(String s) => googleAddress.value = s;
}