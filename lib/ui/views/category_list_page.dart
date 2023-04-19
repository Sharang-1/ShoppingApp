import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/widgets/shimmer/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/grid_view_builder/categories_view_builder_controller.dart';
import '../../locator.dart';
import '../../models/categorys.dart';
import '../../models/grid_view_builder_filter_models/base_filter_model.dart';
import '../../models/grid_view_builder_filter_models/categoryFilter.dart';
import '../../services/api/api_service.dart';
import '../widgets/categoryTileUI.dart';

class CategoryListPage extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  final CategoriesGridViewBuilderController controller =
      CategoriesGridViewBuilderController();

  final BaseFilterModel filter = CategoryFilter();

  final APIService _apiService = locator<APIService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Categories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: _apiService.getRootCategory(),
              builder: (context, AsyncSnapshot<RootCategory> snapshot) {
                if (snapshot.hasData) {
                  return Flexible(
                    child: ListView.builder(
                      itemCount: snapshot.data!.children!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: NewCategoryTile(
                            data: snapshot.data!.children![index],
                            fromCategory: false,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                      height: Get.size.height * 0.68, child: ShimmerWidget());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
