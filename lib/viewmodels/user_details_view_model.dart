import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/orders.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';

class UserDetailsViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _APIService = locator<APIService>();
  final DialogService _dialogService = locator<DialogService>();

  UserDetails mUserDetails;
  Future getUserDetails() async {

    setBusy(true);
    final result = await _APIService.getUserData();
    setBusy(false);
    if (result != null) {
      mUserDetails = result;
    }
    print(mUserDetails);
    print(mUserDetails.firstName);
    notifyListeners();
  }
  
}

