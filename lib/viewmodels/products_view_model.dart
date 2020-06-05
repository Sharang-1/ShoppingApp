import 'package:compound/locator.dart';
import 'package:compound/models/post.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';

class ProductsViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();

  List<Post> _posts;
  List<Post> get posts => _posts;
  Future getProducts() async {

    setBusy(true);
    Products result = await _apiService.getProducts();
    setBusy(false);
    if (result != null) {
      Fimber.d(result.items.toString());
    }
  }
  
}

