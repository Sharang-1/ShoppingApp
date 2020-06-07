import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/widgets/custom_stepper.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/constants/route_names.dart';

// import 'package:compound/ui/shared/ui_helpers.dart';
// import 'package:compound/ui/widgets/custom_stepper.dart';
// import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_payment_method_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../../locator.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class PaymentMethod extends StatefulWidget {
  final String finalTotal;
  final String billingAddress;
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
  Map<int, String> paymentMethodMap = {
    1: "Cash on delivery",
    2: "Paytm",
    3: "PhonePe",
    4: "Google Pay - Tez"
  };
  int paymentMethodRadioValue = 1;
  int paymentMethodGrpValue = 1;
  final NavigationService _navigationService = locator<NavigationService>();

  Map<int, Widget> iconpaymentMethodMap = {
    1: Tab(icon: Image.asset("assets/images/cash_icon.png")),
    2: Tab(icon: Image.asset("assets/images/paytm_icon.png")),
    3: Tab(icon: Image.asset("assets/images/phonepe_icon.png")),
    4: Tab(icon: Image.asset("assets/images/gpay_icon.png")),
  };

  @override
  void initState() {
    print("Cart Payment");
    print("final totle " + widget.finalTotal);
    print("billing add " + widget.billingAddress);
    print("product id " + widget.productId);
    print("promo code " + widget.promoCode);
    print("promo id" + widget.promoCodeId);
    print("size " + widget.size);
    print("color " + widget.color);
    print("qty" + widget.qty.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CartPaymentMethodViewModel>.withConsumer(
      viewModel: CartPaymentMethodViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
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
          child: RaisedButton(
            elevation: 5,
            onPressed: () async {
              final res = await model.createOrder(
                widget.billingAddress,
                widget.productId,
                widget.promoCode,
                widget.promoCodeId,
                widget.size,
                widget.color,
                widget.qty,
                paymentMethodRadioValue,
              );

              if (res) {
                _navigationService
                    .navigateReplaceTo(PaymentFinishedScreenRoute);
              }
            },
            color: green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
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
                    children: paymentMethodMap.keys.map(
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
                                      paymentMethodMap[key],
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
