import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';

import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/categories_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    // const double headingFontSize = headingFontSizeStyle;
    // String catBgColor = categoriesIndiBgColorsPallete[
    //     next(0, categoriesIndiBgColorsPallete.length - 1)];

    return ViewModelProvider<CategoriesViewModel>.withConsumer(
      viewModel: CategoriesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              waterDropColor: Colors.blue,
              refresh: Container(),
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
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: logoRed,
                  centerTitle: true,
                  iconTheme: IconThemeData(color: Colors.white),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: AppBar(
                      primary: false,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: logoRed,
                      title: CustomText(
                        widget.subCategory,
                        color: Colors.white,
                        dotsAfterOverFlow: true,
                        fontSize: 25,
                        isBold: true,
                        isTitle: true,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => Container(
                      color: backgroundWhiteCreamColor,
                      // height: 500,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 60,
                                color: logoRed,
                              ),
                              Container(
                                height: 50,
                                margin: EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  color: backgroundWhiteCreamColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(curve30),
                                    topRight: Radius.circular(curve30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder(
                            future: Future.delayed(Duration(milliseconds: 500)),
                            builder: (c, s) =>
                                s.connectionState == ConnectionState.done
                                    ? GridListWidget<Products, Product>(
                                        key: key,
                                        context: context,
                                        filter: filter,
                                        gridCount: 2,
                                        emptyListWidget: EmptyListWidget(text: ""),
                                        viewModel:
                                            ProductsGridViewBuilderViewModel(),
                                        childAspectRatio: 0.7,
                                        tileBuilder: (BuildContext context,
                                            data, index, onUpdate, onDelete) {
                                          return ProductTileUI(
                                            data: data,
                                            onClick: () =>
                                                model.goToProductPage(data),
                                            index: index,
                                          );
                                        },
                                      )
                                    : Container(),
                          ),
                        ],
                      ),
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

  // Color _colorFromHex(String hexColor) {
  //   final hexCode = hexColor.replaceAll('#', '');
  //   return Color(int.parse('FF$hexCode', radix: 16));
  // }
}
