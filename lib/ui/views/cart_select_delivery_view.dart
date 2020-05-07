import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:compound/ui/views/cart_payment_method_view.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SelectAddress extends StatefulWidget {
  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  Map<int, String> addressMap = {0: "Home", 1: "Work", 2: "Dzor"};
  int addressRadioValue;
  int addressGrpValue = -1;

  Map<int, Widget> iconAddressMap = {
    0: Icon(
      Icons.home,
    ),
    1: Icon(
      Icons.work,
    )
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Delivery Address",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentMethod()));
            },
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              // side: BorderSide(
              //     color: Colors.black, width: 0.5)
            ),
            child: Text(
              "Continue ",
              style: TextStyle(color: Colors.white),
            )),
        // )
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressInputPage()));
                },
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add_location),
                        onPressed: () {},
                      ),
                      CustomText("Add New Delivery Address"),
                      horizontalSpaceTiny
                    ],
                  ),
                )),
            verticalSpaceMedium,
            Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: addressMap.keys.map((int key) {
                    return key < 2
                        ? Card(
                            child: Row(
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
                                iconAddressMap[key],
                                horizontalSpaceTiny,
                                Column(
                                  children: <Widget>[
                                    CustomText(
                                      "Send To",
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    CustomText(
                                      addressMap[key],
                                      isBold: true,
                                    )
                                  ],
                                ),
                                Spacer(),
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
                          )
                        : SizedBox(
                            height: 100,
                            child: Card(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CustomText(
                                        addressMap[key],
                                        isBold: true,
                                      ),
                                      verticalSpaceTiny_0,
                                      CustomText(
                                        "Sarkhej - Gandhinagar Hwy, Bodakdev, Ahmedabad, Gujarat 380059",
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
