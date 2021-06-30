import 'package:compound/locator.dart';
import 'package:compound/models/user_details.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/dialog_service.dart';
import 'base_controller.dart';

class BottomsheetSizeController extends BaseController {
  final UserDetails userDetails;

  BottomsheetSizeController({this.userDetails});

  final size1Controller = TextEditingController();
  final size2Controller = TextEditingController();
  final size3Controller = TextEditingController();
  final size4Controller = TextEditingController();
  final size5Controller = TextEditingController();

  final size1Focus = FocusNode();
  final size2Focus = FocusNode();
  final size3Focus = FocusNode();
  final size4Focus = FocusNode();
  final size5Focus = FocusNode();

  submit() async {
    if (((size1Controller.text.isEmpty) || (!size1Controller.text.isNum)) ||
        ((size2Controller.text.isEmpty) || (!size2Controller.text.isNum)) ||
        ((size3Controller.text.isEmpty) || (!size3Controller.text.isNum)) ||
        ((size4Controller.text.isEmpty) || (!size4Controller.text.isNum)) ||
        ((size5Controller.text.isEmpty) || (!size5Controller.text.isNum))) {
      await DialogService.showDialog(
        title: 'Invalid Details',
        description: 'Enter Valid Measurements !!!',
      );
      return;
    }
    setBusy(true);
    Measure measure = Measure(
      shoulders: num.parse(size1Controller.text.trim()),
      chest: num.parse(size2Controller.text.trim()),
      waist: num.parse(size3Controller.text.trim()),
      hips: num.parse(size4Controller.text.trim()),
      height: num.parse(size5Controller.text.trim()),
    );

    bool success = await locator<APIService>()
        .updateUserMeasure(measure: measure, userDetails: userDetails);

    setBusy(false);
    if (success) {
      await DialogService.showDialog(
        title: 'Measurements',
        description: 'Measurements updated successfully !!!',
      );
      NavigationService.back();
    } else {
      await DialogService.showDialog(
        title: 'Error',
        description: 'Measurements could not be updated !!!',
      );
    }
  }

  skip() async {
    NavigationService.back();
  }
}
