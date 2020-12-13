import 'package:compound/models/lookups.dart';
import 'package:flutter/material.dart';

class LookupSetUp extends ChangeNotifier{
  LookupSetUp({
    Key key,
  }) : assert(List != null);

  Map<String, List<Lookup>> lookups;

  void setUpLookups(List<Lookups> lookups) {
    for (var lookup in lookups) {
      this.lookups[lookup.name] = lookup.options;
    }
    notifyListeners();
  }
}