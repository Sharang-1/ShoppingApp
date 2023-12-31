import 'package:flutter/material.dart';

import '../models/lookups.dart';
import 'base_controller.dart';

class LookupController extends BaseController {
  LookupController({
    Key? key,
    // ignore: unnecessary_null_comparison
  }) : assert(List != null);

  List<Lookups> lookups = [];

  void setUpLookups(List<Lookups> lookups) {
    this.lookups = lookups;
    update();
  }
}
