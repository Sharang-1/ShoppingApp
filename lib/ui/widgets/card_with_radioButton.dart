import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CardWithRadioButton extends StatefulWidget {
  final radioValue;
  final addressGrpValue;
  final address;
  final fullAddress;
  final Function setRadioValue;
  CardWithRadioButton(
      {this.address,
      this.addressGrpValue,
      this.fullAddress,
      this.radioValue,
      this.setRadioValue});

  @override
  _CardWithRadioButtonState createState() => _CardWithRadioButtonState();
}

class _CardWithRadioButtonState extends State<CardWithRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(curve15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: widget.radioValue,
              groupValue: widget.addressGrpValue,
              onChanged: (val) {
                widget.setRadioValue(val);
              },
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomText(
                  widget.address,
                  color: Colors.grey[700],
                  isBold: true,
                ),
                verticalSpaceTiny_0,
                CustomText(
                  widget.fullAddress,
                  color: Colors.grey,
                  fontSize: subtitleFontSizeStyle - 4,
                )
              ],
            )),
            // IconButton(
            //   icon: Icon(Icons.edit),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>
            //                 AddressInputPage()));
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
