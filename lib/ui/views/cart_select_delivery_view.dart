import 'dart:convert';

import 'package:compound/controllers/home_controller.dart';
import 'package:compound/models/orderV2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../controllers/cart_select_delivery_controller.dart';
import '../../locator.dart';
import '../../models/user_details.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_stepper.dart';
import '../widgets/custom_text.dart';
import 'address_input_form_view.dart';
import 'cart_payment_method_view.dart';

class SelectAddress extends StatefulWidget {
  final List<dynamic> products;
  final double? payTotal;

  const SelectAddress({
    Key? key,
    required this.products,
    this.payTotal,
  }) : super(key: key);

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  UserDetailsContact addressRadioValue = UserDetailsContact();
  UserDetailsContact addressGrpValue = UserDetailsContact();
  bool disabledPayment = true;
  String? deliveryCharges = "";
  TextEditingController _emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartSelectDeliveryController>(
      init: CartSelectDeliveryController(),
      builder: (controller) => Scaffold(
        backgroundColor: newBackgroundColor2,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            SELECT_ADDRESS.tr,
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
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    // showBottomSheet(
                    //   clipBehavior: Clip.antiAlias,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.only(
                    //       topLeft: Radius.circular(10),
                    //       topRight: Radius.circular(10),
                    //     ),
                    //   ),
                    //   // isScrollControlled: true,

                    //   context: context,
                    //   builder: (context) => OrderDetailsBottomsheet(
                    //     orderDetails: orderDetails,
                    //     buttonText: MAKE_PAYMENT.tr,
                    //     buttonIcon: FontAwesomeIcons.lock,
                    //     onButtonPressed:
                    //         disabledPayment ? () {} : () async => await makePayment(controller),
                    //     isPromocodeApplied: widget.isPromocodeApplied,
                    //   ),
                    // );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        // "${BaseController.formatPrice(num.parse(orderDetails.total!.replaceAll("₹", "")))}",
                        rupeeUnicode + widget.payTotal.toString(),
                        fontSize: 18,
                        isBold: true,
                        color: logoRed,
                      ),
                      CustomText(
                        "Order Total",
                        textStyle: TextStyle(
                          fontSize: 12,
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
                    onPressed: disabledPayment ? null : () async => await makePayment(controller),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: CustomText(
                          MAKE_PAYMENT.tr,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSpace(10),
                  const CutomStepper(
                    step: 2,
                  ),
                  verticalSpace(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Communication Mail",
                      style: TextStyle(
                          fontFamily: headingFont, fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  verticalSpace(10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(curve15)),
                    child: TextFormField(
                      controller: _emailcontroller,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: "Email Address",
                          border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Provide email to recieve invoice";
                        }
                        if (!value.isEmail) {
                          return "Invalid Email";
                        }
                        return null;
                      },
                    ),
                  ),
                  verticalSpace(20),
                  if (controller.addresses.length != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        MY_ADDRESSES.tr,
                        style: TextStyle(
                            fontFamily: headingFont, fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ),
                  verticalSpace(15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: List<Widget>.of(
                        controller.addresses.map(
                          (UserDetailsContact address) => GestureDetector(
                            onTap: () async {
                              setState(
                                () {
                                  addressGrpValue = addressRadioValue = address;
                                  disabledPayment = false;
                                },
                              );
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
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Radio(
                                        value: address,
                                        groupValue: addressGrpValue,
                                        onChanged: (val) async {
                                          setState(
                                            () {
                                              addressGrpValue = addressRadioValue = address;
                                              disabledPayment = false;
                                            },
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                CustomText(
                                                  MY_ADDRESS.tr,
                                                  color: Colors.grey[700]!,
                                                  fontSize: 14,
                                                  isBold: true,
                                                ),
                                                verticalSpaceTiny_0,
                                                CustomText(
                                                  "${address.address}",
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                            if (deliveryCharges != null &&
                                                addressGrpValue == address)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: CustomText(
                                                  deliveryCharges == "0.00"
                                                      ? "Free Delivery"
                                                      : "+ ₹$deliveryCharges",
                                                  fontSize: subtitleFontSize,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: darkRedSmooth,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          // PickResult pickedPlace = await Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     child: AddressInputPage(),
                          //     type: PageTransitionType.rightToLeft,
                          //   ),
                          // );

                          UserDetailsContact userAdd = await showMaterialModalBottomSheet(
                            expand: true,
                            context: context,
                            builder: (_) => BottomSheetForAddress(),
                          );
                          if (userAdd != null) {
                            controller.addAddress(userAdd);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/svg/address.svg",
                              color: Colors.white,
                              width: 25,
                              height: 25,
                            ),
                            horizontalSpaceSmall,
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomText(
                                ADD_ADDRESS.tr,
                                isBold: true,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(controller) async {
    var orderJson = {
      'customerDetails': jsonEncode(
        CustomerDetails(
          address: controller.addresses[0].address.toString(),
          pincode: controller.addresses[0].pincode,
          city: controller.addresses[0].city,
          state: controller.addresses[0].state,
          country: "India",
          // name: locator<HomeController>().details!.firstName.toString() +
          //     locator<HomeController>().details!.lastName.toString(),
          customerPhone: CustomerPhone(
            code: locator<HomeController>().details!.contact!.phone!.code,
            mobile: locator<HomeController>().details!.contact!.phone!.mobile,
          ),
          email: _emailcontroller.text.trim(),
        ),
      )
    };
    if (kDebugMode) print(orderJson);

    // final serviceAvailability = await locator<APIService>()
    //     .checkPincode(productId: widget.productId, pincode: addressRadioValue.pincode.toString());

    // if (serviceAvailability == null) return;

    // if (serviceAvailability.serviceAvailable ?? false) {
    Navigator.push(
      context,
      PageTransition(
          child: PaymentMethod(
            products: widget.products,
            finalTotal: widget.payTotal,
            customerDetails: CustomerDetails(
              address: controller.addresses[0].address.toString(),
              pincode: controller.addresses[0].pincode,
              city: controller.addresses[0].city,
              state: controller.addresses[0].state,
              country: "India",
              // TODO : name and customer id null issue
              name: locator<HomeController>().details!.firstName.toString() +
                  locator<HomeController>().details!.lastName.toString(),
              customerId: locator<HomeController>().details!.key.toString(),
              customerPhone: CustomerPhone(
                code: locator<HomeController>().details!.contact!.phone!.code,
                mobile: locator<HomeController>().details!.contact!.phone!.mobile,
              ),
              email: _emailcontroller.text.trim(),
            ),
          ),
          type: PageTransitionType.rightToLeft),
    );
    // } else {
    //   DialogService.showNotDeliveringDialog(msg: serviceAvailability.message ?? "");
    // }
  }
}
