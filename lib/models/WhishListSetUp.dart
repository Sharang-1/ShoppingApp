import 'package:flutter/material.dart';

class WhishListSetUp extends ChangeNotifier{
  WhishListSetUp({
    Key key,
    @required this.list
  }) : assert(List != null);

  List<String> list;

  void setUpWhishList(List<String> list) {
    this.list.clear();
    this.list.addAll(list);
    notifyListeners();
  }

  void addToWhishList(String item) {
    if(this.list.indexOf(item) == -1) {
      this.list.add(item);
    }
    notifyListeners();
  }

  void removeFromWhishList(String item) {
    this.list.remove(item);
    notifyListeners();
  }
}