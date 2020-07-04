import 'package:compound/locator.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';

class UserDetailsViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final APIService _apiService = locator<APIService>();
  // final DialogService _dialogService = locator<DialogService>();

  UserDetails mUserDetails;
  Future getUserDetails() async {

    setBusy(true);
    final result = await _apiService.getUserData();
    setBusy(false);
    if (result != null) {
      mUserDetails = result;
    }
    Fimber.e(mUserDetails.firstName);
    Fimber.e(mUserDetails.details.phone.mobile);
    notifyListeners();
  }
  
}

