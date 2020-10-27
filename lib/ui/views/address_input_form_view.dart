import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class AddressInputPage extends StatefulWidget {
  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  final _locationStringController = TextEditingController();
  final _addressStringController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _locationStringController.dispose();
    _addressStringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 1,
      //   backgroundColor: Colors.white,
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.my_location),a
      //       onPressed: () {},
      //     )
      //   ],
      //   iconTheme: IconThemeData(color: appBarIconColor),
      // ),
      // bottomSheet: BottomSheetForAddress(
      //     locationStringController: _locationStringController,
      //     addressStringController: _addressStringController),
      body: SafeArea(
        child: Center(
          child: PlacePicker(
            apiKey: "AIzaSyCQo523YX7WkavuVVYLdFNXf79sJ89X2Ns",
            // onPlacePicked: (result) {
            //   print(result.addressComponents);
            //   Navigator.of(context).pop(result);
            // },
            onGeocodingSearchFailed: (data) {
              print(data);
            },
            selectedPlaceWidgetBuilder:
                (_, selectedPlace, state, isSearchBarFocused) {
              return isSearchBarFocused
                  ? Container()
                  // Use FloatingCard or just create your own Widget.
                  : state == SearchingState.Searching
                      ? Center(child: CircularProgressIndicator())
                      : FloatingCard(
                          borderRadius: BorderRadius.circular(12.0),
                          child: BottomSheetForAddress(
                            locationStringController: _locationStringController,
                            addressStringController: _addressStringController,
                            selectedPlace: selectedPlace,
                          ),
                        );
            },
            initialPosition: new LatLng(0.0, 0.0),
            useCurrentLocation: true,
          ),
        ),
      ),
    );
  }
}

class BottomSheetForAddress extends StatelessWidget {
  BottomSheetForAddress(
      {Key key,
      TextEditingController locationStringController,
      TextEditingController addressStringController,
      PickResult selectedPlace})
      : _locationStringController = locationStringController,
        _addressStringController = addressStringController,
        _selectedPlace = selectedPlace,
        super(key: key) {
    _addressStringController.text = selectedPlace.formattedAddress;
  }

  TextEditingController _locationStringController;
  TextEditingController _addressStringController;
  PickResult _selectedPlace;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      color: backgroundWhiteCreamColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
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
              verticalSpace(10),
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          controller: _locationStringController,
                          validator: (text) {
                            if (text.isEmpty || text.trim().length == 0)
                              return "Please enter Proper Address";
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Your Location',
                            isDense: true,
                          ),
                          autofocus: false,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    horizontalSpaceMedium,
                    FractionallySizedBox(
                      child: RaisedButton(
                        elevation: 5,
                        onPressed: () {},
                        color: darkRedSmooth,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          // side: BorderSide(
                          //     color: Colors.black, width: 0.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomText(
                            "Change",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _addressStringController,
                        maxLines: 3,
                        validator: (text) {
                          if (text.isEmpty || text.trim().length == 0)
                            return "Please enter Proper Address";
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'House Number , Society Name ....',
                          isDense: true,
                        ),
                        autofocus: false,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      elevation: 5,
                      onPressed: () {
                        final locationString = _locationStringController.text;
                        final addresString = _addressStringController.text;

                        if (locationString.isEmpty ||
                            locationString.trim().length == 0 ||
                            addresString.isEmpty ||
                            addresString.trim().length == 0) {
                          return;
                        }
                        print("Address saved :::: " + addresString);
                        Navigator.of(context).pop<String>(addresString);
                      },
                      color: green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        // side: BorderSide(
                        //     color: Colors.black, width: 0.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: CustomText(
                          "Save & Proceed ",
                          isBold: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
