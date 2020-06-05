import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/dashed_line.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';

import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:fimber/fimber.dart';

import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

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

  @override
  void initState() {
    filter = ProductFilter(existingQueryString: widget.queryString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CartViewModel>.withConsumer(
      viewModel: CartViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                backgroundColor: _colorFromHex("#7062b1"),
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: AppBar(
                      primary: false,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: _colorFromHex("#7062b1"),
                      title: CustomText(
                        widget.subCategory,
                        color: Colors.white,
                        dotsAfterOverFlow: true,
                        fontSize: 25,
                        isBold: true,
                        isTitle: true,
                      )),
                ),
              ),
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Container(
                    color: backgroundWhiteCreamColor,
                    height: 1000,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 60,
                              color: _colorFromHex("#7062b1"),
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
                        GridListWidget<Products, Product>(
                          key: key,
                          context: context,
                          filter: filter,
                          gridCount: 2,
                          viewModel: ProductsGridViewBuilderViewModel(),
                          childAspectRatio: 0.7,
                          tileBuilder: (BuildContext context, data, index,
                              onUpdate, onDelete) {
                            Fimber.d("test");
                            print((data as Product).toJson());
                            return ProductTileUI(
                              data: data,
                              onClick: () => {},
                              index: index,
                            );
                          },
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
    );
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
