import 'dart:ffi';

import 'package:async/async.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressInputPage extends StatefulWidget {
  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  final _formKey = new GlobalKey<FormState>();

  String locationString;

  String completeAddressString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundWhiteCreamColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {},
          )
        ],
        iconTheme: IconThemeData(color: textIconBlue),
      ),
      bottomSheet: DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.45,
          maxChildSize: 0.6,
          builder: (context, scrollcontroller) {
            return Material(
                elevation: 5,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: backgroundWhiteCreamColor,
                child: SingleChildScrollView(
                    controller: scrollcontroller,
                    child: Form(
                        key: _formKey,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Add Address",
                                style: TextStyle(
                                    fontFamily: headingFont,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                              verticalSpace(5),
                              SizedBox(
                                  height: 60,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(bottom: 15),
                                                child: TextFormField(
                                                  validator: (text) {
                                                    if (text.isEmpty ||
                                                        text.trim().length == 0)
                                                      return "Please enter Proper Address";
                                                    return null;
                                                  },
                                                  onSaved: (text) {
                                                    setState(() {
                                                      locationString = text;
                                                    });
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Your Location',
                                                          isDense: true),
                                                  autofocus: false,
                                                  maxLines: 1,
                                                ))),
                                        FractionallySizedBox(
                                            heightFactor: 0.5,
                                            child: RaisedButton(
                                                elevation: 1,
                                                onPressed: () {},
                                                color: darkRedSmooth,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  // side: BorderSide(
                                                  //     color: Colors.black, width: 0.5)
                                                ),
                                                child: CustomText(
                                                  "Change ",
                                                  color: Colors.white,
                                                ))),
                                      ])),
                              SizedBox(
                                  height: 80,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                            child: TextFormField(
                                          maxLines: 3,
                                          validator: (text) {
                                            if (text.isEmpty ||
                                                text.trim().length == 0)
                                              return "Please enter Proper Address";
                                            return null;
                                          },
                                          onSaved: (text) {
                                            setState(() {
                                              completeAddressString =
                                                  text.trim();
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Your Complete Address',
                                              isDense: true),
                                          autofocus: false,
                                        )),
                                      ])),
                              verticalSpaceTiny,
                              Row(children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                        onPressed: () {
                                          if (_formKey.currentState.validate())
                                            _formKey.currentState.save();
                                          print(locationString +
                                              completeAddressString);
                                        },
                                        color: Colors.green[800],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          // side: BorderSide(
                                          //     color: Colors.black, width: 0.5)
                                        ),
                                        child: CustomText(
                                          "Save & Proceed ",
                                          color: Colors.white,
                                        ))),
                              ]),
                            ],
                          ),
                        ))));
          }),
      body: SafeArea(
        child: Center(
          child: GoogleMap(
            // onMapCreated: model.onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            // markers: getMarkers(context, model),
            initialCameraPosition: CameraPosition(
              target: new LatLng(37.7510, -97.8220),
              zoom: 8,
            ),
          ),
        ),
      ),
    );
  }
}