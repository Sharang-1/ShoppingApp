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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
          child: Stack(
            children: <Widget>[
              Container(
                height: 10,
                width: (MediaQuery.of(context).size.width - 60),
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30)),
              ),
              Container(
                height: 10,
                width: (MediaQuery.of(context).size.width - 60) * (step == 1 ? 0.15 : step ==2 ? 0.45 : 1),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [lightRedSmooth, darkRedSmooth, logoRed]),
                    borderRadius: BorderRadius.circular(30)),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Cart",
              style: TextStyle(fontSize: 17,fontWeight: step==1 ? FontWeight.bold : FontWeight.normal, 
              color: step ==1 ? textIconBlue : Colors.grey[400] ,
              ),
            ),
            Center(
                child: Text(
              "Address",
              style: TextStyle(fontSize: 17,fontWeight: step==2 ? FontWeight.bold : FontWeight.normal, color: step ==2 ? textIconBlue : Colors.grey[400] ,),
            )),
            Text(
              "Payment",
              style: TextStyle(fontSize: 17,fontWeight: step==3 ? FontWeight.bold : FontWeight.normal, color: step ==3 ? textIconBlue : Colors.grey[400] ,),
            ),
          ],
        )
      ]),
    );
  }
}
