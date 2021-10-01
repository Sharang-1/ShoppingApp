import 'package:compound/utils/lang/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/grid_view_builder/categories_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/categoryFilter.dart';
import '../shared/app_colors.dart';
import '../widgets/section_builder.dart';
import 'package:get/get.dart';

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
            NAVBAR_CATEGORIES.tr,
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
              child: Center(
                child: Image.asset(
                  "assets/images/loading_img.gif",
                  height: 25,
                  width: 25,
                ),
              ),
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
            padding: EdgeInsets.only(top: 16.0, left: 4.0, right: 8.0),
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 500)),
              builder: (c, s) => s.connectionState == ConnectionState.done
                  ? SingleChildScrollView(
                      child: SectionBuilder(
                        key: categoriesGridKey,
                        context: context,
                        layoutType: LayoutType.CATEGORY_LAYOUT_4,
                        controller: CategoriesGridViewBuilderController(),
                        filter: categoryFilter,
                        scrollDirection: Axis.vertical,
                        gridCount: 3,
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
