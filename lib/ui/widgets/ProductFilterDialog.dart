import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import '../shared/app_colors.dart';

class ProductFilterDialog extends StatefulWidget {
  final ProductFilter oldFilter;
  const ProductFilterDialog({Key key, this.oldFilter}) : super(key: key);

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

  Map<String, int> categoriesRadioMap = {
    'Men': 2,
    'Women': 1,
    'Both': -1,
  };
  Map<String, String> sortByRadioMap = {
    'Arrival Date': 'modified',
    'Price': 'price',
  };
  Map<String, String> sortOrderRadioMap = {
    'Low To High': 'asc',
    'High To Low': 'desc',
  };
  Map<String, bool> subCategoriesValues = {
    'All': false,
    'Dresses': false,
    'Kurtas': false,
    'Gowns': false,
    'Chaniya Cholies': false,
    'Suit Sets': false,
    'Indo-Western': false,
    'Blouses': false,
    'Dupattas': false,
  };
  Map<String, int> subCategoriesAPIValue = {
    'All': -1,
    'Dresses': 1,
    'Kurtas': 2,
    'Gowns': 3,
    'Chaniya Cholies': 4,
    'Suit Sets': 5,
    'Indo-Western': 6,
    'Blouses': 7,
    'Dupattas': 8,
  };
  Map<int, String> subCategoriesAPIIntToValue = {
    -1: 'All',
    1: 'Dresses',
    2: 'Kurtas',
    3: 'Gowns',
    4: 'Chaniya Cholies',
    5: 'Suit Sets',
    6: 'Indo-Western',
    7: 'Blouses',
    8: 'Dupattas',
  };

  final _formKey = GlobalKey();

  @override
  void initState() {
    if (widget.oldFilter.categories != null) {
      if (widget.oldFilter.categories == "1") {
        categoriesRadioValue = 1;
      } else if (widget.oldFilter.categories == "2") {
        categoriesRadioValue = 2;
      }
    }

    if (widget.oldFilter.subCategories != null) {
      print(">>>>>>>>> subCategories <<<<<<<<<<<<<<<<<<<<<<<");
      print(widget.oldFilter.subCategories);
      widget.oldFilter.subCategories.forEach((v) {
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

    fullText = widget.oldFilter.fullText ?? "";
    categories = widget.oldFilter.categories;
    subCategories = widget.oldFilter.subCategories;
    size = widget.oldFilter.size;
    minPrice = widget.oldFilter.minPrice ?? 0;
    maxPrice = widget.oldFilter.maxPrice ?? 50000;
    minDiscount = widget.oldFilter.minDiscount ?? 0;
    sortByRadioValue = sortField = widget.oldFilter.sortField;
    isSortOrderDesc = widget.oldFilter.isSortOrderDesc;
    sortOrderRadioValue = isSortOrderDesc == true ? 'desc' : 'asc';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle =
        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

    return Scaffold(
        backgroundColor: Colors.grey[50],
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: FractionallySizedBox(
                widthFactor: 0.45,
                heightFactor: 0.09,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.green[600],
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //     side: BorderSide(color: Colors.black, width: 0.5)),
                  label: Text(
                    "Apply Filters",
                    style: TextStyle(color: Colors.white),
                  ),

                  // icon: Icon(Icons.done),
                  icon: Icon(Icons.done),
                  onPressed: () {
                    setUpFilterObject();
                    print(
                        "Typing---------------------------------->>>>>>>>>>>>>>");
                    Navigator.of(context).pop<ProductFilter>(
                      new ProductFilter(
                        fullText: fullText,
                        categories: categories,
                        subCategories: subCategories,
                        size: size,
                        minPrice: minPrice,
                        maxPrice: maxPrice,
                        minDiscount: minDiscount,
                        sortField: sortByRadioValue,
                        isSortOrderDesc: sortOrderRadioValue == 'desc',
                      ),
                    );
                  },
                ))),
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
              onPressed: () {},
            ),
            //   IconButton(
            //     tooltip: "Apply",
            //     icon: Icon(Icons.done),
            //     onPressed: () {
            //       setUpFilterObject();
            //       print("Typing---------------------------------->>>>>>>>>>>>>>");
            //       Navigator.of(context).pop<ProductFilter>(
            //         new ProductFilter(
            //           fullText: fullText,
            //           categories: categories,
            //           subCategories: subCategories,
            //           size: size,
            //           minPrice: minPrice,
            //           maxPrice: maxPrice,
            //           minDiscount: minDiscount,
            //           sortField: sortByRadioValue,
            //           isSortOrderDesc: sortOrderRadioValue == 'desc',
            //         ),
            //       );
            //     },
            //   ),
            IconButton(
              tooltip: "Close",
              icon: Icon(
                Icons.close,
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
                  Text('Categories', style: titleTextStyle),
                  verticalSpaceTiny,
                  Wrap(
                    spacing: 5,
                    children: subCategoriesValues.keys.map(
                      (String sKey) {
                        return FilterChip(
                          backgroundColor: Colors.white,
                          checkmarkColor: Colors.green[800],
                          selectedColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                color: subCategoriesValues[sKey]
                                    ? Colors.green[800]
                                    : Colors.grey,
                                width: 0.5,
                              )),
                          labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: subCategoriesValues[sKey]
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: subCategoriesValues[sKey]
                                  ? Colors.green[800]
                                  : Colors.grey),
                          label: Text(sKey),
                          selected: subCategoriesValues[sKey],
                          onSelected: (val) {
                            if (sKey != "All") {
                              setState(() {
                                subCategoriesValues[sKey] = val;
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
                  //                 ? Colors.green[800]
                  //                 : Colors.grey,
                  //             width: 0.5,
                  //           )),
                  //       labelStyle: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: sortByRadioValue == sortByRadioMap[sKey]
                  //               ? FontWeight.w600
                  //               : FontWeight.normal,
                  //           color: sortByRadioValue == sortByRadioMap[sKey]
                  //               ? Colors.green[800]
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
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color:
                                  sortOrderRadioValue == sortOrderRadioMap[sKey]
                                      ? Colors.green[800]
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
                                    ? Colors.green[800]
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
        subCategories = null;
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
