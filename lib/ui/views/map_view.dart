import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/app_title.dart';
import 'package:compound/ui/widgets/busy_button.dart';
import 'package:compound/ui/widgets/input_field.dart';
import 'package:compound/viewmodels/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:compound/viewmodels/login_view_model.dart';

class MapView extends StatelessWidget {
  final phoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MapViewModel>.withConsumer(
      viewModel: MapViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: const LatLng(72, 122),
              zoom: 4,
            ),
          )),
    );
  }
}
