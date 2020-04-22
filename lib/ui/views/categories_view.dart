import 'package:compound/models/categorys.dart';
import 'package:compound/models/grid_view_builder_filter_models/categoryFilter.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/categoryTileUI.dart';
import 'package:compound/viewmodels/categories_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/categories_view_builder_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class CategoriesView extends StatefulWidget {
  CategoriesView({Key key}) : super(key: key);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final searchController = TextEditingController();
  final categoriesGridKey = UniqueKey();
  final CategoryFilter categoryFilter = CategoryFilter();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CategoriesViewModel>.withConsumer(
      viewModel: CategoriesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Categories"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: GridListWidget<Categorys, Category>(
            key: categoriesGridKey,
            context: context,
            filter: categoryFilter,
            gridCount: 2,
            childAspectRatio: 0.85,
            viewModel: CategoriesGridViewBuilderViewModel(),
            disablePagination: true,
            tileBuilder: (BuildContext context, data) {
              return GestureDetector(
                onTap: () => model.showProducts(
                  data.filter,
                  data.name,
                ),
                child: CategoryTileUI(
                  data: data,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

