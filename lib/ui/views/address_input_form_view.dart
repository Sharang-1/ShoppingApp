// import 'package:fimber/fimber_base.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/address_controller.dart';
import '../../locator.dart';
import '../../models/user_details.dart';
import '../../packages/google_maps_place_picker/google_maps_place_picker.dart';
import '../../services/location_service.dart';
import '../../utils/lang/translation_keys.dart';
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              PlacePicker(
                initialPosition: new LatLng(_locationService.currentLocation.latitude ?? 23.0204975,
                    _locationService.currentLocation.longitude ?? 72.43931),
                useCurrentLocation: true,
                selectInitialPosition: true,
                enableMapTypeButton: false,
                region: 'in',
                apiKey: "AIzaSyCQo523YX7WkavuVVYLdFNXf79sJ89X2Ns",
                onGeocodingSearchFailed: (data) {
                  Fimber.e(data);
                },
                onPlacePicked: (r) {
                  Fimber.e(r.formattedAddress ?? "Picked Address should be here");
                  (controller as AddressController).selectedResult = r;
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
  const BottomSheetForAddress({Key? key}) : super(key: key);
  @override
  _BottomSheetForAddressState createState() => _BottomSheetForAddressState();
}

class _BottomSheetForAddressState extends State<BottomSheetForAddress> {
  final _formKey = GlobalKey<FormState>();

  final _userInputedAddressString1Controller = TextEditingController();
  final _userInputedAddressString2Controller = TextEditingController();
  final _googleAddressStringController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  _BottomSheetForAddressState();

  // setAddress(PickResult pickedPlace) {
  //   setState(() {
  //     _googleAddressStringController.text = pickedPlace.formattedAddress ?? "";
  //
  //     var googlePincode =
  //         int.tryParse(pickedPlace.addressComponents!.last.longName);
  //     _pinCodeController.text = googlePincode?.toString() ?? "";
  //   });
  // }

  @override
  void initState() {
    super.initState();
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
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  _submit() {
    var isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      String pickedCity = _cityController.text.trim();

      final userInputAddressString =
          "${_userInputedAddressString1Controller.text}, \n${_userInputedAddressString2Controller.text}";
      String googleAddresString = "";
      // _googleAddressStringController
      //     .text;
      final pinCode = int.tryParse(_pinCodeController.text);

      if (pinCode == null) {
        return;
      }

      if (userInputAddressString.isEmpty ||
          userInputAddressString.trim().length == 0 ||
          pinCode.toString().length == 0 ||
          pickedCity.length == 0) {
        return;
      }

      final String state = _stateController.text.trim();

      print("pickedCity12 : $pickedCity");

      googleAddresString =
          userInputAddressString + ", " + pickedCity + ", " + state + ", " + pinCode.toString();
      Navigator.of(context).pop<UserDetailsContact>(new UserDetailsContact(
        address: userInputAddressString,
        googleAddress: googleAddresString,
        pincode: pinCode,
        city: pickedCity,
        state: state,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddressController(),
      builder: (controller) => Container(
        padding: EdgeInsets.only(top: 24.0),
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
                        ADD_ADDRESS.tr,
                        style: TextStyle(
                            fontFamily: headingFont, fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ),
                  ),
                  verticalSpaceSmall,
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    elevation: 3.0,
                    color: Colors.white,
                    shadowColor: Colors.black,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // TextFormField(
                            //   style: TextStyle(
                            //     color: Colors.grey[500],
                            //     fontSize: 12,
                            //   ),
                            //   controller: _googleAddressStringController,
                            //   validator: (text) {
                            //     if ((text!.isEmpty) ||
                            //         text.trim().length == 0)
                            //       return ENTER_PROPER_ADDRESS.tr;
                            //     return null;
                            //   },
                            //   decoration: InputDecoration(
                            //     labelText: YOUR_LOCATION.tr,
                            //     isDense: true,
                            //     suffixIcon: InkWell(
                            //       onTap: () {
                            //         changeAddress();
                            //       },
                            //       child: Text(
                            //         CHANGE.tr,
                            //         style: TextStyle(
                            //           fontSize: 10,
                            //           color: logoRed,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            //   autofocus: false,
                            //   readOnly: true,
                            //   maxLines: 3,
                            // ),
                            // verticalSpaceMedium,
                            TextFormField(
                              maxLines: 3,
                              controller: _userInputedAddressString1Controller,
                              maxLength: 30,
                              validator: (text) {
                                if (text!.isEmpty || text.trim().length == 0)
                                  return ENTER_PROPER_ADDRESS.tr;
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  _userInputedAddressString1Controller.text;
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: HOUSE_NAME_LABEL.tr,
                                  isDense: true,
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(
                                      fontSize: subtitleFontSizeStyle, fontFamily: textFont)),
                              autofocus: false,
                              enabled: true,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextFormField(
                              maxLines: 3,
                              controller: _userInputedAddressString2Controller,
                              maxLength: 50,
                              validator: (text) {
                                if (text!.isEmpty || text.trim().length == 0)
                                  return ENTER_PROPER_ADDRESS.tr;
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  _userInputedAddressString2Controller.text;
                                });
                              },
                              decoration: InputDecoration(
                                
                                  labelText: LANDMARK_LABEL.tr,
                                  isDense: true,
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(
                                      fontSize: subtitleFontSizeStyle, fontFamily: textFont)),
                              autofocus: false,
                              enabled: true,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),

                            /// City and PINCODE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                        hintText: "City",
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            fontSize: subtitleFontSizeStyle, fontFamily: textFont)),
                                    autofocus: false,
                                    enabled: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: _pinCodeController,
                                    decoration: InputDecoration(
                                        hintText: "Pincode",
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            fontSize: subtitleFontSizeStyle, fontFamily: textFont)),
                                    autofocus: false,
                                    enabled: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceMedium,

                            /// State
                            TextFormField(
                              controller: _stateController,
                              maxLength: 50,
                              validator: (text) {
                                if (text!.isEmpty || text.trim().length == 0)
                                  return "Enter proper State";
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  _stateController.text;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "State",
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(
                                      fontSize: subtitleFontSizeStyle, fontFamily: textFont)),
                              autofocus: false,
                              enabled: true,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
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
                                    ),
                                  ),
                                  onPressed: _submit,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: CustomText(
                                      SAVE_AND_PROCEED.tr,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void changeAddress() async {
  //   PickResult pickedPlace = await Navigator.push(
  //     context,
  //     PageTransition(
  //       child: AddressInputPage(),
  //       type: PageTransitionType.rightToLeft,
  //     ),
  //   );
  //   setAddress(pickedPlace);
  // }
}
