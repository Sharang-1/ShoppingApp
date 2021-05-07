import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/widgets/custom_dialog.dart';

class DialogService {
  /// Shows a simple dialog
  static Future showDialog({
    String title,
    String description,
    String buttonTitle = 'Ok',
  }) =>
      Get.dialog(
        CustomDialog(
          title: title,
          description: description,
          confirmationTitle: buttonTitle,
        ),
      );

  /// Shows a custom dialog
  static Future<T> showCustomDialog<T>(Widget widget,
          {bool barrierDismissible = true,
          Color barrierColor,
          bool useSafeArea = true,
          bool useRootNavigator = true,
          Object arguments,
          Duration transitionDuration,
          Curve transitionCurve,
          String name,
          RouteSettings routeSettings}) =>
      Get.dialog(widget,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          useSafeArea: useSafeArea,
          useRootNavigator: useRootNavigator,
          arguments: arguments,
          transitionDuration: transitionDuration,
          transitionCurve: transitionCurve,
          name: name,
          routeSettings: routeSettings);

  /// Shows a confirmation dialog
  static Future showConfirmationDialog({
    String title,
    String description,
    String confirmationTitle = 'Ok',
    String cancelTitle = 'Cancel',
    @required Function onConfirm,
    Function onCancel,
  }) =>
      Get.dialog(CustomDialog(
        title: title,
        description: description,
        confirmationTitle: confirmationTitle,
        cancelTitle: cancelTitle,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ));

  static void showNotDeliveringDialog() {
    showDialog(
        title: "Sorry!~",
        description: "We only deliver to Ahmedabad as of now.",
        buttonTitle: "Ok");
  }

  static void popDialog() {
    if (Get.isDialogOpen) Get.back();
  }
}
