import 'package:compound/locator.dart';
import 'package:compound/models/grid_view_builder_filter_models/base_filter_model.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/base_grid_view_builder_view_model.dart';
// import 'package:compound/constants/route_names.dart';
// import 'package:compound/constants/shared_pref.dart';
// import 'package:compound/locator.dart';
// import 'package:compound/models/post.dart';
// import 'package:compound/services/dialog_service.dart';
// import 'package:compound/services/navigation_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ProductsGridViewBuilderViewModel
    extends BaseGridViewBuilderViewModel<Products, Product> {
  final APIService _apiService = locator<APIService>();

  final String filteredProductKey;
  final bool randomize;
  final bool sameDayDelivery;
  final int limit;

  ProductsGridViewBuilderViewModel(
      {this.filteredProductKey,
      this.randomize = false,
      this.sameDayDelivery = false,
      this.limit});

  @override
  Future init() {
    return null;
  }

  @override
  Future<Products> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    if (this.limit != null && this.limit > pageSize) {
      pageSize = this.limit;
    }

    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=${this.randomize ? 1000 : pageSize};" +
            filterModel.queryString;
    Products res = await _apiService.getProducts(queryString: _queryString);
    if (res == null) throw "Error occured";

    if (this.randomize) {
      res.items.shuffle();
      res.items = res.items.sublist(0, this.limit);
    }

    if (this.filteredProductKey != null) {
      res.items = res.items
          .where((element) => element.key != this.filteredProductKey)
          .toList();
      res.records = res.records - 1;
      res.limit = res.limit - 1;
    }

    if (this.sameDayDelivery) {
      res.items.sort(
          (a, b) => a.shipment.days.toInt().compareTo(a.shipment.days.toInt()));

      print("test ---------------------------------------------->>>>" +
          res.items.length.toString());

      res.items = res.items.take(6).toList();
    }

    if (this.limit != null) {
      res.items = res.items.take(limit).toList();
    }

    return res;
  }
}
