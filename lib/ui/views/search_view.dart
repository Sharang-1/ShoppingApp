import 'package:compound/utils/lang/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/grid_view_builder/sellers_grid_view_builder_controller.dart';
import '../../controllers/search_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../../models/sellers.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../widgets/cart_icon_badge.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/product_filter_dialog.dart';
import '../widgets/product_tile_ui.dart';
import '../widgets/section_builder.dart';
import '../widgets/sellerTileUi.dart';
import '../widgets/shimmer/shimmer_widget.dart';

class SearchView extends StatefulWidget {
  SearchView({Key? key, this.showSellers = false}) : super(key: key);

  final bool showSellers;

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  SearchController _controller = SearchController();

  @override
  void initState() {
    _controller.init(this, showSellers: widget.showSellers);
    super.initState();
  }

  @override
  void dispose() {
    _controller.despose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: appBarIconColor),
          backgroundColor: Colors.white,
          title: _SearchBarTextField(
            searchAction: _controller.searchAction,
            searchController: _controller.searchController.value,
            focusNode: _controller.searchBarFocusNode.value,
            autofocus: true,
            onTap: () {
              _controller.showRandomSellers = false.obs;
            },
            onChanged: _controller.searchBarOnChange,
          ),
          actions: <Widget>[
            if (_controller.currentTabIndex.value == 0)
              IconButton(
                iconSize: 50,
                icon: Image.asset("assets/images/filter.png"),
                onPressed: () async {
                  ProductFilter filterDialogResponse =
                      await showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                    clipBehavior: Clip.antiAlias,
                    context: context,
                    builder: (BuildContext context) => FractionallySizedBox(
                      heightFactor: 0.75,
                      child: ProductFilterDialog(
                          oldFilter: _controller.productFilter.value),
                    ),
                  );

                  if (filterDialogResponse != null) {
                    _controller.setProductFilter(filterDialogResponse);
                    _controller.setShowTopProducts(false);
                    _controller.changeSearchFieldFocus();
                    _controller.setProductGridKey(UniqueKey());
                  }
                },
              ),
            IconButton(
              onPressed: () => BaseController.cart(),
              icon: Obx(
                () => CartIconWithBadge(
                  count: locator<CartCountController>().count.value,
                  iconColor: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AppBar(
                  primary: false,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  backgroundColor: newBackgroundColor,
                  automaticallyImplyLeading: false,
                  title: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: backgroundBlueGreyColor,
                      borderRadius: BorderRadius.circular(curve10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Obx(
                      () => TabBar(
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(curve10),
                        ),
                        controller: _controller.tabController.value,
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Stack(
                    children: <Widget>[
                      if (_controller.tabController.value.index == 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: GridListWidget<Products, Product>(
                            key: _controller.productGridKey.value,
                            context: context,
                            onEmptyList: () {},
                            filter: _controller.productFilter.value,
                            gridCount: 2,
                            controller: ProductsGridViewBuilderController(
                              limit: _controller.showTopProducts.value ? 6 : 50,
                              randomize: _controller.showTopProducts.value,
                            ),
                            emptyListWidget: EmptyListWidget(
                                text:
                                    "No Search Found for ‘${_controller.productFilter.value.fullText}’, \nPlease try again!",
                                img: 'assets/images/no_search.jpg'),
                            childAspectRatio: 0.7,
                            loadingWidget: SizedBox(
                              height: Get.size.height,
                              child: ShimmerWidget(
                                type: LayoutType.PRODUCT_LAYOUT_2,
                                gridCount: 2,
                                scrollDirection: Axis.vertical,
                                childAspectRatio: 0.7,
                              ),
                            ),
                            tileBuilder:
                                (BuildContext context, data, index, onDelete) =>
                                    Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                              child: ProductTileUI(
                                index: index,
                                data: data,
                                cardPadding: EdgeInsets.zero,
                                onClick: () =>
                                    BaseController.goToProductPage(data),
                              ),
                            ),
                          ),
                        ),
                      if (_controller.tabController.value.index == 1)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: GridListWidget<Sellers, Seller>(
                            key: _controller.sellerGridKey.value,
                            context: context,
                            filter: _controller.sellerFilter.value,
                            gridCount: 1,
                            onEmptyList: () {},
                            controller: SellersGridViewBuilderController(
                                random: _controller.showRandomSellers.value,
                                removeId: ''),
                            emptyListWidget: EmptyListWidget(
                                text:
                                    "No Search Found for ‘${_controller.sellerFilter.value.name}’, \nPlease try again!",
                                img: 'assets/images/no_search.jpg'),
                            disablePagination: true,
                            childAspectRatio: 3.50,
                            loadingWidget: SizedBox(
                              height: Get.size.height,
                              child: ShimmerWidget(
                                type: LayoutType.DESIGNER_ID_3_LAYOUT,
                                scrollDirection: Axis.vertical,
                                childAspectRatio: 3.50,
                              ),
                            ),
                            tileBuilder:
                                (BuildContext context, data, index, onDelete) =>
                                    Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                              ),
                              child: DesignerTileUi(
                                data: data,
                                isID3: true,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}

class _SearchBarTextField extends StatelessWidget {
  const _SearchBarTextField({
    Key? key,
    required this.searchController,
    required this.focusNode,
    required this.searchAction,
    this.autofocus = false,
    required this.onTap,
    required this.onChanged,
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
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: backgroundBlueGreyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
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
              onTap: onTap(),
              onSubmitted: (txt) => searchAction(searchController.text.trim()),
              onChanged: onChanged(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Start typing...",
                contentPadding: EdgeInsets.only(bottom: 18.0),
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
