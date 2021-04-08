import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class HomeViewListHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function viewAll;

  HomeViewListHeader(
      {Key key, @required this.title, this.subTitle, this.viewAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: subtitleFontSizeStyle + 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (subTitle != null) verticalSpaceTiny,
                  if (subTitle != null)
                    Text(
                      subTitle,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: subtitleFontSizeStyle - 4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
          (viewAll == null)
              ? Container(
                  width: 25.0,
                )
              : InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0, left: 10.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: subtitleFontSize - 8,
                          fontWeight: FontWeight.bold,
                          color: textIconBlue,
                        ),
                      ),
                    ),
                  ),
                  onTap: viewAll,
                ),
        ],
      ),
    );
  }
}
