import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../constants/route_names.dart';
import '../models/grid_view_builder_filter_models/productFilter.dart';
import '../models/grid_view_builder_filter_models/sellerFilter.dart';
import '../models/productPageArg.dart';
import '../services/navigation_service.dart';
import '../ui/shared/debouncer.dart';
import 'base_controller.dart';

class SearchController extends BaseController {
  Rx<Key> productGridKey = UniqueKey().obs;
  Rx<Key> sellerGridKey = UniqueKey().obs;

  Rx<TextEditingController> searchController;
  Rx<TabController> tabController;
  Rx<FocusNode> searchBarFocusNode = FocusNode(canRequestFocus: true).obs;

  // Search States
  Rx<Debouncer> debouncer;
  RxInt currentTabIndex = 0.obs;
  RxBool showRandomSellers = true.obs;
  RxBool showTopProducts = true.obs;
  Rx<RegExp> searchFilterRegex = RegExp(r"\w+", caseSensitive: true).obs;

  // Filter States
  Rx<ProductFilter> productFilter;
  Rx<SellerFilter> sellerFilter;

  void setProductGridKey(UniqueKey key) {
    this.productGridKey.value = key;
  }

  void setShowTopProducts(bool showTopProducts) {
    this.showTopProducts.value = showTopProducts;
  }

  void setProductFilter(ProductFilter productFilter) {
    this.productFilter.value = productFilter;
  }

  Future<void> init(TickerProvider tickerProvider,
      {bool showSellers = false}) async {
    productFilter = ProductFilter().obs;
    sellerFilter = SellerFilter().obs;

    debouncer = Debouncer(100).obs; // To delay search onChange method
    searchController = TextEditingController().obs;
    tabController = TabController(length: 2, vsync: tickerProvider).obs;
    tabController.value.addListener(() {
      if (tabController.value.indexIsChanging) onTabChange();
    });

    if (showSellers) {
      tabController.value.index = 1;
      onTabChange();
    }
    return;
  }

  despose() {
    debouncer.value.dispose();
    searchController.value.dispose();
    tabController.value.dispose();
    searchBarFocusNode.value.dispose();
  }

  Future showCategory(String filter, String name) async {
    await NavigationService.to(
      CategoryIndiViewRoute,
      arguments: ProductPageArg(
        queryString: filter,
        subCategory: name,
      ),
    );
  }

  void onTabChange() {
    currentTabIndex.value = tabController.value.index;
    if (currentTabIndex.value == 1 && showRandomSellers.value) {
      Future.delayed(
        Duration(milliseconds: 200),
        () {
          sellerFilter.value = SellerFilter(name: '');
          changeSearchFieldFocus();
        },
      );
      sellerGridKey.value = UniqueKey();
    } else {
      searchBarFocusNode.value.requestFocus();
      productFilter.value =
          ProductFilter(fullText: '');
      setProductGridKey(UniqueKey());
    }
  }

  searchBarOnChange(value) {
    debouncer.value.run(() {
      if (currentTabIndex.value == 0) {
        if (showTopProducts.value) showTopProducts.value = false;
        if (showRandomSellers.value) showRandomSellers.value = false;
        setProductFilter(ProductFilter(fullText: value));
        setProductGridKey(UniqueKey());
      } else if (currentTabIndex.value == 1) {
        this.sellerFilter.value = SellerFilter(name: value);
        sellerGridKey.value = UniqueKey();
      }
    });
  }

  void searchAction(String searchKey) {
    // Checking tab controller index
    // If index is 0 then do search for product page else sellers page

    if (!searchFilterRegex.value.hasMatch(searchKey)) return;

    if (currentTabIndex.value == 0) {
      // Product Search Here
      productGridKey = UniqueKey().obs;
      productFilter = ProductFilter(fullText: searchKey).obs;
      if (showTopProducts.value) showTopProducts.value = false;
    } else {
      // Seller Search Here
      sellerGridKey = UniqueKey().obs;
      sellerFilter = SellerFilter(name: searchKey).obs;
      if (showRandomSellers.value) showRandomSellers.value = false;
    }
    changeSearchFieldFocus();
  }

  void changeSearchFieldFocus() {
    searchBarFocusNode.value.nextFocus();
  }
}
