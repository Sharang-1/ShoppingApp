import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/categories_controller.dart';
import '../../controllers/grid_view_builder/categories_view_builder_controller.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/categoryFilter.dart';
import '../shared/app_colors.dart';
import '../widgets/categoryTileUI.dart';
import '../widgets/grid_list_widget.dart';

class CategoriesView extends StatefulWidget {
  CategoriesView({Key key}) : super(key: key);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final searchController = TextEditingController();
  UniqueKey categoriesGridKey = UniqueKey();
  final CategoryFilter categoryFilter = CategoryFilter();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            "Categories",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: newBackgroundColor,
      body: SafeArea(
        top: false,
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
              categoriesGridKey = new UniqueKey();
            });
            refreshController.refreshCompleted(resetFooterState: true);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 4.0, right: 8.0),
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 500)),
              builder: (c, s) => s.connectionState == ConnectionState.done
                  ? GridListWidget<Categorys, Category>(
                      key: categoriesGridKey,
                      context: context,
                      filter: categoryFilter,
                      gridCount: 2,
                      childAspectRatio: 2,
                      controller: CategoriesGridViewBuilderController(),
                      disablePagination: true,
                      tileBuilder: (BuildContext context, data, index, onDelete,
                          onUpdate) {
                        return GestureDetector(
                          onTap: () => CategoriesController.showProducts(
                            data.filter,
                            data.name,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                            child: CategoryTileUI(
                              data: data,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
