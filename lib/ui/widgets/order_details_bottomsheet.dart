import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_details.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

// ignore: must_be_immutable
class OrderDetailsBottomsheet extends StatelessWidget {
  OrderDetailsBottomsheet({
    required this.orderDetails,
    this.proceedToOrder,
    this.isPromocodeApplied = false,
    this.buttonText,
    this.buttonIcon,
    required this.onButtonPressed,
  }) {
    orderSummaryDetails = {
      "Product Name": orderDetails.productName?.capitalizeFirst ?? "",
      "Qty": orderDetails.qty ?? "",
      "Size": orderDetails.size ?? "",
      "Color": orderDetails.color ?? "",
      "Promo Code": orderDetails.promocode ?? "",
      "Promo Code Discount": orderDetails.promocodeDiscount ?? "",
      "Price": orderDetails.price ?? "",
      "Discount": orderDetails.discount ?? "",
      "Discounted Price": orderDetails.discountedPrice ?? "",
      "Convenience Charges": orderDetails.convenienceCharges ?? "",
      "GST": orderDetails.gst ?? "",
      "Delivery Charges": orderDetails.deliveryCharges ?? "",
      "Actual Price": orderDetails.actualPrice ?? "",
      "Saved": orderDetails.saved ?? "",
      "Total": orderDetails.total ?? "",
    };
  }

  final OrderDetails orderDetails;
  final Function? proceedToOrder;
  final String? buttonText;
  final IconData? buttonIcon;
  final Function onButtonPressed;
  final bool isPromocodeApplied;
  Map<String, String> orderSummaryDetails = {};

  static const orderSummaryDetails1 = [
    "Product Name",
    "Qty",
    "Size",
    "Color",
  ];
  static const orderSummaryDetails2 = [
    "Promo Code",
    "Promo Code Discount",
  ];
  static const orderSummaryDetails3 = [
    "Price",
    "Discount",
    "Discounted Price",
    "Convenience Charges",
    "GST",
    "Delivery Charges",
    "Total"
  ];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: MediaQuery.of(context).size.height > 600
          ? MediaQuery.of(context).size.height > 800
              ? 0.70
              : 0.80
          : 0.90,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: appBarIconColor),
          centerTitle: true,
          title: Text(
            "Details",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.clear_circled_solid),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              color: Colors.grey[700],
              iconSize: 30,
            ),
            horizontalSpaceSmall
          ],
          backgroundColor: Colors.grey[300],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 10),
            child: Column(
              children: <Widget>[
                Table(
                    children: orderSummaryDetails1
                        .map((String key) {
                          return <TableRow>[
                            TableRow(children: [
                              CustomText(
                                key,
                                color: Colors.grey,
                                fontSize: titleFontSize,
                              ),
                              CustomText(
                                orderSummaryDetails[key] ?? "",
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]!,
                              )
                            ]),
                            TableRow(children: [
                              verticalSpace(8),
                              verticalSpace(8),
                            ]),
                          ];
                        })
                        .expand((element) => element)
                        .toList()),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Divider(),
                ),
                if (isPromocodeApplied)
                  Table(
                      children: orderSummaryDetails2
                          .map((String key) {
                            return <TableRow>[
                              TableRow(children: [
                                CustomText(
                                  key,
                                  color: Colors.grey,
                                  fontSize: titleFontSize,
                                ),
                                CustomText(
                                  orderSummaryDetails[key] ?? "",
                                  fontSize: subtitleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]!,
                                )
                              ]),
                              TableRow(children: [
                                verticalSpace(8),
                                verticalSpace(8),
                              ]),
                            ];
                          })
                          .expand((element) => element)
                          .toList()),
                if (isPromocodeApplied)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Divider(),
                  ),
                Table(
                  children: orderSummaryDetails3
                      .map(
                        (String key) {
                          return key == "Total"
                              ? <TableRow>[
                                  TableRow(
                                    children: [
                                      verticalSpaceSmall,
                                      verticalSpaceSmall
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Divider(thickness: 1),
                                      Divider(thickness: 1),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpaceSmall,
                                      verticalSpaceSmall
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      CustomText(key,
                                          isBold: true,
                                          color: Colors.grey,
                                          fontSize: titleFontSize),
                                      CustomText(
                                        orderSummaryDetails[key] ?? "",
                                        fontSize: titleFontSize + 2,
                                        color: lightGreen,
                                        isBold: true,
                                      )
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpace(8),
                                      verticalSpace(8),
                                    ],
                                  ),
                                ]
                              : <TableRow>[
                                  TableRow(
                                    children: [
                                      CustomText(
                                        key,
                                        color: Colors.grey,
                                        fontSize: titleFontSize,
                                      ),
                                      CustomText(
                                        key == "Delivery Charges" &&
                                                orderSummaryDetails[key] ==
                                                    "0.0"
                                            ? "Free Delivery"
                                            : orderSummaryDetails[key]
                                                .toString(),
                                        fontSize: subtitleFontSize,
                                        color: key == "Delivery Charges"
                                            ? orderSummaryDetails[key] == "0.0"
                                                ? green
                                                : Colors.black
                                            : Colors.grey[600]!,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      verticalSpace(8),
                                      verticalSpace(8),
                                    ],
                                  ),
                                  if (key == "Discounted Price" &&
                                      isPromocodeApplied)
                                    TableRow(
                                      children: [
                                        CustomText(
                                          "Price After Promocode Applied",
                                          color: Colors.grey,
                                          fontSize: titleFontSize,
                                        ),
                                        CustomText(
                                          rupeeUnicode +
                                              (double.parse(orderDetails
                                                          .discountedPrice!
                                                          .replaceAll(
                                                              rupeeUnicode,
                                                              " ")) -
                                                      double.parse(
                                                        orderDetails
                                                            .promocodeDiscount!
                                                            .replaceAll(
                                                                "₹", ""),
                                                      ))
                                                  .toStringAsFixed(2),
                                          fontSize: subtitleFontSize,
                                          color: Colors.grey[600]!,
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  if (key == "Discounted Price" &&
                                      isPromocodeApplied)
                                    TableRow(
                                      children: [
                                        verticalSpace(8),
                                        verticalSpace(8),
                                      ],
                                    ),
                                ];
                        },
                      )
                      .expand((element) => element)
                      .toList(),
                ),
                if (proceedToOrder != null) verticalSpaceMedium,
                if (proceedToOrder != null)
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () =>
                              proceedToOrder!(
                                  qty: int.parse(orderDetails.qty ?? "0"),
                                  total: orderDetails.total) ??
                              () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              orderDetails.total! + "\t" + "Proceed to Order ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (buttonText != null) verticalSpaceMedium,
                if (buttonText != null)
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: onButtonPressed(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (buttonIcon != null)
                                  Icon(
                                    buttonIcon,
                                    size: 16,
                                  ),
                                if (buttonIcon != null) horizontalSpaceSmall,
                                Text(
                                  buttonText ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
