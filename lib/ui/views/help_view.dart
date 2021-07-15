import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/server_urls.dart';
import '../shared/ui_helpers.dart';
import '../widgets/link_widget.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 16.0, bottom: 80.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Useful Links!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  LinkWidget(name: "Return Policy", data: RETURN_POLICY_URL),
                  LinkWidget(
                      name: "Terms and conditions",
                      data: TERMS_AND_CONDITIONS_URL),
                  verticalSpaceMedium,
                  Text("Email Us!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  LinkWidget(
                      name: SUPPORT_EMAIL,
                      linkType: LinkType.email,
                      data: 'mailto' + SUPPORT_EMAIL),
                  verticalSpaceMedium,
                  Text("Call Us!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  LinkWidget(
                      name: "8511465948",
                      linkType: LinkType.contactNo,
                      data: "8511465948"),
                  LinkWidget(
                      name: "9724518539",
                      linkType: LinkType.contactNo,
                      data: "9724518539"),
                  verticalSpaceMedium,
                  Text(
                    "We accept calls made between 10am and 6pm - Monday to Saturday.",
                    style: TextStyle(fontSize: titleFontSize),
                  ),
                  verticalSpaceSmall,
                  Text("We’ll be prompt to respond to your requests.",
                      style: TextStyle(fontSize: titleFontSize)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              tooltip: "Close",
              iconSize: 28,
              icon: Icon(CupertinoIcons.clear_circled_solid),
              color: Colors.grey[600],
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  "Help Desk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        primary: Color.fromRGBO(37, 211, 102, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async =>
                          await launch("https://wa.me/message/V4N3MEQB4BOHC1"),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                            ),
                            horizontalSpaceSmall,
                            Text(
                              "Chat With Us ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
