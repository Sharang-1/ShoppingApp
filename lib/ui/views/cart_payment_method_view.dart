import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Billing & Payment",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar:
          //  Material(
          //     elevation: 15,
          //     color: Colors.white,
          //     shape: RoundedRectangleBorder(side: BorderSide(width: 0.05)),
          //     child:

          Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: RaisedButton(
            onPressed: () {
              print(paymentMethodRadioValue.toString() +
                  paymentMethodMap[paymentMethodRadioValue]);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => PaymentMethod()));
            },
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              // side: BorderSide(
              //     color: Colors.black, width: 0.5)
            ),
            child: Text(
              "Place Order ",
              style: TextStyle(color: Colors.white),
            )),
        // )
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            verticalSpaceTiny,
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CustomText(
                              "Payment",
                              fontSize: 24,
                              fontFamily: "RaleWay",
                            ),
                            horizontalSpaceTiny,
                            Icon(Icons.lock_outline)
                          ],
                        ),
                        CustomText(
                          rupeeUnicode + "100",
                          fontSize: 24,
                          fontFamily: "RaleWay",
                          isBold: true,
                        ),
                        verticalSpaceSmall,
                        CustomText(
                          "Select a Payment Method",
                          fontSize: 20,
                        ),
                      ],
                    ))),
            verticalSpaceMedium,
            Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: paymentMethodMap.keys.map((int key) {
                    return Card(
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
                          ),
                          Spacer(),
                          iconpaymentMethodMap[key],
                          horizontalSpaceTiny
                        ],
                      ),
                    );
                  }).toList(),
                ))
          ],
        ),
      ))),
    );
  }
}
