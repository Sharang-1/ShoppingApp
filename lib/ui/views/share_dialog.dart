import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../shared/app_colors.dart';
import 'package:compound/ui/shared/shared_styles.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Enjoying Dzor, Share It With Your Best Friends",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: headingFont,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: (subtitleFontSizeStyle - 1),
            ),
          ),
          RaisedButton(
            onPressed: () async =>
                await Share.share("https://dzor.page.link/App"),
            child: Text(
              "Share",
              style: TextStyle(
                fontFamily: headingFont,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: (subtitleFontSizeStyle - 1),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: textIconOrange, width: 2)),
          ),
        ],
      ),
    );
  }
}
