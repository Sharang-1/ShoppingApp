import 'package:compound/models/lookups.dart';
import 'package:flutter/material.dart';

class LookupSetUp extends ChangeNotifier{
  LookupSetUp({
    Key key,
  }) : assert(List != null);

  List<Lookups> lookups;

  void setUpLookups(List<Lookups> lookups) {
    this.lookups = lookups;
    notifyListeners();
  }
}