import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/lookup_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';

class ProductFilterDialog extends StatefulWidget {
  final ProductFilter oldFilter;
  final bool showCategories;
  const ProductFilterDialog(
      {Key key, this.oldFilter, this.showCategories = true})
      : super(key: key);

  @override
  _ProductFilterDialogState createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  String fullText;
  String categories;
  List<String> subCategories;
  List<String> size;
  int minPrice;
  int maxPrice;
  int minDiscount;
  String sortField; // modified / price
  bool isSortOrderDesc; // asc / desc

  int categoriesRadioValue = -1;
  String sortByRadioValue = 'price';
  String sortOrderRadioValue = 'asc';
  String queryString = '';

  // Map<String, int> categoriesRadioMap = {
  //   'Men': 2,
  //   'Women': 1,
  //   'Both': -1,
  // };

  // Map<String, String> sortByRadioMap = {
  //   'Arrival Date': 'modified',
  //   'Price': 'price',
  // };

  Map<String, String> sortOrderRadioMap = {
    'Low To High': 'asc',
    'High To Low': 'desc',
  };

  Map<String, bool> subCategoriesValues = {};
  Map<String, int> subCategoriesAPIValue = {};
  Map<int, String> subCategoriesAPIIntToValue = {};

  // Map<String, bool> subCategoriesValues = {
  //   'All': false,
  //   'Dresses': false,
  //   'Kurtas': false,
  //   'Gowns': false,
  //   'Chaniya Cholies': false,
  //   'Suit Sets': false,
  //   'Indo-Western': false,
  //   'Blouses': false,
  //   'Dupattas': false,
  //   'Fabric Bags': false,
  //   'Traditional…/Ethnic wear footwear': false,
  //   'Home Made Jewellery': false,
  //   'Saree': false,
  //   'Cloth Materials': false,
  //   'Lenghas': false
  // };

  // Map<String, int> subCategoriesAPIValue = {
  //   'All': -1,
  //   'Kurtas': 1,
  //   'Dresses': 2,
  //   'Gowns': 3,
  //   'Chaniya Cholies': 4,
  //   'Suit Sets': 5,
  //   'Indo-Western': 6,
  //   'Blouses': 7,
  //   'Dupattas': 8,
  //   'Fabric Bags': 9,
  //   'Traditional…/Ethnic wear footwear': 10,
  //   'Home Made Jewellery': 11,
  //   'Saree': 12,
  //   'Cloth Materials': 13,
  //   'Lenghas': 14
  // };
  // Map<int, String> subCategoriesAPIIntToValue = {
  //   -1: 'All',
  //   1: 'Kurtas',
  //   2: 'Dresses',
  //   3: 'Gowns',
  //   4: 'Chaniya Cholies',
  //   5: 'Suit Sets',
  //   6: 'Indo-Western',
  //   7: 'Blouses',
  //   8: 'Dupattas',
  //   9: 'Fabric Bags',
  //   10: 'Traditional…/Ethnic wear footwear',
  //   11: 'Home Made Jewellery',
  //   12: 'Saree',
  //   13: 'Cloth Materials',
  //   14: 'Lenghas'
  // };

  final _formKey = GlobalKey();

  @override
  void initState() {
    locator<LookupController>()
        .lookups
        .singleWhere((e) => e.sectionName == "Product")
        .sections
        .firstWhere((e) => e.option == "categories")
        .values
        .forEach((e) {
      if (e.id == -1) {
        subCategoriesAPIValue.addAll({"All": e.id});
        subCategoriesAPIIntToValue.addAll({e.id: "All"});
        subCategoriesValues.addAll({"All": false});
        return;
      }
      subCategoriesAPIValue.addAll({e.name: e.id});
      subCategoriesAPIIntToValue.addAll({e.id: e.name});
      subCategoriesValues.addAll({e.name: false});
    });

    if (widget?.oldFilter?.categories != null) {
      if (widget?.oldFilter?.categories == "1")
        categoriesRadioValue = 1;
      else if (widget?.oldFilter?.categories == "2") categoriesRadioValue = 2;
    }

    if (widget?.oldFilter?.subCategories != null) {
      print(">>>>>>>>> subCategories <<<<<<<<<<<<<<<<<<<<<<<");
      print(widget?.oldFilter?.subCategories);
      widget?.oldFilter?.subCategories?.forEach((v) {
        print(">>>>>>>>> subCategories - value <<<<<<<<<<<<<<<<<<<<<<<");
        print(v);
        String sKey = subCategoriesAPIIntToValue[int.parse(v)];
        print(">>>>>>>>> subCategories - key <<<<<<<<<<<<<<<<<<<<<<<");
        print(sKey);
        subCategoriesValues[sKey] = true;
      });

      bool isAllTrue = false;
      subCategoriesValues.values.map((v) => isAllTrue = !v);

      if (isAllTrue) {
        subCategoriesValues['All'] = true;
      }
    }

    fullText = widget.oldFilter?.fullText ?? "";
    categories = widget.oldFilter?.categories;
    subCategories = widget.oldFilter?.subCategories;
    size = widget.oldFilter?.size;
    minPrice = widget.oldFilter?.minPrice ?? 0;
    maxPrice = widget.oldFilter?.maxPrice ?? 50000;
    minDiscount = widget.oldFilter?.minDiscount ?? 0;
    sortByRadioValue = sortField = widget.oldFilter?.sortField;
    isSortOrderDesc = widget.oldFilter?.isSortOrderDesc;
    sortOrderRadioValue = isSortOrderDesc == true ? 'desc' : 'asc';
    queryString = widget?.oldFilter?.queryString ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle = TextStyle(
      fontSize: titleFontSize,
      fontWeight: FontWeight.bold,
    );

    print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd ");
    print(widget.oldFilter?.subCategories);

    return Scaffold(
        backgroundColor: Colors.grey[50],
        bottomNavigationBar: FractionallySizedBox(
          widthFactor: 0.40,
          heightFactor: 0.08,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.green[600],
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     side: BorderSide(color: Colors.black, width: 0.5)),
            label: Text(
              "Apply Filters",
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // icon: Icon(Icons.done),
            icon: Icon(Icons.done),
            onPressed: () {
              setUpFilterObject();
              print("Typing---------------------------------->>>>>>>>>>>>>>");
              NavigationService.back<ProductFilter>(
                result: ProductFilter(
                  fullText: fullText,
                  categories: categories,
                  subCategories:
                      subCategoriesValues["All"] ? [] : subCategories,
                  size: size,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  minDiscount: minDiscount,
                  sortField: sortByRadioValue,
                  isSortOrderDesc: sortOrderRadioValue == 'desc',
                  existingQueryString: queryString,
                ),
              );
            },
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          primary: true,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "Sort and Filters",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: "Reset",
              icon: Icon(
                Icons.restore,
              ),
              onPressed: () {
                setState(() {
                  categories = "";
                  subCategories = [];
                  size = [];
                  minPrice = 0;
                  maxPrice = 50000;
                  minDiscount = 0;
                  sortByRadioValue = sortField = "price";
                  isSortOrderDesc = false;
                  sortOrderRadioValue =
                      isSortOrderDesc == true ? 'desc' : 'asc';

                  for (var key in subCategoriesValues.keys) {
                    subCategoriesValues[key] = false;
                  }
                });
              },
            ),
            IconButton(
              tooltip: "Close",
              icon: Icon(CupertinoIcons.clear_circled_solid),
              color: Colors.grey[700],
              onPressed: () {
                NavigationService.back();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpaceSmall,
                  // Text('Categories', style: titleTextStyle),
                  // verticalSpaceTiny,
                  // Wrap(
                  //   spacing: 5,
                  //   children: categoriesRadioMap.keys.map((String sKey) {
                  //     return ChoiceChip(
                  //       label: Text(sKey),
                  //       labelStyle: TextStyle(color: Colors.black),
                  //       backgroundColor: Colors.white,
                  //       selectedColor: Colors.grey.withOpacity(0.5),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8),
                  //           side: BorderSide(
                  //               width: 0.5,
                  //               color:
                  //                   // categoriesRadioValue ==
                  //                   //         categoriesRadioMap[sKey]
                  //                   //     ? Colors.amber
                  //                   // :
                  //                   Colors.black)),
                  //       selected:
                  //           (categoriesRadioValue == categoriesRadioMap[sKey]),
                  //       onSelected: (val) {
                  //         setState(() {
                  //           categoriesRadioValue =
                  //               val ? categoriesRadioMap[sKey] : null;
                  //         });
                  //         // print(sKey +
                  //         //     "value:" +
                  //         //     val.toString() +
                  //         //     categoriesRadioValue.toString() +
                  //         //     (categoriesRadioValue == categoriesRadioMap[sKey])
                  //         //         .toString());
                  //       },
                  //     );
                  //   }).toList(),
                  // ),
                  // spaceDividerExtraThin,
                  // verticalSpaceSmall,
                  if (widget.showCategories)
                    Text('Categories', style: titleTextStyle),
                  if (widget.showCategories) verticalSpaceTiny,
                  if (widget.showCategories)
                    Wrap(
                      spacing: 5,
                      children: subCategoriesValues.keys.map(
                        (String sKey) {
                          return FilterChip(
                            backgroundColor: Colors.white,
                            checkmarkColor: green,
                            selectedColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: subCategoriesValues[sKey]
                                      ? green
                                      : Colors.grey,
                                  width: 0.5,
                                )),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: subCategoriesValues[sKey]
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: subCategoriesValues[sKey]
                                    ? green
                                    : Colors.grey),
                            label: Text(sKey),
                            selected: subCategoriesValues[sKey],
                            onSelected: (val) {
                              if (sKey != "All") {
                                setState(() {
                                  subCategoriesValues[sKey] = val;
                                  if (!val) subCategoriesValues["All"] = val;
                                });
                                return;
                              }
                              setState(() {
                                subCategoriesValues[sKey] = val;
                              });
                              setState(() {
                                for (var k in subCategoriesValues.keys) {
                                  subCategoriesValues[k] = val;
                                }
                              });
                            },
                          );
                        },
                      ).toList(),
                    ),
                  spaceDividerExtraThin,
                  verticalSpaceSmall,
                  Text('By Price', style: titleTextStyle),
                  verticalSpaceTiny,
                  Align(
                    alignment: Alignment.center,
                    child: Text('Rs. $minPrice - Rs. $maxPrice',
                        style: TextStyle(fontSize: 14)),
                  ),
                  RangeSlider(
                    min: 0,
                    max: 50000,
                    divisions: 100,

                    inactiveColor: Colors.grey.withOpacity(0.38),
                    activeColor: darkRedSmooth,
                    // labels:
                    //     RangeLabels(minPrice.toString(), maxPrice.toString()),
                    values:
                        RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
                    onChanged: (val) {
                      setState(() {
                        minPrice = val.start.toInt();
                        maxPrice = val.end.toInt();
                      });
                    },
                  ),
                  verticalSpaceSmall,
                  Text('By Discount', style: titleTextStyle),
                  verticalSpaceTiny,
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        '$minDiscount %',
                        style: TextStyle(fontSize: 14),
                      )),
                  Row(
                    children: <Widget>[
                      // horizontalSpaceTiny,
                      // // Text("0"),
                      horizontalSpaceTiny,
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 100,
                          divisions: 20,
                          value: minDiscount.toDouble(),
                          inactiveColor: Colors.grey.withOpacity(0.38),
                          activeColor: darkRedSmooth,
                          onChanged: (val) {
                            setState(() {
                              minDiscount = val.toInt();
                            });
                          },
                        ),
                      ),
                      horizontalSpaceTiny,
                    ],
                  ),
                  spaceDividerExtraThin,
                  verticalSpaceSmall,
                  Text('Sort By Price', style: titleTextStyle),
                  verticalSpaceTiny,
                  // Wrap(
                  //   spacing: 5,
                  //   children: sortByRadioMap.keys.map((String sKey) {
                  //     return ChoiceChip(
                  //       backgroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //           side: BorderSide(
                  //             color: sortByRadioValue == sortByRadioMap[sKey]
                  //                 ? green
                  //                 : Colors.grey,
                  //             width: 0.5,
                  //           )),
                  //       labelStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: sortByRadioValue == sortByRadioMap[sKey]
                  //               ? FontWeight.w600
                  //               : FontWeight.normal,
                  //           color: sortByRadioValue == sortByRadioMap[sKey]
                  //               ? green
                  //               : Colors.grey),
                  //       selectedColor: Colors.white,
                  //       selected: sortByRadioValue == sortByRadioMap[sKey],
                  //       onSelected: (val) {
                  //         setState(() => sortByRadioValue =
                  //             val ? sortByRadioMap[sKey] : null);
                  //         // print(sortByRadioMap[sKey] + val.toString() + sKey);
                  //       },
                  //       label: Text(sKey),
                  //     );
                  //   }).toList(),
                  // ),
                  // spaceDividerExtraThin,
                  // verticalSpaceSmall,
                  // Text('Sort Order', style: titleTextStyle),
                  verticalSpaceTiny,
                  Wrap(
                    spacing: 5,
                    children: sortOrderRadioMap.keys.map((String sKey) {
                      return ChoiceChip(
                        backgroundColor: Colors.white,
                        selectedShadowColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color:
                                  sortOrderRadioValue == sortOrderRadioMap[sKey]
                                      ? green
                                      : Colors.grey,
                              width: 0.5,
                            )),
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                sortOrderRadioValue == sortOrderRadioMap[sKey]
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                            color:
                                sortOrderRadioValue == sortOrderRadioMap[sKey]
                                    ? green
                                    : Colors.grey),
                        selectedColor: Colors.white,
                        label: Text(sKey),
                        selected:
                            sortOrderRadioValue == sortOrderRadioMap[sKey],
                        onSelected: (val) {
                          setState(() => sortOrderRadioValue =
                              val ? sortOrderRadioMap[sKey] : null);
                        },
                      );
                    }).toList(),
                  ),
                  // spaceDividerExtraThin,
                  verticalSpaceMedium
                ],
              ),
            ),
          ),
        ));
  }

  void setUpFilterObject() {
    /*
    final String fullText;
    final String categories;
    final List<String> subCategories;
    final List<String> size;
    final int minPrice;
    final int maxPrice;
    final int minDiscount;
    final String sortField;
    final bool isSortOrderDesc;
    */

    setState(() {
      categories = categoriesRadioValue.toString();

      Fimber.d("subCategoriesValues['All'] --------------------------");
      Fimber.d(subCategoriesValues['All'].toString());
      if (subCategoriesValues['All'] == true) {
        // If all values are selected then no need to filter.
        subCategories = [];
      } else {
        Fimber.d("Test ////////////////////////////");
        // Check if all values are false or not.
        bool isAllFalse = true;
        Fimber.d(subCategoriesValues.values.toString());
        subCategoriesValues.values.toList().forEach((v) {
          if (v == true) {
            isAllFalse = false;
          }
        });

        Fimber.d("isAllFalse-------->>>>---------");
        Fimber.d(isAllFalse.toString());
        if (isAllFalse) {
          // If no values are selected then no need to filter.
          subCategories = null;
        } else {
          // Get all true keys.
          subCategories = subCategoriesValues.keys
              .toList()
              .where((sKey) => subCategoriesValues[sKey])
              .map((fKey) => subCategoriesAPIValue[fKey].toString())
              .toList();

          Fimber.d("subCategories --------------------------");
          Fimber.d(subCategories.toString());
        }
      }

      size = null;
    });
  }
}

/// Search Functionalities.
// / create product tile ui
// / check and debug filters for products
// / create sellers' grid view
// / create sellers' tile ui
// / search sellers's by name