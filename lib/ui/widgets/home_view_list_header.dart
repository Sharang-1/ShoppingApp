import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class HomeViewListHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function viewAll;
  final EdgeInsets padding;

  HomeViewListHeader(
      {Key key,
      @required this.title,
      this.subTitle,
      this.viewAll,
      this.padding})
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
              padding: padding ?? const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey[800],
                        letterSpacing: 1.0,
                        fontSize: titleFontSizeStyle,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  // if (subTitle != null && subTitle.isNotEmpty)
                  //   verticalSpaceTiny,
                  if (subTitle != null && subTitle.isNotEmpty)
                    Text(
                      subTitle,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: subtitleFontSizeStyle,
                        fontWeight: FontWeight.w300,
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
                          fontSize: 12,
                          color: textIconBlue,
                          decoration: TextDecoration.underline,
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
