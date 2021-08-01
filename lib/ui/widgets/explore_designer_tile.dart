import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/server_urls.dart';
import '../../models/sellers.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class ExploreDesignerTileUI extends StatelessWidget {
  final Seller data;

  const ExploreDesignerTileUI({
    Key key,
    @required this.data,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 5.0, color: Colors.grey[300]))),
      child: Column(
        children: <Widget>[
          ClipOval(
            child: CachedNetworkImage(
              width: 75,
              height: 75,
              fadeInCurve: Curves.easeIn,
              imageUrl: '$SELLER_PHOTO_BASE_URL/${data.key}',
              errorWidget: (context, error, stackTrace) => Container(
                width: 75,
                height: 75,
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    data?.name?.substring(0, 1)?.toUpperCase() ?? 'D',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
          verticalSpaceTiny,
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: CustomText(
                    data.name,
                    dotsAfterOverFlow: true,
                    fontSize: titleFontSize,
                  ),
                ),
                verticalSpace(2),
                Expanded(
                  child: CustomText(
                    data.establishmentType.name,
                    dotsAfterOverFlow: true,
                    fontSize: subtitleFontSize,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
