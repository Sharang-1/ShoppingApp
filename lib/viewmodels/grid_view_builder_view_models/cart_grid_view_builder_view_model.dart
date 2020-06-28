import 'package:compound/constants/shared_pref.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/cart.dart';
import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/base_grid_view_builder_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:compound/constants/route_names.dart';
// import 'package:compound/constants/shared_pref.dart';
// import 'package:compound/locator.dart';
// import 'package:compound/models/post.dart';
// import 'package:compound/services/dialog_service.dart';
// import 'package:compound/services/navigation_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CartGridViewBuilderViewModel extends BaseGridViewBuilderViewModel<Cart, Item> {
  final APIService _apiService = locator<APIService>();

  @override
  Future init() {
    return null;
  }

  Future<void> decrementCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cartCount = prefs.getInt(CartCount);
    if(cartCount != null && cartCount != 0)
      cartCount -= 1;
    else 
      cartCount = 0;
    
    prefs.setInt(CartCount, cartCount);
    return;
  }

  @override
  Future<Cart> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;";
    Cart res = await _apiService.getCart(queryString: _queryString);
    if(filterModel.queryString != "") {
      print("Cart Query String ======== " + filterModel.queryString);
      var items = res.items;
      var filteredItems = items
        .where((element) => element.productId.toString() == filterModel.queryString)
        .toList();
      res.items = filteredItems;
      print(res);
      if (res == null) throw "Error occured";
      return res;
    }
    print("FRom lit ------------------------------>>>>>>>>");
    print(res);
    if (res == null) throw "Error occured";
    return res;
  }

  @override
  Future<bool> deleteData(Item item) async {
    print("Delete ID::::::::::::: " + item.productId.toString());
    final res = await _apiService.removeFromCart(item.productId);
    if(res != null) {
      return true;
    }
    return false;
  }
}
