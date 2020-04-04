import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

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
  String sortByRadioValue = 'modified';
  String sortOrderRadioValue = 'asc';

  Map<String, int> categoriesRadioMap = {
    'Men': 2,
    'Women': 1,
    'Both': -1,
  };
  Map<String, String> sortByRadioMap = {
    'Latest Arrival': 'modified',
    'Price': 'price',
  };
  Map<String, String> sortOrderRadioMap = {
    'Ascending': 'asc',
    'Descending': 'desc',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Filter"),
        actions: <Widget>[
          IconButton(
            tooltip: "Reset",
            icon: Icon(Icons.restore),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "Apply",
            icon: Icon(Icons.done),
            onPressed: () {
              setUpFilterObject();
              print("Typing---------------------------------->>>>>>>>>>>>>>");
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              verticalSpaceSmall,
              Text(
                'Categories',
                style: TextStyle(fontSize: 16.0),
              ),
              verticalSpaceSmall,
              Wrap(
                children: categoriesRadioMap.keys.map((String sKey) {
                  return Row(
                    children: <Widget>[
                      Radio(
                        value: categoriesRadioMap[sKey],
                        groupValue: categoriesRadioValue,
                        onChanged: (val) {
                          setState(() => categoriesRadioValue = val);
                        },
                      ),
                      Text(
                        sKey,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  );
                }).toList(),
              ),
              verticalSpaceSmall,
              Text(
                'Sub Categories',
                style: TextStyle(fontSize: 16.0),
              ),
              verticalSpaceSmall,
              Wrap(
                children: subCategoriesValues.keys.map(
                  (String sKey) {
                    return CheckboxListTile(
                      title: Text(sKey),
                      value: subCategoriesValues[sKey],
                      onChanged: (val) {
                        if (sKey != "All") {
                          setState(() => subCategoriesValues[sKey] = val);
                          return;
                        }
                        setState(() => subCategoriesValues[sKey] = val);
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
              verticalSpaceSmall,
              Text(
                'Price Range (Rs. $minPrice - Rs. $maxPrice)',
                style: TextStyle(fontSize: 16.0),
              ),
              verticalSpaceSmall,
              Row(
                children: <Widget>[
                  horizontalSpaceTiny,
                  Text("0"),
                  horizontalSpaceTiny,
                  Expanded(
                    child: RangeSlider(
                      min: 0,
                      max: 50000,
                      divisions: 100,
                      labels:
                          RangeLabels(minPrice.toString(), maxPrice.toString()),
                      values:
                          RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
                      onChanged: (val) {
                        setState(() {
                          minPrice = val.start.toInt();
                          maxPrice = val.end.toInt();
                        });
                      },
                    ),
                  ),
                  horizontalSpaceTiny,
                  Text("50,000"),
                  horizontalSpaceTiny,
                ],
              ),
              verticalSpaceSmall,
              Text(
                'Discount ($minDiscount %)',
                style: TextStyle(fontSize: 16.0),
              ),
              verticalSpaceSmall,
              Row(
                children: <Widget>[
                  horizontalSpaceTiny,
                  Text("0"),
                  horizontalSpaceTiny,
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 100,
                      divisions: 20,
                      label: minDiscount.toString(),
                      value: minDiscount.toDouble(),
                      onChanged: (val) {
                        setState(() {
                          minDiscount = val.toInt();
                        });
                      },
                    ),
                  ),
                  horizontalSpaceTiny,
                  Text("100"),
                  horizontalSpaceTiny,
                ],
              ),
              verticalSpaceSmall,
              Text(
                'Sort By',
                style: TextStyle(fontSize: 16.0),
              ),
              verticalSpaceSmall,
              Wrap(
                children: sortByRadioMap.keys.map((String sKey) {
                  return Row(
                    children: <Widget>[
                      Radio(
                        value: sortByRadioMap[sKey],
                        groupValue: sortByRadioValue,
                        onChanged: (val) {
                          setState(() => sortByRadioValue = val);
                        },
                      ),
                      Text(
                        sKey,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  );
                }).toList(),
              ),
              verticalSpaceSmall,
              Text(
                'Sort Order',
                style: TextStyle(fontSize: 16.0),
              ),
              verticalSpaceSmall,
              Wrap(
                children: sortOrderRadioMap.keys.map((String sKey) {
                  return Row(
                    children: <Widget>[
                      Radio(
                        value: sortOrderRadioMap[sKey],
                        groupValue: sortOrderRadioValue,
                        onChanged: (val) {
                          setState(() => sortOrderRadioValue = val);
                        },
                      ),
                      Text(
                        sKey,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  );
                }).toList(),
              ),
              verticalSpaceMedium,
            ],
          ),
        ),
      ),
    );
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
