import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/lang/translation_keys.dart';
import '../shared/shared_styles.dart';

class SellerStatus extends StatelessWidget {
  const SellerStatus({required this.isOpen, this.time = ""});

  final bool isOpen;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(curve15),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isOpen ? DESIGNER_OPEN_NOW.tr : DESIGNER_CLOSED_NOW.tr,
              style: TextStyle(
                  color: isOpen ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              time,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
