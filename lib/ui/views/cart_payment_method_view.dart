import 'dart:developer';

import 'package:compound/app/app.dart';
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
        paymentTotal = res.cost ?? 0;
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
                    onPressed: controller.busy ? null : () async => await makePayment(controller, paymentMethodGrpValue),
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
                                fontSize: titleFontSizeStyle,
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
    } else if (paymentMethodGrpValue != 2) {
      _errorHandlingService.showError(Errors.CouldNotPlaceAnOrder);
      NavigationService.offAll(HomeViewRoute);
    }
  }
}
