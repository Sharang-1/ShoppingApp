import 'package:compound/controllers/dzor_explore_controller.dart';
import 'package:compound/controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/widgets/section_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
          centerTitle: true,
          title: SvgPicture.asset(
            "assets/svg/logo.svg",
            color: logoRed,
            height: 35,
            width: 35,
          ),
          iconTheme: IconThemeData(color: appBarIconColor),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Explore Dzor",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
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
                      refreshController.refreshCompleted(
                          resetFooterState: true);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SectionBuilder(
                            context: context,
                            layoutType: LayoutType.PRODUCT_LAYOUT_3,
                            scrollDirection: Axis.vertical,
                            controller: ProductsGridViewBuilderController(
                                randomize: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
