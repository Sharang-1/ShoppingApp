import 'package:compound/models/user_details.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/address_input_form_view.dart';
import 'package:compound/ui/views/cart_payment_method_view.dart';
import 'package:compound/ui/widgets/custom_stepper.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/cart_select_delivery_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class SelectAddress extends StatefulWidget {
  final String finalTotal;
  final String productId;
  final String promoCode;
  final String promoCodeId;
  final String size;
  final String color;
  final int qty;

  const SelectAddress({
    Key key,
    @required this.productId,
    @required this.promoCode,
    @required this.promoCodeId,
    @required this.size,
    @required this.color,
    @required this.qty,
    @required this.finalTotal,
  }) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  UserDetailsContact addressRadioValue;
  UserDetailsContact addressGrpValue;
  bool disabledPayment = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CartSelectDeliveryViewModel>.withConsumer(
      viewModel: CartSelectDeliveryViewModel(),
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
            top: 0,
          ),
          child: RaisedButton(
            elevation: 5,
            onPressed: disabledPayment
                ? null
                : () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: PaymentMethod(
                            billingAddress: (addressRadioValue == null
                                ? model.addresses[0]
                                : addressRadioValue),
                            color: widget.color,
                            productId: widget.productId,
                            promoCode: widget.promoCode,
                            promoCodeId: widget.promoCodeId,
                            qty: widget.qty,
                            size: widget.size,
                            finalTotal: widget.finalTotal,
                          ),
                          type: PageTransitionType.rightToLeft),
                    );
                  },
            color: green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(curve30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Proceed To Payment ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpace(20),
                  Text(
                    "Select Delivery",
                    style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                  Text(
                    "Address",
                    style: TextStyle(
                        fontFamily: headingFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                  verticalSpace(20),
                  const CutomStepper(
                    step: 2,
                  ),
                  verticalSpace(20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: RaisedButton(
                        elevation: 5,
                        onPressed: () async {
                          PickResult pickedPlace = await Navigator.push(
                            context,
                            PageTransition(
                              child: AddressInputPage(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                          if (pickedPlace != null) {
                            UserDetailsContact userAdd =
                                await showModalBottomSheet(
                                    context: context,
                                    builder: (_) => BottomSheetForAddress(
                                          pickedPlace: pickedPlace,
                                        ));
                            if (userAdd != null) {
                              model.addAddress(userAdd);
                            }
                          }
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
                            SvgPicture.asset(
                              "assets/icons/address.svg",
                              color: Colors.white,
                              width: 25,
                              height: 25,
                            ),
                            horizontalSpaceSmall,
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomText(
                                "Add Address",
                                isBold: true,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  verticalSpace(35),
                  if (model.addresses.length != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Previously Added Addresses",
                        style: TextStyle(
                            fontFamily: headingFont,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                  verticalSpace(15),
                  Column(
                    children: model.addresses.map(
                      (UserDetailsContact address) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              addressGrpValue = addressRadioValue = address;
                              disabledPayment = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: spaceBetweenCards),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(curve15),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 15, 15, 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                      value: address,
                                      groupValue: addressGrpValue,
                                      onChanged: (val) {
                                        // setState(() {
                                        //   addressGrpValue =
                                        //       addressRadioValue = val;
                                        //   disabledPayment = false;
                                        // });
                                        print(val);
                                      },
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CustomText(
                                            "Address",
                                            color: Colors.grey[700],
                                            isBold: true,
                                          ),
                                          verticalSpaceTiny_0,
                                          CustomText(
                                            address.address +
                                                "\n" +
                                                address.googleAddress,
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
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

  // void _setRadioValue(val) {
  //   setState(() {
  //     addressRadioValue = val;
  //   });
  //   print(val);
  //   print(addressRadioValue);
  // }
}
