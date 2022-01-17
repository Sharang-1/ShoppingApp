import 'package:flutter/material.dart';

import 'base_controller.dart';

class WishListController extends BaseController {
  WishListController({Key? key, required this.list}) : assert(List != null);

  List<String> list = [];

  void setUpWishList(List<String> list) {
    this.list.clear();
    this.list.addAll(list);
    update();
  }

  void addToWishList(String item) {
    if (this.list.indexOf(item) == -1) {
      this.list.add(item);
      update();
    }
  }

  void removeFromWishList(String item) {
    this.list.remove(item);
    update();
  }
}
