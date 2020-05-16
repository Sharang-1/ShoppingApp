import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/productListViewModel.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class ProductListView extends StatefulWidget {
  final String queryString;
  final String subCategory;

  ProductListView({
    Key key,
    @required this.queryString,
    @required this.subCategory,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  ProductFilter filter;
  UniqueKey key = UniqueKey();

  @override
  void initState() {
    filter = ProductFilter(existingQueryString: widget.queryString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProductListViewModel>.withConsumer(
      viewModel: ProductListViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.subCategory),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: GridListWidget<Products, Product>(
            key: key,
            context: context,
            filter: filter,
            gridCount: 2,
            viewModel: ProductsGridViewBuilderViewModel(),
            childAspectRatio: 0.7,
            tileBuilder: (BuildContext context, data, index, onUpdate, onDelete) {
              Fimber.d("test");
              print((data as Product).toJson());
              return ProductTileUI(
                data: data,
              );
            },
          ),
        ),
      ),
    );
  }
}
