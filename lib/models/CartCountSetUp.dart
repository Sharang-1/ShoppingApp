import 'package:flutter/material.dart';

class CartCountSetUp extends ChangeNotifier{
  CartCountSetUp({
    Key key,
    this.count = 0
  }) : assert(count != null);

  int count;

  void setCartCount(int value) {
    count = value;
    notifyListeners();
  }

  void decrementCartCount() {
    this.count = count > 0 ? this.count - 1 : 0;
    notifyListeners();
  }

  void incrementCartCount() {
    this.count = this.count + 1; 
    notifyListeners();
  }
}