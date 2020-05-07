import 'dart:ffi';

import 'package:async/async.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {},
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomSheet: DraggableScrollableSheet(
          minChildSize: 0.4,
          initialChildSize: 0.4,
          maxChildSize: 0.5,
          builder: (context, scrollcontroller) {
            return Material(
                elevation: 5,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                color: Colors.white,
                child: SingleChildScrollView(
                    controller: scrollcontroller,
                    child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CustomText(
                                "Add Location",
                                isBold: true,
                                fontSize: 18,
                              ),
                              SizedBox(
                                  height: 60,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
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
                                          decoration: const InputDecoration(
                                              labelText: 'Your Location',
                                              isDense: true),
                                          autofocus: false,
                                          maxLines: 1,
                                        )),
                                        FractionallySizedBox(
                                            heightFactor: 0.5,
                                            child: RaisedButton(
                                                elevation: 1,
                                                onPressed: () {},
                                                color: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  // side: BorderSide(
                                                  //     color: Colors.black, width: 0.5)
                                                ),
                                                child: Text(
                                                  "Change ",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                              Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: RaisedButton(
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate())
                                                _formKey.currentState.save();
                                              print(locationString +
                                                  completeAddressString);
                                            },
                                            color: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // side: BorderSide(
                                              //     color: Colors.black, width: 0.5)
                                            ),
                                            child: Text(
                                              "Save & Proceed ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                  ])),
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
