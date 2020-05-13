import 'package:compound/models/categorys.dart';
import 'package:compound/models/grid_view_builder_filter_models/categoryFilter.dart';
import 'package:compound/ui/shared/app_colors.dart';
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
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Categories",
            style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontFamily: "Raleway",
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: backgroundWhiteCreamColor,
          elevation: 0,
        ),
        backgroundColor: backgroundWhiteCreamColor,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: GridListWidget<Categorys, Category>(
            key: categoriesGridKey,
            context: context,
            filter: categoryFilter,
            gridCount: 1,
            childAspectRatio: 3,
            viewModel: CategoriesGridViewBuilderViewModel(),
            disablePagination: true,
            tileBuilder: (BuildContext context, data, index) {
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
