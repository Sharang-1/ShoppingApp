import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/products.dart';
import '../../services/api/api_service.dart';
import 'base_grid_view_builder_controller.dart';

class ProductsGridViewBuilderController
    extends BaseGridViewBuilderController<Products, Product> {
  final APIService _apiService = locator<APIService>();

  final String? filteredProductKey;
  final bool randomize;
  final bool sameDayDelivery;
  final int? limit;
  final List<String> exceptProductIDs;

  ProductsGridViewBuilderController({
    this.filteredProductKey,
    this.randomize = false,
    this.sameDayDelivery = false,
    this.limit,
    this.exceptProductIDs = const [],
  });

  @override
  Future init() async {
    return null;
  }

  @override
  Future<Products> getData(
      {required BaseFilterModel filterModel,
      required int pageNumber,
      int pageSize = 10}) async {
    if (this.limit != null && this.limit! > pageSize) {
      pageSize = this.limit!;
    }

    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;random=$randomize;" +
            filterModel.queryString;

    Products? res = await _apiService.getProducts(queryString: _queryString);

    if (res == null) {
      res = await _apiService.getProducts(queryString: _queryString);
      if (res == null) throw "Could not load";
    }

    if (this.exceptProductIDs.isNotEmpty) {
      res.items = res.items!
          .where((element) => !this.exceptProductIDs.contains(element.key))
          .toList();
    }

    if (this.filteredProductKey != null) {
      res.items = res.items!
          .where((element) => element.key != this.filteredProductKey)
          .toList();
      res.records = res.records! - 1;
      res.limit = res.limit! - 1;
    }

    if (this.sameDayDelivery) {
      res.items!.sort((a, b) =>
          a.shipment!.days!.toInt().compareTo(a.shipment!.days!.toInt()));

      print("test ---------------------------------------------->>>>" +
          res.items!.length.toString());

      res.items = res.items!.take(6).toList();
    }

    if (this.randomize) {
      res.items!.shuffle();
      if (res.items!.length > pageSize)
        res.items = res.items!.sublist(0, pageSize);
    }
    if (this.limit != null) {
      res.items = res.items!.take(limit!).toList();
    }

    return res;
  }
}
