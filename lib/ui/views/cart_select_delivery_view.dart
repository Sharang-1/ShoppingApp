import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:compound/ui/views/cart_payment_method_view.dart';
import 'package:compound/ui/widgets/custom_stepper.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  Map<int, String> addressMap = {0: "Address 1", 1: "Address 2", 2: "Dzor"};
  Map<int, String> fullAddressMap = {
    0: "103 /, First Floor, Royal Bldg, Janjikar Street, Masjid Bunder (w), Mumbai, Maharashtra-400003",
    1: "Shivranjani Cross Roads, Satellite,Ahmedabad, Gujarat 380015",
    2: "Sarkhej - Gandhinagar Hwy, Bodakdev, Ahmedabad, Gujarat 380059"
  };
  int addressRadioValue;
  int addressGrpValue = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhiteCreamColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundWhiteCreamColor,
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo_red.png",
          height: 35,
          width: 35,
        ),
        iconTheme: IconThemeData(
          color: textIconBlue,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentMethod()));
            },
            color: Colors.green[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              // side: BorderSide(
              //     color: Colors.black, width: 0.5)
            ),
            child: Text(
              "Proceed To Payment ",
              style: TextStyle(color: Colors.white),
            )),
        // )
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            verticalSpace(20),
            Text(
              "Select Delivery",
              style: TextStyle(
                  fontFamily: headingFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 30),
            ),
            Text(
              "Address",
              style: TextStyle(
                  fontFamily: headingFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 30),
            ),
            verticalSpace(10),
            const CutomStepper(
              step: 2,
            ),
            verticalSpace(20),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressInputPage()));
                },
                color: darkRedSmooth,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  // side: BorderSide(
                  //     color: Colors.black, width: 0.5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    horizontalSpaceSmall,
                    CustomText(
                      "Add Address",
                      color: Colors.white,
                    ),
                  ],
                )),
            verticalSpaceMedium,
            Text(
              "Previously Added Addresses",
              style: TextStyle(
                  fontFamily: headingFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            verticalSpace(10),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: addressMap.keys.map((int key) {
                    return SizedBox(
                        height: 100,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                value: key,
                                groupValue: addressGrpValue,
                                onChanged: (val) {
                                  setState(() {
                                    addressRadioValue = val;
                                  });
                                  print(val);
                                },
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CustomText(
                                    addressMap[key],
                                    isBold: true,
                                  ),
                                  verticalSpaceTiny_0,
                                  CustomText(
                                    fullAddressMap[key],
                                    fontSize: 14,
                                  )
                                ],
                              )),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddressInputPage()));
                                },
                              )
                            ],
                          ),
                        ));
                  }).toList(),
                ))
          ],
        ),
      ))),
    );
  }
}
