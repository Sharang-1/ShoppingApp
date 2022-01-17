import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/widgets/custom_dialog.dart';
import '../utils/lang/translation_keys.dart';

class DialogService {
  /// Shows a simple dialog
  static Future showDialog({
    String title = "",
    String description = "",
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
  static Future<dynamic> showCustomDialog<T>(Widget widget,
          {bool barrierDismissible = true,
          Color? barrierColor,
          bool useSafeArea = true,
          bool useRootNavigator = true,
          Object? arguments,
          Duration? transitionDuration,
          Curve? transitionCurve,
          String? name,
          RouteSettings? routeSettings}) =>
      Get.dialog(widget,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          useSafeArea: useSafeArea,
          // useRootNavigator: useRootNavigator,
          arguments: arguments,
          transitionDuration: transitionDuration,
          transitionCurve: transitionCurve,
          name: name,
          routeSettings: routeSettings);

  /// Shows a confirmation dialog
  static Future showConfirmationDialog({
    String title = "",
    String description = "",
    String confirmationTitle = 'Ok',
    String cancelTitle = 'Cancel',
    required Function onConfirm,
    required Function onCancel,
  }) =>
      Get.dialog(CustomDialog(
        title: title,
        description: description,
        confirmationTitle: confirmationTitle,
        cancelTitle: cancelTitle,
        onConfirm: onConfirm(),
        onCancel: onCancel(),
      ));

  static void showNotDeliveringDialog({String? msg}) {
    showDialog(
      title: SERVICE_NOT_AVAILABLE_TITLE.tr,
      description: msg ?? SERVICE_NOT_AVAILABLE_DESCRIPTION.tr,
      buttonTitle: OK.tr,
    );
  }

  static void popDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
