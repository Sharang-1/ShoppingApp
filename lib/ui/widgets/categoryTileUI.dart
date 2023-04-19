import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../models/categorys.dart';
import '../../models/productPageArg.dart';
import '../../services/navigation_service.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';

class CategoryTileUI extends StatelessWidget {
  final Category data;
  const CategoryTileUI({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = data.name ?? "";
    bool isTablet = Tools.checkIfTablet(MediaQuery.of(context));

    double titleFontSize = isTablet ? 28.0 : 20.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: Colors.grey,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.srcATop),
              child: FastCachedImage(
                // child: CachedNetworkImage(
                errorBuilder:
                    // errorWidget:
                    (context, url, error) => Image.asset(
                  'assets/images/category_preloading.png',
                  fit: BoxFit.cover,
                ),
                url:
                    // imageUrl:
                    data.id != null
                        ? '$CATEGORY_PHOTO_BASE_URL/${data.id}'
                        : 'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                fit: BoxFit.fill,
                // fadeInCurve: Curves.easeIn,
                // placeholder:
                loadingBuilder: (context, url) => Image.asset(
                  'assets/images/category_preloading.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Tools.getTruncatedString(20, name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewCategoryTile extends StatelessWidget {
  // final Category data;
  final RootCategory data;
  final bool fromCategory;
  const NewCategoryTile({
    Key? key,
    required this.data,
    this.fromCategory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double titleFontSize = 10.0;

    return CategoryCard(
      category: data,
    );
  }
}

class CategoryCard extends StatefulWidget {
  final RootCategory category;
  double height = 150;
  double itemHeight = 0;
  double subCategoryHeight = 0;
  double categoryHeight = 0;
  double subSubCategoryHeight = 0;
  double subSubSubCategoryHeight = 0;

  CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [logoRed, lightRedSmooth],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: widget.height == 150
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                  alignment: Alignment(-1, 0),
                  child: Text(
                    Tools.getTruncatedString(
                      15,
                      widget.category.name ?? "",
                    ),
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.only(bottom: 16.0),
                    height: widget.itemHeight,
                    child: Image.network(
                      '$CATEGORY_PHOTO_BASE_URL/${widget.category.id}',
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (widget.height == 150) {
                            widget.height = 350;
                            widget.itemHeight = 150;
                            widget.categoryHeight = 100;
                          } else {
                            widget.height = 150;
                            widget.itemHeight = 0;
                            widget.categoryHeight = 0;
                            widget.subCategoryHeight = 0;
                            widget.subSubCategoryHeight = 0;
                            widget.subSubSubCategoryHeight = 0;
                          }
                        });
                      },
                      child: Text(
                        'View more',
                        style: TextStyle(
                            color: lightRedSmooth, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget.category.children != null)
            AnimatedContainer(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.only(top: 16.0),
              height: widget.categoryHeight > 0 ? widget.categoryHeight : 0,
              child: ListView.builder(
                itemCount: widget.category.children!.length,
                itemBuilder: (context, index) {
                  var data1 = widget.category.children?[index];
                  return AnimatedContainer(
                      alignment: Alignment.centerLeft,
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              if (data1!.children != null) {
                                setState(() {
                                  if (widget.height == 350) {
                                    widget.height = 550;
                                    widget.categoryHeight = 300;
                                    widget.subCategoryHeight = 100;
                                  } else {
                                    widget.height = 350;
                                    widget.categoryHeight = 100;
                                    widget.subCategoryHeight = 0;
                                    widget.subSubCategoryHeight = 0;
                                    widget.subSubSubCategoryHeight = 0;
                                  }
                                });
                              } else {
                                NavigationService.to(CategoryIndiViewRoute,
                                    arguments: ProductPageArg(
                                      queryString: data1.filter,
                                      subCategory: data1.name,
                                    ));
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              alignment: (widget.subCategoryHeight > 0 &&
                                      (data1!.children != null))
                                  ? Alignment.centerLeft
                                  : Alignment.center,
                              child: Text(data1?.name ?? "",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          if (data1!.children != null)
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.only(top: 4.0),
                              height: widget.subCategoryHeight > 0
                                  ? widget.subCategoryHeight
                                  : 0,
                              child: ListView.builder(
                                itemCount: data1.children?.length,
                                itemBuilder: (context, index) {
                                  var data2 = data1.children?[index];
                                  return AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              if (data2?.children != null) {
                                                setState(() {
                                                  if (widget.height == 550) {
                                                    widget.height = 750;
                                                    widget.categoryHeight = 500;
                                                    widget.subCategoryHeight =
                                                        300;
                                                    widget.subSubCategoryHeight =
                                                        100;
                                                  } else {
                                                    widget.height = 550;
                                                    widget.categoryHeight = 300;
                                                    widget.subCategoryHeight =
                                                        100;
                                                    widget.subSubCategoryHeight =
                                                        0;
                                                    widget.subSubSubCategoryHeight =
                                                        0;
                                                  }
                                                });
                                              } else {
                                                NavigationService.to(
                                                    CategoryIndiViewRoute,
                                                    arguments: ProductPageArg(
                                                      queryString:
                                                          data2?.filter,
                                                      subCategory: data2?.name,
                                                    ));
                                              }
                                            },
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              margin: EdgeInsets.only(
                                                  right:
                                                      widget.subSubCategoryHeight >
                                                                  0 &&
                                                              (data2?.children !=
                                                                  null)
                                                          ? 90
                                                          : 0.0),
                                              child: Text(data2?.name ?? "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          if (data2!.children != null)
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              padding:
                                                  EdgeInsets.only(top: 4.0),
                                              height:
                                                  widget.subSubCategoryHeight >
                                                          0
                                                      ? widget
                                                          .subSubCategoryHeight
                                                      : 0,
                                              child: ListView.builder(
                                                itemCount:
                                                    data2.children?.length,
                                                itemBuilder: (context, index) {
                                                  var data3 =
                                                      data2.children?[index];
                                                  return AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      margin: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Column(
                                                        children: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                NavigationService.to(
                                                                    CategoryIndiViewRoute,
                                                                    arguments:
                                                                        ProductPageArg(
                                                                      queryString:
                                                                          data3
                                                                              ?.filter,
                                                                      subCategory:
                                                                          data3
                                                                              ?.name,
                                                                    )),
                                                            child:
                                                                AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              child: Text(
                                                                  data3?.name ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                },
                                              ),
                                            )
                                        ],
                                      ));
                                },
                              ),
                            )
                        ],
                      ));
                },
              ),
            )
        ],
      ),
    );
  }
}
