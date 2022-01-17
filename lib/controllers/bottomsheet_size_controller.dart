import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../locator.dart';
import '../models/user_details.dart';
import '../services/api/api_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import 'base_controller.dart';

class BottomsheetSizeController extends BaseController {
  final UserDetails? userDetails;

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

  init() async {
    UserDetails? _userDetails = await locator<APIService>().getUserData();
    Measure _measure = _userDetails!.measure!;
    if (_measure != null) {
      if (_measure.shoulders != null)
        size1Controller.text = _measure.shoulders.toString();
      if (_measure.chest != null)
        size2Controller.text = _measure.chest.toString();
      if (_measure.waist != null)
        size3Controller.text = _measure.waist.toString();
      if (_measure.hips != null)
        size4Controller.text = _measure.hips.toString();
      if (_measure.height != null)
        size5Controller.text = _measure.height.toString();
    }
  }

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
