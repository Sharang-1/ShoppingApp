import 'package:flutter/material.dart';

import '../../controllers/product_controller.dart';
import '../../models/lookups.dart';
import '../../models/products.dart';

class ProductDescriptionTable extends StatelessWidget {
  const ProductDescriptionTable(
      {Key key,
      @required this.product,
      @required this.controller,
      this.workOnMap})
      : super(key: key);

  final ProductController controller;
  final Product product;
  final workOnMap;

  String getNameFromLookupId(Lookups section, String option, num id) {
    return section?.sections
            ?.where((element) =>
                element?.option?.toLowerCase() == option?.toLowerCase())
            ?.first
            ?.values
            ?.where((element) => element?.id == id)
            ?.first
            ?.name ??
        "No Lookup Found";
  }

  String getWorkOn(List<BlousePadding> workOn) {
    List<String> workOnStrings = [];
    workOn.forEach((e) => workOnStrings.add(workOnMap[e.id]));
    return workOnStrings.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getLookups(),
      builder: (c, AsyncSnapshot<List<Lookups>> s) {
        if (s.connectionState == ConnectionState.done) {
          if (s.error != null) {
            return Container(
              child: Text(
                s.error.toString(),
              ),
            );
          }

          var lookups = s.data;
          if (lookups == null) {
            return Container();
          }
          var productSection = lookups
              .where(
                  (element) => element.sectionName.toLowerCase() == "product")
              .first;
          if (productSection == null) {
            return Container();
          }
          return Table(
            children: [
              // divider
              if ((product?.art?.length ?? 0) > 0)
                getProductDetailsRow("Art", product.art),
              // divider,
              if (product?.fabricDetails != null &&
                  product?.fabricDetails != "")
                getProductDetailsRow(
                  "Fabric Feel",
                  product?.fabricDetails,
                ),
              // divider
              if ((product?.weaveType?.length ?? 0) > 0)
                getProductDetailsRow("Weave Type", product.weaveType),
              // divider,
              if (product?.pricePerMeter != null)
                getProductDetailsRow(
                    "Price Per Meter", product?.pricePerMeter?.toString()),
              // divider,
              if (product?.typeOfWork != null && product?.typeOfWork != "")
                getProductDetailsRow(
                  "Type Of Work",
                  product?.typeOfWork,
                ),
              // divider,
              if (product?.workOn != null && product?.workOn?.length != 0)
                getProductDetailsRow("Work on", getWorkOn(product?.workOn)),
              // divider,
              if (product?.pieces != null && product?.pieces?.id != -1)
                getProductDetailsRow(
                    "Pieces",
                    getNameFromLookupId(
                        productSection, "pieces", product?.pieces?.id)),
              // divider,
              if ((product?.whatDoesItHave != null) &&
                  (product?.whatDoesItHave?.id != -1) &&
                  (product?.category?.id == 9))
                getProductDetailsRow(
                  "what Does It Have",
                  ((product?.whatDoesItHave?.id == 1)
                      ? 'Sling'
                      : (product?.whatDoesItHave?.id == 2)
                          ? 'Handel'
                          : (product?.whatDoesItHave?.id == 3)
                              ? 'Bag-Pack Straps'
                              : ''),
                ),
              // divider,
              if (product?.stitchingType != null &&
                  product?.stitchingType?.id != -1)
                getProductDetailsRow(
                  "Stiching Type",
                  getNameFromLookupId(productSection, "stitchingType",
                      product?.stitchingType?.id),
                ),
              // divider,
              if (product?.style != null && product?.style != "")
                getProductDetailsRow(
                  "Style",
                  product?.style,
                ),
              // divider
              if ((product?.bottomStyle?.length ?? 0) > 0)
                getProductDetailsRow("Bottom Style", product.bottomStyle),
              // divider
              if ((product?.fittingType?.length ?? 0) > 0)
                getProductDetailsRow("Fitting Type", product.fittingType),
              // divider
              if ((product?.riseStyle?.length ?? 0) > 0)
                getProductDetailsRow("Rise Style", product.riseStyle),
              // divider,
              if (product?.flair != null)
                getProductDetailsRow("Flair", product?.flair?.toString()),
              // divider,
              if (product?.waist != null)
                getProductDetailsRow("Waist", product?.waist?.toString()),
              // divider,
              if (product?.heelHeight != null && product?.heelHeight != 0)
                getProductDetailsRow(
                  "Heel Height",
                  product?.heelHeight?.toString(),
                ),
              // divider,
              if (product?.length != null)
                getProductDetailsRow(
                  "Length",
                  product?.length?.toString(),
                ),
              // divider,
              if (product?.breadth != null && product?.breadth != 0)
                getProductDetailsRow(
                  "Breadth",
                  product?.breadth?.toString(),
                ),
              // divider,
              if (product?.sleeveLength != null &&
                  product?.sleeveLength?.id != -1)
                getProductDetailsRow(
                  "Sleeve Length",
                  getNameFromLookupId(productSection, "sleeveLength",
                      product?.sleeveLength?.id),
                ),
              // divider,
              if (product?.neck != null && product?.neck != "")
                getProductDetailsRow("Neck Type", product?.neck?.toString()),
              // divider,
              if (product?.neckCut != null && product?.neckCut != "")
                getProductDetailsRow(
                  "Neck Cut",
                  product?.neckCut,
                ),
              // divider,
              if (product?.backCut != null && product?.backCut != "")
                getProductDetailsRow(
                  "Back Type",
                  product?.backCut,
                ),
              // divider
              if ((product?.closureType?.length ?? 0) > 0)
                getProductDetailsRow("ClosureType", product.closureType),
              // divider,
              if ((product?.washing != null) && (product?.washing != ''))
                getProductDetailsRow("Washing", product?.washing?.toString()),
              // divider,
              if ((product?.occasionToWearIn != null) &&
                  (product?.occasionToWearIn != ''))
                getProductDetailsRow(
                  "Occasion To Wear In",
                  product?.occasionToWearIn?.toString(),
                ),
              // divider,
              if (product?.topsLength != null && product?.topsLength?.id != -1)
                getProductDetailsRow(
                  "Top's length",
                  getNameFromLookupId(
                    productSection,
                    "topsLength",
                    product?.topsLength?.id,
                  ),
                ),
              // divider,
              if (product?.typeOfSaree != null && product?.typeOfSaree != "")
                getProductDetailsRow("Type of Saree", product?.typeOfSaree),
              // divider,
              if (product?.made != null && product?.made?.id != -1)
                getProductDetailsRow(
                    "Made",
                    getNameFromLookupId(
                        productSection, "made", product?.made?.id)),
              if ((product?.hangings != null) && (product?.category?.id == 7))
                getProductDetailsRow(
                  "Hangings",
                  product.hangings ? "Yes" : "No",
                ),

              // divider,
              if ((product?.made != null) && (product?.made?.id != -1))
                getProductDetailsRow(
                  "Made",
                  product?.made?.id == 1 ? "Made on Demand" : "Ready Made",
                ),

              // divider,
              if ((product?.canCan != null) && (product?.category?.id == 14))
                getProductDetailsRow("Can Can", product.canCan ? "Yes" : "No"),

              // divider,
              if (product?.blousePadding != null &&
                  product?.blousePadding?.id != -1)
                getProductDetailsRow(
                  "Blouse Padding",
                  getNameFromLookupId(productSection, "blousePadding",
                      product?.blousePadding?.id),
                ),
              // divider,
              if (product?.dimensions != null && product?.dimensions != "")
                getProductDetailsRow(
                  "Dimensions",
                  product?.dimensions,
                ),

              if (product?.margin != null && product.margin)
                getProductDetailsRow("Margin", "Margin left in selai"),
            ],
          );
        }
        return Container();
      },
    );
  }

  TableRow getProductDetailsRow(productDetailsKey, productDetailsValue) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              productDetailsKey,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              productDetailsValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
