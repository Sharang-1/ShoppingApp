import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String cancelTitle;
  final String confirmationTitle;
  final bool isConfirmationDialog;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  const CustomDialog({
    Key? key,
    required this.title,
    this.description = '',
    this.cancelTitle = '',
    this.confirmationTitle = 'OK',
    this.isConfirmationDialog = false,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(description),
        actions: <Widget>[
          if (isConfirmationDialog)
            TextButton(
              child: Text(cancelTitle),
              onPressed: onCancel ?? () => Get.back(),
            ),
          TextButton(
            child: Text(confirmationTitle),
            onPressed: onConfirm ?? () => Get.back(),
          ),
        ],
      );
}
