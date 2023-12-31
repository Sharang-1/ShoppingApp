import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/server_urls.dart';
import '../../services/navigation_service.dart';
import '../widgets/product_tile_ui_3.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/categories_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../shared/app_colors.dart';
import '../widgets/grid_list_widget2.dart';
import '../widgets/product_filter_dialog.dart';

class CategoryIndiView extends StatefulWidget {
  final String? queryString;
  final String? subCategory;
  final String? categoryPhoto;

  const CategoryIndiView(
      {Key? key, this.queryString, this.subCategory, this.categoryPhoto})
      : super(key: key);

  @override
  _CategoryIndiViewState createState() => _CategoryIndiViewState();
}

class _CategoryIndiViewState extends State<CategoryIndiView> {
  late ProductFilter filter;
  bool showRandomProducts = true;
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    if (kDebugMode) print("heloo" + widget.subCategory.toString());
    filter = ProductFilter(existingQueryString: widget.queryString! + ";");
    super.initState();
  }

  final _random = new Random();

  int next(int min, int max) => min + _random.nextInt(max - min);

// create map to find cateogry no
  Map<String, String> categoryNameToNum = {
    "Kurtas": "1",
    "Dresses": "2",
    "Gowns": "3",
    "Chaniya Cholis": "4",
    "Suit sets": "5",
    "Indo-Western": "6",
    "Blouses": "7",
    "Duppatta": "8",
    "Bags": "9",
    "Footwear": "10",
    "Jewellery": "11",
    "Saree": "12",
    "Cloth Materials": "13",
    "Lenghas": "14",
    "Face Masks": "15",
    "Bottoms": "16",
    "Kaftans": "17",
    "Tops": "18",
    "Shrugs & Jackets": "19",
    "Hair Accessories": "20",
    "Home Decor": "21",
  };

  @override
  Widget build(BuildContext context) {
    var categoryNo = categoryNameToNum[widget.subCategory];

    return GetBuilder(
      init: CategoriesController()..init(subCategory: widget.subCategory ?? ''),
      builder: (controller) => Scaffold(
        backgroundColor: newBackgroundColor,
        body: SafeArea(
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
                key = new UniqueKey();
              });

              await Future.delayed(Duration(milliseconds: 1000));

              refreshController.refreshCompleted(resetFooterState: true);
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  toolbarHeight: 120,
                  leading: InkWell(
                    onTap: () => NavigationService.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.navigate_before,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      iconSize: 50,
                      icon: Icon(FontAwesomeIcons.slidersH,
                          color: Colors.black, size: 20),
                      onPressed: () async {
                        ProductFilter filterDialogResponse =
                            await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          isScrollControlled: true,
                          clipBehavior: Clip.antiAlias,
                          context: context,
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                                heightFactor: 0.75,
                                child: ProductFilterDialog(
                                  category: categoryNo,
                                  oldFilter: ProductFilter(
                                      existingQueryString:
                                          widget.queryString! + ";"),
                                  showCategories: false,
                                ));
                          },
                        );
                        // ignore: unnecessary_null_comparison
                        if (filterDialogResponse != null) {
                          setState(() {
                            showRandomProducts = false;
                            filter = filterDialogResponse;
                            key = UniqueKey();
                          });
                        }
                      },
                    ),
                  ],
                  centerTitle: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   height: 60,
                      //   child: FadeInImage.assetNetwork(
                      //     fit: BoxFit.fill,
                      //     fadeInCurve: Curves.easeIn,
                      //     placeholder: 'assets/images/category_preloading.png',
                      //     image: widget.categoryPhoto != null
                      //         ? '$CATEGORY_PHOTO_BASE_URL/${widget.categoryPhoto}'
                      //         : 'assets/images/category_preloading.png',
                      //     imageErrorBuilder: (context, error, stackTrace) =>
                      //         Image.asset(
                      //       "assets/images/category_preloading.png",
                      //       fit: BoxFit.fill,
                      //     ),
                      //   ),
                      // ),
                      Text(
                        widget.subCategory ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  floating: false,
                  backgroundColor: Colors.white,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 500)),
                          builder: (c, s) => s.connectionState ==
                                  ConnectionState.done
                              ? GridListWidget2<Products, Product>(
                                  key: key,
                                  context: context,
                                  filter: filter,
                                  gridCount: 1,
                                  onEmptyList: () {},
                                  emptyListWidget: EmptyListWidget(
                                      text:
                                          "We're out of all ${widget.subCategory}.\nCheck Back Later!"),
                                  controller: ProductsGridViewBuilderController(
                                    randomize: showRandomProducts,
                                    limit: 300,
                                  ),
                                  childAspectRatio: 3,
                                  tileBuilder: (BuildContext context, data,
                                      index, onUpdate, onDelete) {
                                    debugPrint("category data $data");
                                    return ProductTileUI3(
                                      data: data,
                                      cardPadding: EdgeInsets.zero,
                                      onClick: () =>
                                          BaseController.goToProductPage(data),
                                      index: index,
                                    );
                                  },
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    childCount: 1,
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
