import 'package:compound/utils/lang/translation_keys.dart';
import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'package:get/get.dart';

class CutomStepper extends StatelessWidget {
  final int step;

  const CutomStepper({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 10,
                width: (MediaQuery.of(context).size.width - 60),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30)),
              ),
              Center(
                child: Container(
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  height: 5,
                  width: 5,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Positioned(
                left: 0,
                child: Container(
                  height: 10,
                  width: (MediaQuery.of(context).size.width - 60) *
                      (step == 1
                          ? 0.15
                          : step == 2
                              ? 0.52
                              : 1),
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [textIconOrange, logoRed]),
                      borderRadius: BorderRadius.circular(30)),
                ),
              )
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            verticalSpace(30),
            Positioned(
              left: 0,
              child: Text(
                BAG.tr,
                style: TextStyle(
                  fontSize: step == 1 ? 16 : 14,
                  fontWeight: step == 1 ? FontWeight.bold : FontWeight.normal,
                  color: step == 1 ? Colors.black : Colors.grey[400],
                ),
              ),
            ),
            Center(
              child: Text(
                DESIGNER_DETAILS_ADDRESS.tr,
                style: TextStyle(
                  fontSize: step == 2 ? 16 : 14,
                  fontWeight: step == 2 ? FontWeight.bold : FontWeight.normal,
                  color: step == 2 ? Colors.black : Colors.grey[400],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Text(
                PAYMENT.tr,
                style: TextStyle(
                  fontSize: step == 3 ? 16 : 14,
                  fontWeight: step == 3 ? FontWeight.bold : FontWeight.normal,
                  color: step == 3 ? Colors.black : Colors.grey[400],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
