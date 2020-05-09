import 'package:flutter/material.dart';
import 'package:compound/ui/shared/app_colors.dart';


class CutomStepper extends StatelessWidget {
  final int step;

  const CutomStepper({Key key, this.step}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Center(
            child: Text(
          "Address",
          style: TextStyle(fontSize: 18, color: textIconBlue),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: (MediaQuery.of(context).size.width - 100) * 0.5,
                    child: Divider(
                      thickness: 5,
                      color: step == 2 ? Colors.green : Colors.grey[300],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 100) * 0.5,
                    child: Divider(
                      thickness: 5,
                      color: step == 3 ? Colors.green : Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green),
              ),
              Center(
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: step == 2 ? Colors.green : Colors.grey[300],
                  ),
                ),
              ),
              Positioned(
                right: 1,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: step == 3 ? Colors.green : Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Cart",
              style: TextStyle(fontSize: 18, color: textIconBlue),
            ),
            Text(
              "Payment",
              style: TextStyle(fontSize: 18, color: textIconBlue),
            ),
          ],
        )
      ]),
    );
  }
}