import 'dart:developer';

import 'package:compound/app/app.dart';
import 'package:compound/models/groupOrderCostEstimateModel.dart';
import 'package:compound/models/orderV2.dart';
import 'package:compound/models/orderV2_response.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/utils/lang/translation_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/groupOrderData.dart';
import '../../constants/route_names.dart';
import '../../controllers/cart_payment_method_controller.dart';
import '../../locator.dart';
import '../../services/error_handling_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';

class PaymentMethod extends StatefulWidget {
  final List<dynamic> products;

  final CustomerDetails customerDetails;
  final double? finalTotal;
  // final UserDetailsContact billingAddress;
  // final String productId;
  // final String promoCode;
  // final String? promoCodeId;
  // final String? size;
  // final String? color;
  // final int? qty;
  // final OrderDetails orderDetails;

  const PaymentMethod({
    Key? key,
    required this.customerDetails,
    required this.products,
    // required this.productId,
    // this.promoCode = "",
    // this.promoCodeId = "",
    // this.size,
    // this.color,
    // this.qty,
    // required this.billingAddress,
    required this.finalTotal,
    // required this.orderDetails,
  }) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  int paymentMethodRadioValue = 2;
  int paymentMethodGrpValue = 2;
  double paymentTotal = 0;
  CostEstimateModel? estimatedCost;
  bool isLoading = true;
  final ErrorHandlingService _errorHandlingService = locator<ErrorHandlingService>();

  Map<int, Widget> iconpaymentMethodMap = {
    1: Tab(icon: Image.asset("assets/images/cash_icon.png")),
    2: Tab(icon: Image.asset("assets/images/online_payment.png")),
  };

  @override
  void initState() {
    getOrderCostEstimate(2);
    super.initState();
  }

  Future getOrderCostEstimate(int paymentOption) async {
    var res = await APIService().getOrderCostEstimate(
      // payment: ,
      paymentOption: paymentOption,
      products: GroupOrderData.cartEstimateItems,
      customerDetails: widget.customerDetails,
    );

    if (res != null) {
      setState(() {
        estimatedCost = res;
        paymentTotal = res.cost ?? 0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.customerDetails.address != null) {
    //   setState(() {
    //     paymentMethodRadioValue = 2;
    //     paymentMethodGrpValue = 2;
    //   });
    // }
    return GetBuilder<CartPaymentMethodController>(
      init: CartPaymentMethodController(city: widget.customerDetails.city ?? ""),
      builder: (controller) => Scaffold(
        backgroundColor: newBackgroundColor2,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            PAYMENT.tr,
            style: TextStyle(
              fontFamily: headingFont,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: appBarIconColor,
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            left: screenPadding,
            right: screenPadding,
            bottom: MediaQuery.of(context).padding.bottom + 4.0,
            top: 8.0,
          ),
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    {
                      // showModalBottomSheet<void>(
                      //   clipBehavior: Clip.antiAlias,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(10),
                      //       topRight: Radius.circular(10),
                      //     ),
                      //   ),
                      //   isScrollControlled: true,
                      //   context: context,
                      //   builder: (context) => OrderDetailsBottomsheet(
                      //     orderDetails: widget.orderDetails,
                      //     buttonText:
                      //         paymentMethodGrpValue == 2 ? PROCEED_TO_PAY.tr : PLACE_ORDER.tr,
                      //     onButtonPressed: controller.busy
                      //         ? () {}
                      //         : () async {
                      //             NavigationService.back();
                      //             await makePayment(controller);
                      //           },
                      //     isPromocodeApplied: widget.promoCode.isNotEmpty,
                      //   ),
                      // );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        rupeeUnicode + paymentTotal.toStringAsFixed(2),
                        fontSize: 18,
                        isBold: true,
                        color: logoRed,
                      ),
                      // CustomText(
                      //   VIEW_DETAILS.tr,
                      //   textStyle: TextStyle(
                      //     fontSize: 12,
                      //     decoration: TextDecoration.underline,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                horizontalSpaceMedium,
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.busy
                        ? null
                        : () async => await makePayment(controller, paymentMethodGrpValue),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          paymentMethodGrpValue == 2 ? PROCEED_TO_PAY.tr : PLACE_ORDER.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: controller.busy
              ? Center(
                  child: Image.asset(
                    "assets/images/loading_img.gif",
                    height: 50,
                    width: 50,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenPadding,
                      right: screenPadding,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        verticalSpaceTiny,
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              verticalSpace(10),
                              const CutomStepper(
                                step: 3,
                              ),
                              verticalSpace(20),
                              CustomText(
                                "  Payment Method",
                                fontSize: titleFontSize + 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: controller.paymentOptions.keys.map(
                              (int key) {
                                return GestureDetector(
                                  onTap: () {
                                    print(controller.paymentOptions);
                                    setState(() {
                                      paymentMethodGrpValue = paymentMethodRadioValue = key;
                                      getOrderCostEstimate(paymentMethodGrpValue);
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: spaceBetweenCards),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(curve15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                        child: Row(
                                          children: <Widget>[
                                            Radio(
                                              value: key,
                                              groupValue: paymentMethodGrpValue,
                                              onChanged: (val) {
                                                print(val);
                                                paymentMethodGrpValue =
                                                    paymentMethodRadioValue = key;
                                                getOrderCostEstimate(paymentMethodGrpValue);

                                                setState(() {});
                                              },
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    controller.paymentOptions[key] ?? "",
                                                    fontSize: titleFontSizeStyle,
                                                    isBold: true,
                                                    color: Colors.grey[700]!,
                                                  ),
                                                  if (key == 1) verticalSpaceTiny,
                                                  if (key == 1)
                                                    CustomText(
                                                      "No Cash Accepted",
                                                      fontSize: titleFontSize - 4,
                                                    ),
                                                  if (key == 1)
                                                    CustomText(
                                                      "+ $rupeeUnicode 50",
                                                      fontSize: titleFontSize,
                                                      color: Colors.green,
                                                      isBold: true,
                                                    ),
                                                  if (key == 2) verticalSpaceTiny,
                                                  if (key == 2)
                                                    CustomText(
                                                      "Debit Card, Credit Card, UPI, \nNetBanking",
                                                      fontSize: titleFontSize - 4,
                                                    )
                                                ],
                                              ),
                                            ),
                                            iconpaymentMethodMap[key]!,
                                            horizontalSpaceTiny,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        if (!isLoading)
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(
                                "Order Costs",
                                style: TextStyle(
                                  fontSize: titleFontSize + 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if ((estimatedCost?.orderCosts?.length ?? 0) > 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Item 1 Cost",
                                      style: TextStyle(
                                        fontSize: titleFontSize + 2,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Product Price : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[0].productPrice ?? 0}"),
                                      ],
                                    ),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Quantity : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[0].quantity ?? 0}"),
                                      ],
                                    ),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Discount : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[0].productDiscount?.cost ?? 0}",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("GST Charges : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[0].gstCharges?.cost ?? 0}",
                                          // style: TextStyle(
                                          //   color: logoRed,
                                          //   fontWeight: FontWeight.bold,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[0].cost ?? 0}",
                                          style: TextStyle(
                                            color: logoRed,
                                            fontSize: titleFontSize + 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  
                                  ],
                                ),
                              if ((estimatedCost?.orderCosts?.length ?? 0) > 1)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Item 2 Cost",
                                      style: TextStyle(
                                        fontSize: titleFontSize + 2,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Product Price : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[1].productPrice ?? 1}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Quantity : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[1].quantity ?? 1}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Discount : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[1].productDiscount?.cost ?? 1}",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("GST Charges : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[1].gstCharges?.cost ?? 1}",
                                          // style: TextStyle(
                                          //   color: logoRed,
                                          //   fontWeight: FontWeight.bold,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[1].cost ?? 1}",
                                          style: TextStyle(
                                            color: logoRed,
                                            fontSize: titleFontSize + 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              if ((estimatedCost?.orderCosts?.length ?? 0) > 2)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Item 3 Cost",
                                      style: TextStyle(
                                        fontSize: titleFontSize + 2,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Product Price : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[2].productPrice ?? 2}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Quantity : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[2].quantity ?? 2}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Discount : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[2].productDiscount?.cost ?? 2}",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("GST Charges : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[2].gstCharges?.cost ?? 2}",
                                          // style: TextStyle(
                                          //   color: logoRed,
                                          //   fontWeight: FontWeight.bold,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[2].cost ?? 2}",
                                          style: TextStyle(
                                            color: logoRed,
                                            fontSize: titleFontSize + 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              if ((estimatedCost?.orderCosts?.length ?? 0) > 3)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Item 4 Cost",
                                      style: TextStyle(
                                        fontSize: titleFontSize + 2,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Product Price : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[3].productPrice ?? 3}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Quantity : "),
                                        Text(
                                            "$rupeeUnicode${estimatedCost?.orderCosts?[3].quantity ?? 3}"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Discount : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[3].productDiscount?.cost ?? 3}",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("GST Charges : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[3].gstCharges?.cost ?? 3}",
                                          // style: TextStyle(
                                          //   color: logoRed,
                                          //   fontWeight: FontWeight.bold,
                                          // ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total : "),
                                        Text(
                                          "$rupeeUnicode${estimatedCost?.orderCosts?[3].cost ?? 3}",
                                          style: TextStyle(
                                            color: logoRed,
                                            fontSize: titleFontSize + 2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Convenience Charge : ",
                                    style: TextStyle(
                                      fontSize: titleFontSize + 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      "$rupeeUnicode${estimatedCost?.convenienceCharges?.cost ?? 0}")
                                ],
                              ),
                              Text(
                                "Seller Delivery Charge",
                                style: TextStyle(
                                  fontSize: titleFontSize + 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (estimatedCost!.deliveryChargesList!.length > 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Seller 1 Delivery Charge : "),
                                    Text(
                                        "$rupeeUnicode${estimatedCost?.deliveryChargesList?[0].cost.toString() ?? 0}")
                                  ],
                                ),
                              if (estimatedCost!.deliveryChargesList!.length > 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Seller 2 Delivery Charge : "),
                                    Text(
                                        "$rupeeUnicode${estimatedCost?.deliveryChargesList?[1].cost.toString() ?? 0}")
                                  ],
                                ),
                              if (estimatedCost!.deliveryChargesList!.length > 2)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Seller 3 Delivery Charge : "),
                                    Text(
                                        "$rupeeUnicode${estimatedCost?.deliveryChargesList?[2].cost.toString() ?? 0}")
                                  ],
                                ),
                              if (estimatedCost!.deliveryChargesList!.length > 2)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Seller 4 Delivery Charge : "),
                                    Text(
                                        "$rupeeUnicode${estimatedCost?.deliveryChargesList?[3].cost.toString() ?? 0}")
                                  ],
                                ),
                              if (paymentMethodGrpValue == 1)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Pay on Delivery Charge",
                                    style: TextStyle(
                                        fontSize: titleFontSize + 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        "$rupeeUnicode 50")
                                  ],
                                ),
                            ]),
                          )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> makePayment(controller, paymentOption) async {
    appVar.previousOrders = (await locator<APIService>().getAllOrders())!.orders!;
    final GroupOrderResponseModel res = await controller.createGroupOrder(
        widget.finalTotal, widget.customerDetails, widget.products, paymentOption);

    if (kDebugMode) print("res = $res");
    if (res != null) {
      NavigationService.off(PaymentFinishedScreenRoute);
      // GroupOrderData.cartProducts.clear();
      // GroupOrderData.sellersList.clear();
      // GroupOrderData.cartEstimateItems.clear();
    } else if (paymentMethodGrpValue != 2) {
      _errorHandlingService.showError(Errors.CouldNotPlaceAnOrder);
      NavigationService.offAll(HomeViewRoute);
    }
  }
}
