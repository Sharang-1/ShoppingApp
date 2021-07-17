import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class CartCountController extends BaseController {
  CartCountController({Key key, this.count}) : assert(count != null);

  RxInt count = 0.obs;

  void setCartCount(int value) {
    count.value = value;
  }

  void decrementCartCount() {
    this.count.value = (count.value > 0) ? (this.count.value - 1) : 0;
  }

  void incrementCartCount() {
    this.count.value = this.count.value + 1;
  }
}
