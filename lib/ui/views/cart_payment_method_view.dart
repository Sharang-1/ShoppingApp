import 'package:compound/utils/lang/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_payment_method_controller.dart';
import '../../locator.dart';
import '../../models/order.dart';
import '../../models/order_details.dart';
import '../../models/user_details.dart';
import '../../services/error_handling_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';
import '../widgets/order_details_bottomsheet.dart';

class PaymentMethod extends StatefulWidget {
  final String finalTotal;
  final UserDetailsContact billingAddress;
  final String productId;
  final String promoCode;
  final String? promoCodeId;
  final String? size;
  final String? color;
  final int? qty;
  final OrderDetails orderDetails;

  const PaymentMethod({
    Key? key,
    required this.productId,
    this.promoCode = "",
    this.promoCodeId = "",
    this.size,
    this.color,
    this.qty,
    required this.billingAddress,
    required this.finalTotal,
    required this.orderDetails,
  }) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  int paymentMethodRadioValue = 2;
  int paymentMethodGrpValue = 2;
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  Map<int, Widget> iconpaymentMethodMap = {
    1: Tab(icon: Image.asset("assets/images/cash_icon.png")),
    2: Tab(icon: Image.asset("assets/images/online_payment.png")),
  };

  @override
  void initState() {
    print("Cart Payment");
    print("final totle " + widget.finalTotal);
    print("billing add " +
        widget.billingAddress.address! +
        '\n' +
        widget.billingAddress.googleAddress!);
    print("product id " + widget.productId);
    print("promo code " + widget.promoCode);
    print("promo id" + widget.promoCodeId!);
    print("size " + widget.size!);
    print("color " + widget.color!);
    print("qty" + widget.qty.toString());
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) async {
    //     await DialogService.showDialog(
    //       title: CART_ALERT_DIALOG_TITLE.tr,
    //       description: CART_ALERT_DIALOG_DESCRIPTION.tr,
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.billingAddress.city != null) {
    //   setState(() {
    //     paymentMethodRadioValue = 2;
    //     paymentMethodGrpValue = 2;
    //   });
    // }
    return GetBuilder<CartPaymentMethodController>(
      init: CartPaymentMethodController(city: widget.billingAddress.city ?? ""),
      builder: (controller) => Scaffold(
        backgroundColor: newBackgroundColor,
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
                      showModalBottomSheet<void>(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => OrderDetailsBottomsheet(
                          orderDetails: widget.orderDetails,
                          buttonText: paymentMethodGrpValue == 2
                              ? PROCEED_TO_PAY.tr
                              : PLACE_ORDER.tr,
                          onButtonPressed: controller.busy
                              ? () {}
                              : () async {
                                  NavigationService.back();
                                  await makePayment(controller);
                                },
                          isPromocodeApplied: widget.promoCode.isNotEmpty,
                        ),
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        "${BaseController.formatPrice(num.parse(widget.finalTotal.replaceAll("₹", "")))}",
                        fontSize: 12,
                        isBold: true,
                      ),
                      CustomText(
                        VIEW_DETAILS.tr,
                        textStyle: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
                        : () async => await makePayment(controller),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          paymentMethodGrpValue == 2
                              ? PROCEED_TO_PAY.tr
                              : PLACE_ORDER.tr,
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
                                      paymentMethodGrpValue =
                                          paymentMethodRadioValue = key;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: spaceBetweenCards),
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
                                        borderRadius:
                                            BorderRadius.circular(curve15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Row(
                                          children: <Widget>[
                                            Radio(
                                              value: key,
                                              groupValue: paymentMethodGrpValue,
                                              onChanged: (val) {
                                                print(val);
                                                paymentMethodGrpValue =
                                                    paymentMethodRadioValue = key;
                                                setState(() {});
                                              },
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    controller.paymentOptions[
                                                            key] ??
                                                        "",
                                                    fontSize:
                                                        titleFontSizeStyle,
                                                    isBold: true,
                                                    color: Colors.grey[700]!,
                                                  ),
                                                  if (key == 1)
                                                    verticalSpaceTiny,
                                                  if (key == 1)
                                                    CustomText(
                                                      "No Cash Accepted",
                                                      fontSize:
                                                      titleFontSize - 4,
                                                    ),

                                                  if (key == 2)
                                                    verticalSpaceTiny,
                                                  if (key == 2)
                                                    CustomText(
                                                      "Debit Card, Credit Card, UPI, \nNetBanking",
                                                      fontSize:
                                                          titleFontSize - 4,
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

  Future<void> makePayment(controller) async {
    final Order res = await controller.createOrder(
        widget.billingAddress.address! +
            '\n' +
            widget.billingAddress.googleAddress!,
        widget.productId,
        widget.promoCode,
        widget.promoCodeId,
        widget.size,
        widget.color,
        widget.qty,
        paymentMethodRadioValue,
        widget.billingAddress.pincode);

    if (res != null) {
      NavigationService.off(PaymentFinishedScreenRoute);
    } else if (paymentMethodGrpValue != 2) {
      _errorHandlingService.showError(Errors.CouldNotPlaceAnOrder);
      NavigationService.offAll(HomeViewRoute);
    }
  }
}
