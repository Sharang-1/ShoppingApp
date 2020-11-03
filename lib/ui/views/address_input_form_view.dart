import 'package:compound/services/address_service.dart';
import 'package:compound/services/location_service.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/address_view_model.dart';
import 'package:compound/viewmodels/appointments_view_model.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

import '../../locator.dart';

class AddressInputPage extends StatefulWidget {
  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  final LocationService _locationService = locator<LocationService>();
  final AddressService _addressService = locator<AddressService>();

  final _locationStringController = TextEditingController();
  final _addressStringController = TextEditingController();
  PickResult selectedPlace;

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
    return ViewModelProvider<AddressViewModel>.withConsumer(
        viewModel: AddressViewModel(),
        // onModelReady: (model) => model.getAppointments(),
        builder: (context, model, child) => Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    PlacePicker(
                      resizeToAvoidBottomInset: true,
                      initialPosition: new LatLng(
                          _locationService.currentLocation?.latitude ?? 0.0,
                          _locationService.currentLocation?.longitude ?? 0.0),
                      useCurrentLocation: true,
                      selectInitialPosition: true,
                      forceSearchOnZoomChanged: true,
                      forceAndroidLocationManager: true,
                      searchingText: "",
                      strictbounds: true,
                      usePinPointingSearch: true,
                      region: 'in',
                      apiKey: "AIzaSyCQo523YX7WkavuVVYLdFNXf79sJ89X2Ns",
                      onGeocodingSearchFailed: (data) {
                        Fimber.e(data);
                      },
                      selectedPlaceWidgetBuilder:
                          (_, selectedPlace, state, isSearchBarFocused) {
                        model.selectedResult = selectedPlace;
                        return Container();
                      },
                    ),
                    SizedBox.expand(
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.30,
                        minChildSize: 0.2,
                        maxChildSize: 0.5,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: BottomSheetForAddress(
                                locationStringController:
                                    _locationStringController,
                                addressStringController:
                                    _addressStringController,
                                selectedPlace: model.selectedResult ??
                                    PickResult(formattedAddress: "")),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}

class BottomSheetForAddress extends StatelessWidget {
  final TextEditingController _locationStringController;
  final TextEditingController _addressStringController;
  final PickResult _selectedPlace;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: EdgeInsets.all(35),
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
                height: 160,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          controller: _addressStringController,
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
                          enabled: false,
                          maxLines: 4,
                        ),
                      ),
                    ),
                    horizontalSpaceMedium,
                    RaisedButton(
                      elevation: 5,
                      onPressed: () {},
                      color: darkRedSmooth,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        // side: BorderSide(
                        //     color: Colors.black, width: 0.5)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CustomText(
                          "Change",
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 90,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _locationStringController,
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
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpaceMedium,

              //Save Btn Row
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
                        Navigator.of(context).pop<PickResult>(_selectedPlace);
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
