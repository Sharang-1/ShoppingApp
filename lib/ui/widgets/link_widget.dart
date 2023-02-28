import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../shared/ui_helpers.dart';

class LinkWidget extends StatelessWidget {
  LinkWidget(
      {Key? key,
      required this.name,
      this.linkType = LinkType.webLink,
      required this.data})
      : super(key: key);

  final LinkType linkType;
  final String name, data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: GestureDetector(
        onTap: () async {
          if (linkType == LinkType.webLink)
            await launchUrlString(data);
          else if (linkType == LinkType.email)
            await launchUrlString("mailto:$data");
          else if (linkType == LinkType.contactNo)
            await launchUrlString("tel://$data");
        },
        child: Text(
          name,
          style: TextStyle(color: Colors.blue, fontSize: titleFontSize + 2),
        ),
      ),
    );
  }
}

enum LinkType { webLink, contactNo, email }
