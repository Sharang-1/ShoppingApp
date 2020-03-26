import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';

class ProductsViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final APIService _APIService = locator<APIService>();
  final DialogService _dialogService = locator<DialogService>();

  List<Post> _posts;
  List<Post> get posts => _posts;
  Future getProducts() async {

    setBusy(true);
    Products result = await _APIService.getProducts();
    setBusy(false);
    if (result != null) {
      Fimber.d(result.items.toString());
    }
  }
  
}

