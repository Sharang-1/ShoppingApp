import 'package:compound/viewmodels/base_model.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class AddressViewModel extends BaseModel {
  PickResult selectedResult;

  set setSelectedResult(PickResult place) {
    this.selectedResult = place;
    notifyListeners();
  }
}
