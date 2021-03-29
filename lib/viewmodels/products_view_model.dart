import 'package:fimber/fimber.dart';

import '../locator.dart';
import '../models/post.dart';
import '../models/products.dart';
import '../services/api/api_service.dart';
import 'base_model.dart';

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

