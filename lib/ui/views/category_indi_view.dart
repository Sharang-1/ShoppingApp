import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/base_controller.dart';
import '../../controllers/categories_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../shared/app_colors.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/product_filter_dialog.dart';
import '../widgets/product_tile_ui.dart';

class CategoryIndiView extends StatefulWidget {
  final String queryString;
  final String subCategory;

  const CategoryIndiView({Key key, this.queryString, this.subCategory})
      : super(key: key);

  @override
  _CategoryIndiViewState createState() => _CategoryIndiViewState();
}

class _CategoryIndiViewState extends State<CategoryIndiView> {
  ProductFilter filter;
  bool showRandomProducts = true;
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    filter = ProductFilter(existingQueryString: widget.queryString + ";");
    super.initState();
  }

  final _random = new Random();

  int next(int min, int max) => min + _random.nextInt(max - min);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CategoriesController()
        ..init(subCategory: widget?.subCategory ?? ''),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // centerTitle: true,
          title: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              widget.subCategory,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              iconSize: 50,
              icon: Icon(FontAwesomeIcons.slidersH,
                  color: Colors.black, size: 20),
              onPressed: () async {
                ProductFilter filterDialogResponse = await showModalBottomSheet(
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
                          oldFilter: filter,
                          showCategories: false,
                        ));
                  },
                );

                if (filterDialogResponse != null) {
                  setState(() {
                    showRandomProducts = false;
                    filter = filterDialogResponse;
                    key = UniqueKey();
                  });
                }
              },
            ),
          ],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: newBackgroundColor,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              waterDropColor: logoRed,
              refresh: Center(
                child: CircularProgressIndicator(),
              ),
              complete: Container(),
            ),
            controller: refreshController,
            onRefresh: () async {
              setState(() {
                key = new UniqueKey();
              });

              await Future.delayed(Duration(milliseconds: 1000));

              refreshController.refreshCompleted(resetFooterState: true);
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 500)),
                          builder: (c, s) => s.connectionState ==
                                  ConnectionState.done
                              ? GridListWidget<Products, Product>(
                                  key: key,
                                  context: context,
                                  filter: filter,
                                  gridCount: 2,
                                  emptyListWidget: EmptyListWidget(
                                      text:
                                          "We're out of all ${widget.subCategory}.\nCheck Back Later!"),
                                  controller: ProductsGridViewBuilderController(
                                    randomize: showRandomProducts,
                                    limit: 1000,
                                  ),
                                  childAspectRatio: 0.7,
                                  tileBuilder: (BuildContext context, data,
                                      index, onUpdate, onDelete) {
                                    return ProductTileUI(
                                      data: data,
                                      cardPadding: EdgeInsets.zero,
                                      onClick: () =>
                                          BaseController.goToProductPage(data),
                                      index: index,
                                    );
                                  },
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    childCount: 1,
                  ),
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
