import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  LinkWidget({Key key, this.name, this.linkType = LinkType.webLink, this.data}) : super(key: key);

  final LinkType linkType;
  final String name, data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom : 4.0),
      child: GestureDetector(
        onTap: () async {
          if(linkType == LinkType.webLink)
            return await launch(data);
          else if(linkType == LinkType.email)
            return await launch("mailto:$data");
          else if(linkType == LinkType.contactNo)
            return await launch("tel://$data");
        },
        child: Text(
          name,
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
      ),
    );
  }
}

enum LinkType {webLink, contactNo, email}
