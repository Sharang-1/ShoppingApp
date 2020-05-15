import 'package:compound/constants/route_names.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:compound/ui/widgets/custom_stepper.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../locator.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  Map<int, String> paymentMethodMap = {
    0: "PayTM",
    1: "PhonePe",
    2: "Cash",
    3: "Google Pay"
  };
  int paymentMethodRadioValue;
  int paymentMethodGrpValue = -1;
  final NavigationService _navigationService = locator<NavigationService>();

  Map<int, Widget> iconpaymentMethodMap = {
    0: Tab(icon: Image.asset("assets/images/paytm_icon.png")),
    1: Tab(icon: Image.asset("assets/images/phonepe_icon.png")),
    2: Tab(icon: Image.asset("assets/images/cash_icon.png")),
    3: Tab(
        icon: Image.asset(
      "assets/images/gpay_icon.png",
    )),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        iconTheme: IconThemeData(color: appBarIconColor),
      ),
      bottomNavigationBar:
          //  Material(
          //     elevation: 15,
          //     color: Colors.white,
          //     shape: RoundedRectangleBorder(side: BorderSide(width: 0.05)),
          //     child:

          Padding(
        padding: EdgeInsets.only(left: screenPadding, right: screenPadding, bottom: 10),
        child: RaisedButton(
            elevation: 5,
            onPressed: () {
              _navigationService.navigateReplaceTo(PaymentFinishedScreenRoute);
              print(paymentMethodRadioValue.toString() +
                  paymentMethodMap[paymentMethodRadioValue]);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => PaymentMethod()));
            },
            color: green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              // side: BorderSide(
              //     color: Colors.black, width: 0.5)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Place Order ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )),
        // )
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.only(left: screenPadding, right: screenPadding, top: 10, bottom: 10),
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
                          fontSize: 30,
                          fontFamily: headingFont,
                          fontWeight: FontWeight.w700,
                        ),
                        horizontalSpaceSmall,
                        Icon(Icons.lock_outline)
                      ],
                    ),
                    verticalSpaceSmall,
                    CustomText(
                      rupeeUnicode + "100",
                      fontSize: 24,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )),
            verticalSpaceSmall,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: paymentMethodMap.keys.map((int key) {
                return Container(
                  margin: EdgeInsets.only(bottom: spaceBetweenCards),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(curve15),
                      // side: BorderSide(
                      //     color: Colors.black, width: 0.5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                      child: Row(
                        children: <Widget>[
                          Radio(
                            value: key,
                            groupValue: paymentMethodGrpValue,
                            onChanged: (val) {
                              setState(() {
                                paymentMethodRadioValue = val;
                              });
                              print(val);
                            },
                          ),
                          CustomText(
                            paymentMethodMap[key],
                            isBold: true,
                            color: Colors.grey[700],
                          ),
                          Spacer(),
                          iconpaymentMethodMap[key],
                          horizontalSpaceTiny
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ))),
    );
  }
}
