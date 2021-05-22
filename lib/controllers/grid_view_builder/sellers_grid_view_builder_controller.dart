import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/sellers.dart';
import '../../services/api/api_service.dart';
import 'base_grid_view_builder_controller.dart';

class SellersGridViewBuilderController
    extends BaseGridViewBuilderController<Sellers, Seller> {
  final APIService _apiService = locator<APIService>();
  final bool profileOnly;
  final bool sellerOnly;
  final bool sellerDeliveringToYou;
  final bool boutiquesOnly;
  final bool sellerWithNoProducts;
  final bool random;
  final bool topSellers;
  final String removeId;
  final num subscriptionType;

  SellersGridViewBuilderController({
    this.profileOnly = false,
    this.sellerOnly = false,
    this.sellerDeliveringToYou = false,
    this.random = false,
    this.boutiquesOnly = false,
    this.removeId,
    this.subscriptionType,
    this.sellerWithNoProducts = true,
    this.topSellers = false,
  });

  @override
  Future init() {
    return null;
  }

  @override
  Future<Sellers> getData(
      {BaseFilterModel filterModel, int pageNumber, int pageSize = 10}) async {
    if (subscriptionType != null) {
      pageSize = 30;
    }

    // String _queryString =
    //     "startIndex=${pageSize * (pageNumber - 1)};limit=${this.random ? 1000 : pageSize};" +
    //         filterModel.queryString;

    String _queryString =
        "startIndex=${pageSize * (pageNumber - 1)};limit=$pageSize;" +
            filterModel.queryString;
    Sellers res = await _apiService.getSellers(queryString: _queryString);
    if (res == null) {
      res = await _apiService.getSellers(queryString: _queryString);
      if (res == null) throw "Could not load";
    }

    if (this.removeId != null) {
      res.items =
          res.items.where((element) => element?.key != this.removeId).toList();
    }

    if (this.subscriptionType != null) {
      res.items = res.items
          .where(
              (element) => element?.subscriptionTypeId == this.subscriptionType)
          .toList();
    }

    if (this.sellerDeliveringToYou) {
      res.items = res.items
          .where((element) =>
              element?.subscriptionTypeId == 1 ||
              element?.subscriptionTypeId == 2)
          .toList();
    }

    if (this.profileOnly != null && this.profileOnly == true) {
      res.items = res.items
          .where((element) => element?.subscriptionTypeId != 2)
          .toList();
    }

    if ((this.profileOnly == null || this.profileOnly == false) &&
        (this.sellerOnly != null && this.sellerOnly == true)) {
      res.items = res.items
          .where((element) => element?.subscriptionTypeId == 2)
          .toList();
    }

    if (this.boutiquesOnly) {
      res.items = res.items
          .where((element) => element?.establishmentTypeId == 1)
          .toList();
    }

    if (this.random) {
      res.items.shuffle();
      if (res.items.length > pageSize && sellerWithNoProducts)
        res.items = res.items.sublist(0, pageSize);
    }

    // if (!sellerWithNoProducts) {
    // List<Seller> sellers = [];
    // await Future.wait([
    //   Future.forEach(res.items, (s) async {
    //     if (sellers.length <= 10) {
    //       bool hasProducts = await _apiService.hasProducts(sellerKey: s.key);
    //       if (hasProducts) sellers.add(s);
    //     }
    //   }),
    // ]);
    // res.items = sellers;
    // return res;
    // }

    return res;
  }
}