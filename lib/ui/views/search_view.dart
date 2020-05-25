import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/grid_view_builder_filter_models/sellerFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
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
import '../widgets/cart_icon_badge.dart';
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

  Widget childWidget(model) {
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
              viewModel: ProductsGridViewBuilderViewModel(),
              childAspectRatio: 0.75,
              tileBuilder: (BuildContext context, data, index) {
                Fimber.d("test");
                print((data as Product).toJson());
                return ProductTileUI(
                  index: index,
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
            tileBuilder: (BuildContext context, data, index) {
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
    return ViewModelProvider<SearchViewModel>.withConsumer(
      viewModel: SearchViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: appBarIconColor),
            backgroundColor: backgroundWhiteCreamColor,
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: CartIconWithBadge(
                    IconColor: Colors.black,
                  )),
              SizedBox(
                width: 5,
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size(50, 50),
              child: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(color: appBarIconColor),
                backgroundColor: backgroundWhiteCreamColor,
                automaticallyImplyLeading: false,
                title: _SearchBarTextField(
                  searchAction: _searchAction,
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
                  if (showResults && currentTabIndex == 0)
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () async {
                        ProductFilter filterDialogResponse =
                            await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          isScrollControlled: true,
                          clipBehavior: Clip.antiAlias,
                          context: context,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                                heightFactor: 0.75,
                                child: ProductFilterDialog(
                                  oldFilter: productFilter,
                                ));
                          },
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
              ),
            ),
          ),
          backgroundColor: backgroundWhiteCreamColor,
          body: SafeArea(
            top: false,
            left: false,
            right: false,
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
                  title: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      // color: Colors.grey[200],
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
                            "Products",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Raleway"),
                          )),
                        ),
                        Container(
                          height: 30,
                          child: Tab(
                              child: Text(
                            "Sellers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Raleway"),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => childWidget(model),
                    childCount: 1,
                  ),
                )
              ],
            ),
          )),
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
    @required this.searchAction,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  final Function searchAction;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final bool autofocus;
  final Function onTap;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        color: backgroundBlueGreyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(children: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          color: appBarIconColor,
          onPressed: () => searchAction(searchController.text.trim()),
        ),
        Expanded(
          child: TextField(
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
              hintText: "Search Products or Sellers",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/*-----------------------------------------------------
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
