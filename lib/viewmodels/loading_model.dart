import 'package:compound/constants/route_names.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loadModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();

  String name = "";
  bool displaySymbol = false;

  Future init(int i, bool fromCart, bool fromAppointment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString(Name);
    notifyListeners();

    Future.delayed(Duration(milliseconds: 2500), () async {
      if (fromCart || fromAppointment) {
        displaySymbol = true;
        notifyListeners();
        Future.delayed(Duration(milliseconds: 2000), () async {
          if (fromAppointment) {
            _navigationService.navigateReplaceTo(MyAppointmentViewRoute);
          } else {
            _navigationService.navigateReplaceTo(CartViewRoute);
          }
        });
      } else {
        if (i == 1) {
          _navigationService.navigateReplaceTo(OtpFinishedScreen2Route);
        } else {
          _navigationService.navigateReplaceTo(HomeViewRoute);
        }
      }
    });
  }
}
