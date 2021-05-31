// import 'package:compound/ui/views/pay_through_card.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/route_names.dart';
import '../../controllers/cart_payment_method_controller.dart';
import '../../locator.dart';
import '../../models/order.dart';
import '../../models/user_details.dart';
import '../../services/error_handling_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';

class PaymentMethod extends StatefulWidget {
  final String finalTotal;
  final UserDetailsContact billingAddress;
  final String productId;
  final String promoCode;
  final String promoCodeId;
  final String size;
  final String color;
  final int qty;

  const PaymentMethod({
    Key key,
    this.productId,
    this.promoCode,
    this.promoCodeId,
    this.size,
    this.color,
    this.qty,
    this.billingAddress,
    this.finalTotal,
  }) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  int paymentMethodRadioValue = 1;
  int paymentMethodGrpValue = 1;
  final NavigationService _navigationService = locator<NavigationService>();
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
        widget.billingAddress.address +
        '\n' +
        widget.billingAddress.googleAddress);
    print("product id " + widget.productId);
    print("promo code " + widget.promoCode);
    print("promo id" + widget.promoCodeId);
    print("size " + widget.size);
    print("color " + widget.color);
    print("qty" + widget.qty.toString());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await DialogService.showDialog(
          title: 'Check Size, Color and Quantity',
          description:
              'Designers on Dzor work hard to create garments and items for you. Please make sure you’re making an informed buying decision so that we don’t have to return or cancel the order.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartPaymentMethodController>(
      init: CartPaymentMethodController(),
      builder: (controller) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundWhiteCreamColor,
          centerTitle: true,
          title: SvgPicture.asset(
            "assets/svg/logo.svg",
            color: logoRed,
            height: 35,
            width: 35,
          ),
          iconTheme: IconThemeData(
            color: appBarIconColor,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: screenPadding,
            right: screenPadding,
            bottom: 10,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              primary: green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              final Order res = await controller.createOrder(
                widget.billingAddress.address +
                    '\n' +
                    widget.billingAddress.googleAddress,
                widget.productId,
                widget.promoCode,
                widget.promoCodeId,
                widget.size,
                widget.color,
                widget.qty,
                paymentMethodRadioValue,
              );

              if (res != null) {
                _navigationService
                    .navigateReplaceTo(PaymentFinishedScreenRoute);
              } else {
                _navigationService.navigateAndRemoveUntil(HomeViewRoute);
                _errorHandlingService.showError(Errors.CouldNotPlaceAnOrder);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Place Order ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                        Row(
                          children: <Widget>[
                            CustomText(
                              "Payment",
                              fontSize: headingFontSizeStyle + 5,
                              fontFamily: headingFont,
                              fontWeight: FontWeight.w700,
                            ),
                            horizontalSpaceSmall,
                            Icon(Icons.lock_outline),
                          ],
                        ),
                        verticalSpaceSmall,
                        CustomText(
                          rupeeUnicode + widget.finalTotal,
                          fontSize: titleFontSizeStyle + 4,
                          color: darkRedSmooth,
                          fontFamily: "RaleWay",
                          isBold: true,
                        ),
                        verticalSpaceSmall,
                        const CutomStepper(
                          step: 3,
                        ),
                        verticalSpace(20),
                        verticalSpaceSmall,
                        CustomText(
                          "  Pay On Delivery Via",
                          fontSize: titleFontSizeStyle,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.paymentOptions.keys.map(
                      (int key) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              paymentMethodGrpValue =
                                  paymentMethodRadioValue = key;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: spaceBetweenCards),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(curve15),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                child: Row(
                                  children: <Widget>[
                                    Radio(
                                      value: key,
                                      groupValue: paymentMethodGrpValue,
                                      onChanged: (val) {
                                        // setState(() {
                                        //   paymentMethodRadioValue = val;
                                        // });
                                        print(val);
                                      },
                                    ),
                                    CustomText(
                                      controller.paymentOptions[key],
                                      fontSize: titleFontSizeStyle - 4,
                                      isBold: true,
                                      color: Colors.grey[700],
                                    ),
                                    Spacer(),
                                    iconpaymentMethodMap[key],
                                    horizontalSpaceTiny,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
