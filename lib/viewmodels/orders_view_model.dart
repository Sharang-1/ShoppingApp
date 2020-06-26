import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/orders.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';

class OrdersViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _APIService = locator<APIService>();
  final DialogService _dialogService = locator<DialogService>();

  Orders mOrders;
  Future getOrders() async {

    setBusy(true);
    final result = await _APIService.getAllOrders();
    setBusy(false);
    if (result != null) {
      mOrders = result;
    }
    notifyListeners();
  }
  
}

