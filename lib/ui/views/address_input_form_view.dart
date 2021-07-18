import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/address_controller.dart';
import '../../google_maps_place_picker/google_maps_place_picker.dart';
import '../../locator.dart';
import '../../models/user_details.dart';
import '../../services/location_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';

class AddressInputPage extends StatefulWidget {
  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  final LocationService _locationService = locator<LocationService>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddressController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              PlacePicker(
                initialPosition: new LatLng(
                    _locationService.currentLocation?.latitude ?? 0.0,
                    _locationService.currentLocation?.longitude ?? 0.0),
                useCurrentLocation: true,
                selectInitialPosition: true,
                enableMapTypeButton: false,
                region: 'in',
                apiKey: "AIzaSyCQo523YX7WkavuVVYLdFNXf79sJ89X2Ns",
                onGeocodingSearchFailed: (data) {
                  Fimber.e(data);
                },
                onPlacePicked: (r) {
                  Fimber.e(r.formattedAddress);
                  controller.selectedResult = r;
                  Navigator.of(context).pop<PickResult>(r);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetForAddress extends StatefulWidget {
  final PickResult pickedPlace;

  const BottomSheetForAddress({Key key, this.pickedPlace}) : super(key: key);
  @override
  _BottomSheetForAddressState createState() => _BottomSheetForAddressState();
}

class _BottomSheetForAddressState extends State<BottomSheetForAddress> {
  final _userInputedAddressString1Controller = TextEditingController();
  final _userInputedAddressString2Controller = TextEditingController();
  final _googleAddressStringController = TextEditingController();
  final _pinCodeController = TextEditingController();

  _BottomSheetForAddressState();

  setAddress(PickResult pickedPlace) {
    setState(() {
      _googleAddressStringController.text = pickedPlace.formattedAddress;

      var googlePincode =
          int.tryParse(pickedPlace.addressComponents.last.longName);
      _pinCodeController.text = googlePincode?.toString() ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    setAddress(widget.pickedPlace);
  }

  @override
  void didUpdateWidget(covariant BottomSheetForAddress oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _userInputedAddressString1Controller.dispose();
    _userInputedAddressString2Controller.dispose();
    _googleAddressStringController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddressController(),
      builder: (controller) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.size.height * 0.8),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Add Address",
                            style: TextStyle(
                                fontFamily: headingFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 3.0,
                        color: Colors.white,
                        shadowColor: Colors.black,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                                controller: _googleAddressStringController,
                                validator: (text) {
                                  if (text.isEmpty || text.trim().length == 0)
                                    return "Please enter Proper Address";
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Your Location',
                                  isDense: true,
                                  suffixIcon: InkWell(
                                    onTap: changeAddress,
                                    child: Text(
                                      "CHANGE",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: logoRed,
                                      ),
                                    ),
                                  ),
                                ),
                                autofocus: false,
                                readOnly: true,
                                maxLines: 3,
                              ),
                              verticalSpaceMedium,
                              TextFormField(
                                controller:
                                    _userInputedAddressString1Controller,
                                maxLength: 30,
                                validator: (text) {
                                  if (text.isEmpty || text.trim().length == 0)
                                    return "Please enter Proper Address";
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    _userInputedAddressString1Controller.text;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'House Name, House Number ....',
                                  isDense: true,
                                ),
                                autofocus: false,
                                enabled: true,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              TextFormField(
                                controller:
                                    _userInputedAddressString2Controller,
                                maxLength: 50,
                                validator: (text) {
                                  if (text.isEmpty || text.trim().length == 0)
                                    return "Please enter Proper Address";
                                  return null;
                                },
                                onChanged: (text) {
                                  setState(() {
                                    _userInputedAddressString2Controller.text;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Landmark , Society Name ....',
                                  isDense: true,
                                ),
                                autofocus: false,
                                enabled: true,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              verticalSpaceMedium,
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      primary: lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        // side: BorderSide(
                                        //     color: Colors.black, width: 0.5)
                                      ),
                                    ),
                                    onPressed:
                                        ((_userInputedAddressString1Controller
                                                    .text
                                                    .trim()
                                                    .isEmpty) ||
                                                (_userInputedAddressString2Controller
                                                    .text
                                                    .trim()
                                                    .isEmpty))
                                            ? null
                                            : () {
                                                final userInputAddressString =
                                                    "${_userInputedAddressString1Controller.text}, ${_userInputedAddressString2Controller.text}";
                                                final googleAddresString =
                                                    _googleAddressStringController
                                                        .text;
                                                final pinCode = int.tryParse(
                                                    _pinCodeController.text);

                                                if (pinCode == null) {
                                                  return;
                                                }

                                                if (userInputAddressString.isEmpty ||
                                                    userInputAddressString
                                                            .trim()
                                                            .length ==
                                                        0 ||
                                                    googleAddresString
                                                        .isEmpty ||
                                                    googleAddresString
                                                            .trim()
                                                            .length ==
                                                        0) {
                                                  return;
                                                }

                                                final String gujState =
                                                    "Gujarat".toUpperCase();
                                                final int stateIndex = widget
                                                    .pickedPlace
                                                    .addressComponents
                                                    .indexWhere((element) =>
                                                        element.longName
                                                            .toUpperCase() ==
                                                        gujState);
                                                String pickedCity;
                                                if (stateIndex != -1)
                                                  pickedCity = widget
                                                      .pickedPlace
                                                      .addressComponents[
                                                          stateIndex - 1]
                                                      .longName;

                                                Navigator.of(context)
                                                    .pop<UserDetailsContact>(
                                                        new UserDetailsContact(
                                                  address:
                                                      userInputAddressString,
                                                  googleAddress:
                                                      googleAddresString,
                                                  pincode: pinCode,
                                                  city: pickedCity,
                                                  state: gujState,
                                                ));
                                              },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: CustomText(
                                        "Save & Proceed ",
                                        isBold: true,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Flexible(
                      //       fit: FlexFit.tight,
                      //       child: TextFormField(
                      //         style: TextStyle(
                      //           fontSize: 17,
                      //         ),
                      //         controller: _googleAddressStringController,
                      //         validator: (text) {
                      //           if (text.isEmpty || text.trim().length == 0)
                      //             return "Please enter Proper Address";
                      //           return null;
                      //         },
                      //         decoration: const InputDecoration(
                      //           labelText: 'Your Location',
                      //           isDense: true,
                      //         ),
                      //         autofocus: false,
                      //         enabled: false,
                      //         maxLines: 2,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // verticalSpaceMedium,
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Expanded(
                      //       child: TextFormField(
                      //         controller: _userInputedAddressStringController,
                      //         maxLines: 2,
                      //         validator: (text) {
                      //           if (text.isEmpty || text.trim().length == 0)
                      //             return "Please enter Proper Address";
                      //           return null;
                      //         },
                      //         onChanged: (text) {
                      //           setState(() {
                      //             _userInputedAddressStringController.text;
                      //           });
                      //         },
                      //         decoration: const InputDecoration(
                      //           labelText: 'House Number , Society Name ....',
                      //           isDense: true,
                      //         ),
                      //         autofocus: false,
                      //         enabled: true,
                      //         style: TextStyle(
                      //           fontSize: 17,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // verticalSpaceMedium,
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     Expanded(
                      //       child: TextFormField(
                      //         controller: _pinCodeController,
                      //         maxLines: 1,
                      //         inputFormatters: <TextInputFormatter>[
                      //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                      //         ],
                      //         style: TextStyle(
                      //           fontSize: 17,
                      //         ),
                      //         validator: (text) {
                      //           if (text.isEmpty ||
                      //               text.trim().length == 0 ||
                      //               text.trim().length != 7)
                      //             return "Please enter Proper Pincode";
                      //           return null;
                      //         },
                      //         decoration: const InputDecoration(
                      //           labelText: 'Pincode',
                      //           isDense: true,
                      //         ),
                      //         autofocus: false,
                      //         enabled: false,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // verticalSpaceLarge,
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: SizedBox(
                      //     width: double.infinity,
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         elevation: 5,
                      //         primary: green,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(30),
                      //           // side: BorderSide(
                      //           //     color: Colors.black, width: 0.5)
                      //         ),
                      //       ),
                      //       onPressed: _userInputedAddressStringController.text
                      //               .trim()
                      //               .isEmpty
                      //           ? null
                      //           : () {
                      //               final userInputAddressString =
                      //                   _userInputedAddressStringController.text;
                      //               final googleAddresString =
                      //                   _googleAddressStringController.text;
                      //               final pinCode =
                      //                   int.tryParse(_pinCodeController.text);

                      //               if (pinCode == null) {
                      //                 return;
                      //               }

                      //               if (userInputAddressString.isEmpty ||
                      //                   userInputAddressString.trim().length == 0 ||
                      //                   googleAddresString.isEmpty ||
                      //                   googleAddresString.trim().length == 0) {
                      //                 return;
                      //               }

                      //               final String gujState = "Gujarat".toUpperCase();
                      //               final int stateIndex = widget
                      //                   .pickedPlace.addressComponents
                      //                   .indexWhere((element) =>
                      //                       element.longName.toUpperCase() ==
                      //                       gujState);
                      //               String pickedCity;
                      //               if (stateIndex != -1)
                      //                 pickedCity = widget.pickedPlace
                      //                     .addressComponents[stateIndex - 1].longName;

                      //               Navigator.of(context).pop<UserDetailsContact>(
                      //                   new UserDetailsContact(
                      //                 address: userInputAddressString,
                      //                 googleAddress: googleAddresString,
                      //                 pincode: pinCode,
                      //                 city: pickedCity,
                      //                 state: gujState,
                      //               ));
                      //             },
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(vertical: 12),
                      //         child: CustomText(
                      //           "Save & Proceed ",
                      //           isBold: true,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeAddress() async {
    PickResult pickedPlace = await Navigator.push(
      context,
      PageTransition(
        child: AddressInputPage(),
        type: PageTransitionType.rightToLeft,
      ),
    );
    setAddress(pickedPlace);
  }
}
