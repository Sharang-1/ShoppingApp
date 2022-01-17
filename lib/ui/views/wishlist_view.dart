import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/shared_pref.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/grid_view_builder_filter_models/sellerFilter.dart';
import '../../models/products.dart';
import '../../models/sellers.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/debouncer.dart';
import '../shared/shared_styles.dart';
import '../widgets/cart_icon_badge.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/product_tile_ui.dart';

class WishlistView extends StatefulWidget {
  WishlistView({Key? key}) : super(key: key);

  @override
  _WishlistViewState createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  FocusNode _searchBarFocusNode = FocusNode(canRequestFocus: true);

  // Search States
  late Debouncer _debouncer;
  int currentTabIndex = 0;
  bool showRecents = true;
  bool showResults = false;
  RegExp _searchFilterRegex = RegExp(r"\w+", caseSensitive: true);
  Key productGridKey = UniqueKey();
  Key sellerGridKey = UniqueKey();

  // Filter States
  late ProductFilter productFilter;
  late SellerFilter sellerFilter;

  // These lists will be used for showing UI and filtering.
  List<String> productSearchHistoryList = [];
  List<String> sellerSearchHistoryList = [];

  // These lists will be in sync with shared prefs.
  List<String> finalProductHistoryList = [];
  List<String> finalSellerHistoryList = [];

  @override
  void initState() {
    super.initState();
    setUpRecentList();
    _debouncer = Debouncer(100); // To delay search onChange method
    _searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) _onTabChange();
    });
    _searchBarFocusNode.addListener(_showRecentWhenFocusOnSearchBar);
  }

  Future<void> setUpRecentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      finalProductHistoryList = productSearchHistoryList =
          prefs.getStringList(ProductSearchHistoryList) ?? [];
      finalSellerHistoryList = sellerSearchHistoryList =
          prefs.getStringList(SellerSearchHistoryList) ?? [];
    });
  }

  void _onTabChange() {
    setState(() {
      currentTabIndex = _tabController.index;
      showResults = false;
    });
  }

  void _showRecentWhenFocusOnSearchBar() {
    if (_searchBarFocusNode.hasFocus) {
      setState(() {
        showRecents = true;
      });
    } else {
      setState(() {
        showRecents = false;
      });
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _searchController.dispose();
    _tabController.dispose();
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  List<String> _getListByTabIndex() {
    return currentTabIndex == 0
        ? productSearchHistoryList
        : sellerSearchHistoryList;
  }

  // Recent list UI
  List<Widget> _getRecentSearchListUI() {
    List<String> recentListByCurrentTab = _getListByTabIndex();
    return [
          ListTile(
            trailing: GestureDetector(
              onTap: _clearRecentButtonAction,
              child: Text("Clear Recent"),
            ),
          )
        ] +
        recentListByCurrentTab.reversed
            .toList()
            .sublist(
                0,
                recentListByCurrentTab.length < 5
                    ? recentListByCurrentTab.length
                    : 5)
            .map(
              (String value) => ListTile(
                onTap: () {
                  _searchController.text = value;
                  _searchAction(value);
                },
                leading: Icon(Icons.history),
                title: Text(value),
                trailing: IconButton(
                  icon: Icon(Icons.call_made),
                  onPressed: () {
                    if (value.contains(_searchController.text.toLowerCase())) {
                      _searchController.text = value;
                      return;
                    }
                    if (!_searchController.text.contains(value))
                      _searchController.text += value;
                  },
                ),
              ),
            )
            .toList();
  }

  Widget childWidget(controller) {
    return Stack(
      children: <Widget>[
        if (showResults && _tabController.index == 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: GridListWidget<Products, Product>(
              key: productGridKey,
              context: context,
              filter: productFilter,
              gridCount: 2,
              controller: ProductsGridViewBuilderController(),
              childAspectRatio: 0.75,
              onEmptyList: () {},
              tileBuilder: (BuildContext context, data, index, onDelete) {
                Fimber.d("test");
                return ProductTileUI(
                  index: index,
                  data: data,
                  onClick: () {
                    BaseController.goToProductPage(data);
                  },
                );
              },
            ),
          ),
        if (showResults && _tabController.index == 1)
          GridListWidget<Sellers, Seller>(
            key: sellerGridKey,
            context: context,
            filter: sellerFilter,
            gridCount: 2,
            onEmptyList: () {},
            controller: SellersGridViewBuilderController(
                removeId: '', subscriptionType: null, subscriptionTypes: []),
            disablePagination: true,
            tileBuilder: (BuildContext context, data, index, onDelete) {
              return Card(
                child: Center(
                  child: Text(data.name),
                ),
              );
            },
          ),
        if (showRecents && _getListByTabIndex().length != 0)
          GestureDetector(
            onTap: _changeSearchFieldFocus,
            child: Container(
              color: Colors.black.withAlpha(150),
            ),
          ),
        if (showRecents && _getListByTabIndex().length != 0)
          Container(
            color: backgroundWhiteCreamColor,
            child: ListView(
              shrinkWrap: true,
              children: _getRecentSearchListUI(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(
      init: BaseController(),
      builder: (controller) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: appBarIconColor),
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: CartIconWithBadge(
                  iconColor: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          backgroundColor: backgroundWhiteCreamColor,
          body: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: false,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                    primary: false,
                    floating: true,
                    snap: true,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.black),
                    backgroundColor: backgroundWhiteCreamColor,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        WISHLIST.tr,
                        style: TextStyle(
                            fontFamily: headingFont,
                            fontWeight: FontWeight.w700,
                            fontSize: headingFontSizeStyle,
                            color: Colors.black),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size(50, 50),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            screenPadding, 0, screenPadding, 5),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: backgroundBlueGreyColor,
                          borderRadius: BorderRadius.circular(curve30),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TabBar(
                          unselectedLabelColor: Colors.black,
                          labelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(curve30),
                          ),
                          controller: _tabController,
                          tabs: <Widget>[
                            Container(
                              height: 30,
                              child: Tab(
                                child: Text(
                                  PRODUCTS.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Tab(
                                  child: Text(
                                DESIGNERS.tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => childWidget(controller),
                    childCount: 1,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future<void> _updateRecentSharedPrefs() async {
    if (currentTabIndex == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(ProductSearchHistoryList, finalProductHistoryList);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(SellerSearchHistoryList, finalSellerHistoryList);
    }
  }

  void _searchAction(String searchKey) {
    // Checking tab controller index
    // If index is 0 then do search for product page else sellers page
    print("dsfdfsdfsdfsdfssssssssssssssssssssssssssssssssssssssssssssssssssss");

    if (!_searchFilterRegex.hasMatch(searchKey)) return;

    if (currentTabIndex == 0) {
      // Product Search Here
      setState(() {
        productGridKey = new UniqueKey();
        productFilter = new ProductFilter(fullText: searchKey);
        showResults = true;
        if (showRecents) showRecents = false;
        // Append to shared pref only when new element is inserted
        if (finalProductHistoryList.indexOf(searchKey) == -1)
          finalProductHistoryList = finalProductHistoryList + [searchKey];
      });
      _updateRecentSharedPrefs();
    } else {
      // Seller Search Here
      setState(() {
        sellerGridKey = new UniqueKey();
        sellerFilter = new SellerFilter(name: searchKey);
        showResults = true;
        if (showRecents) showRecents = false;
        // Append to shared pref only when new element is inserted
        if (finalSellerHistoryList.indexOf(searchKey) == -1)
          finalSellerHistoryList = finalSellerHistoryList + [searchKey];
      });
      _updateRecentSharedPrefs();
    }
    _changeSearchFieldFocus();
  }

  Future<void> _clearRecentButtonAction() async {
    if (currentTabIndex == 0) {
      // Clear Product Search Here
      setState(() {
        finalProductHistoryList = productSearchHistoryList = [];
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(ProductSearchHistoryList, []);
    } else {
      // Clear Seller Search Here
      setState(() {
        finalSellerHistoryList = sellerSearchHistoryList = [];
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(SellerSearchHistoryList, []);
    }
  }

  void _changeSearchFieldFocus() {
    setState(() {
      if (showResults) {
        showRecents = false;
      }
      _searchBarFocusNode.nextFocus();
    });
  }
}
