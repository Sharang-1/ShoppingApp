import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationService {
  void pop() => back();

  Future<dynamic> navigateTo(String routeName,
      {dynamic arguments,
      bool popNavbar = false,
      bool preventDuplicates = false}) {
    if (popNavbar) pop();
    return to(routeName,
        arguments: arguments, preventDuplicates: preventDuplicates);
  }

  Future<dynamic> navigateReplaceTo(String routeName, {dynamic arguments}) =>
      off(routeName, arguments: arguments);

  Future<dynamic> navigateAndRemoveUntil(String routeName,
          {Function predicate, dynamic arguments}) =>
      offAll(routeName,
          predicate: predicate == null ? (route) => false : predicate,
          arguments: arguments);

  //GetX Routing
  static Future<T> to<T>(String page,
      {dynamic arguments,
      int id,
      bool popNavbar = false,
      bool preventDuplicates = false}) async {
    if (popNavbar) back();
    return await Get.toNamed<T>(page,
        arguments: arguments, id: id, preventDuplicates: preventDuplicates);
  }

  static Future<T> off<T>(String page, {dynamic arguments, int id}) async =>
      await Get.offNamed<T>(page, arguments: arguments, id: id);

  static Future<T> offAll<T>(String page,
          {bool Function(Route<dynamic>) predicate,
          dynamic arguments,
          int id}) async =>
      await Get.offAllNamed<T>(page,
          predicate: predicate, arguments: arguments, id: id);

  static void back<T>(
          {T result, bool closeOverlays = false, bool canPop = true, int id}) =>
      Get.back(
          result: result, closeOverlays: closeOverlays, canPop: canPop, id: id);
}
