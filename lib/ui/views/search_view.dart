import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/grid_view_builder_filter_models/sellerFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductFilterDialog.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/sellers_grid_view_builder_view.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:compound/constants/shared_pref.dart';
import 'package:compound/viewmodels/search_view_model.dart';
import 'package:compound/ui/shared/debouncer.dart';
import 'package:compound/ui/widgets/sellerGridListWidget.dart';

class SearchView extends StatefulWidget {
  SearchView({Key key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  TabController _tabController;
  FocusNode _searchBarFocusNode = FocusNode(canRequestFocus: true);

  // Search States
  Debouncer _debouncer;
  int currentTabIndex = 0;
  bool showRecents = true;
  bool showResults = false;
  RegExp _searchFilterRegex = RegExp(r"\w+", caseSensitive: true);
  Key productGridKey = UniqueKey();
  Key sellerGridKey = UniqueKey();

  // Filter States
  ProductFilter productFilter;
  SellerFilter sellerFilter;

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
          prefs.getStringList(ProductSearchHistoryList);
      finalSellerHistoryList = sellerSearchHistoryList =
          prefs.getStringList(SellerSearchHistoryList);
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

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SearchViewModel>.withConsumer(
      viewModel: SearchViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: _SearchBarTextField(
            searchController: _searchController,
            focusNode: _searchBarFocusNode,
            autofocus: true,
            onTap: () {
              setState(() {
                if (!showRecents) {
                  showRecents = true;
                }
              });
            },
            onChanged: _searchBarOnChange,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _searchAction(_searchController.text.trim()),
            ),
            if (showResults && currentTabIndex == 0)
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () async {
                  ProductFilter filterDialogResponse =
                      await Navigator.of(context).push<ProductFilter>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ProductFilterDialog(
                          oldFilter: productFilter,
                        );
                      },
                      fullscreenDialog: true,
                    ),
                  );

                  if (filterDialogResponse != null) {
                    setState(() {
                      productFilter = filterDialogResponse;
                      productGridKey = UniqueKey();
                    });
                  }
                },
              ),
          ],
          bottom: new PreferredSize(
            preferredSize: new Size(50, 50),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                width: 1.0,
              )),
              width: (MediaQuery.of(context).size.width / 4) * 3,
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [primaryColor ,secondaryColor]),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.redAccent),
                controller: _tabController,
                tabs: <Widget>[
                  Container(
                    height: 35,
                    child: Tab(
                        child: Text(
                      "Products",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                  Container(
                    height: 35,
                    child: Tab(
                        child: Text(
                      "Sellers",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            if (showResults && _tabController.index == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: GridListWidget<Products, Product>(
                  key: productGridKey,
                  context: context,
                  filter: productFilter,
                  gridCount: 2,
                  viewModel: ProductsGridViewBuilderViewModel(),
                  childAspectRatio: 0.7,
                  tileBuilder: (BuildContext context, data) {
                    Fimber.d("test");
                    print((data as Product).toJson());
                    return ProductTileUI(
                      data: data,
                      onClick: () {
                        model.goToProductPage(data);
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
                viewModel: SellersGridViewBuilderViewModel(),
                disablePagination: true,
                tileBuilder: (BuildContext context, data) {
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
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: _getRecentSearchListUI(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _searchBarOnChange(value) {
    _debouncer.run(() {
      if (currentTabIndex == 0) {
        setState(() {
          productSearchHistoryList = finalProductHistoryList
              .where((String value) =>
                  _searchController.text == "" ||
                  value.contains(_searchController.text.toLowerCase()))
              .toList();
        });
      } else {
        setState(() {
          sellerSearchHistoryList = finalSellerHistoryList
              .where((String value) =>
                  _searchController.text == "" ||
                  value.contains(_searchController.text.toLowerCase()))
              .toList();
        });
      }
    });
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

// We have not used InputField widget b'coz of the style of Widget
class _SearchBarTextField extends StatelessWidget {
  const _SearchBarTextField({
    Key key,
    @required this.searchController,
    @required this.focusNode,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController searchController;
  final FocusNode focusNode;
  final bool autofocus;
  final Function onTap;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      focusNode: focusNode,
      controller: searchController,
      style: TextStyle(
        color: Colors.black,
      ),
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Search",
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        fillColor: Colors.black,
      ),
    );
  }
}

/*

-----------------------------------------------------
isTyping  | isSearched  | ResultScreen / Action
----------+-------------+----------------------------
false     | false       | Search History
----------+-------------+----------------------------
true      | false       | Search History with Filters
----------+-------------+----------------------------
false     | true        | Results
----------+-------------+----------------------------
true      | true        | Search History
----------+-------------+----------------------------


// Opacity(
//   child: GridListWidget<Products, Product>(
//     context: context,
//     filter: productFilter,
//     gridCount: 2,
//     viewModel: ProductsGridViewBuilderViewModel(),
//     tileBuilder: (BuildContext context, data) {
//       return Card(
//         child: Center(
//           child: Text("product"),
//         ),
//       );
//     },
//   ),
//   opacity: _tabController.index == 0 ? 1 : 0,
// ),
// Opacity(
//   child: SellerGridListWidget(context: context),
//   opacity: _tabController.index == 1 ? 1 : 0,
// ),
// TabBarView(
//   controller: _tabController,
//   physics: NeverScrollableScrollPhysics(),
//   children: [
//     GridListWidget<Products, Product>(
//       context: context,
//       filter: productFilter,
//       gridCount: 2,
//       viewModel: ProductsGridViewBuilderViewModel(),
//       tileBuilder: (BuildContext context, data) {
//         return Card(
//           child: Center(
//             child: Text("product"),
//           ),
//         );
//       },
//     ),
//     SellerGridListWidget(context: context),
//   ],
// ),

*/
