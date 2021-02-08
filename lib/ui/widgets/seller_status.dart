import 'package:flutter/material.dart';
import 'package:compound/ui/shared/shared_styles.dart';

class SellerStatus extends StatelessWidget {
  const SellerStatus({this.isOpen, this.time = ""});

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
              isOpen ? "Open Now" : "Closed Now",
              style: TextStyle(
                  color: isOpen ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              time,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}