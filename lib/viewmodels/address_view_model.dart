import 'package:get/get.dart';

import '../google_maps_place_picker/google_maps_place_picker.dart';
import 'base_model.dart';

class AddressViewModel extends BaseModel {
  PickResult selectedResult;

  set setSelectedResult(PickResult place) {
    this.selectedResult = place;
    notifyListeners();
  }
}

class AddressViewModelController extends GetxController {
  var googleAddress = "".obs;
  setGoogleAddress(String s) => googleAddress.value = s;
}
