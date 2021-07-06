import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/dzor_explore_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../shared/app_colors.dart';
import '../widgets/section_builder.dart';

class DzorExploreView extends StatefulWidget {
  @override
  _DzorExploreViewState createState() => _DzorExploreViewState();
}

class _DzorExploreViewState extends State<DzorExploreView> {
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DzorExploreController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // centerTitle: true,
          title: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              "Dzor Explore",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: appBarIconColor),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SmartRefresher(
              enablePullDown: true,
              footer: null,
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
                  key = UniqueKey();
                });
                await Future.delayed(Duration(milliseconds: 100));
                refreshController.refreshCompleted(resetFooterState: true);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SectionBuilder(
                      context: context,
                      layoutType: LayoutType.PRODUCT_LAYOUT_3,
                      scrollDirection: Axis.vertical,
                      controller: ProductsGridViewBuilderController(
                          randomize: true, limit: 100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
