
import 'package:compound/models/categorys.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';

class CategoryTileUI extends StatelessWidget {
  final Category data;
  const CategoryTileUI({
    Key key,
    @required this.data,
  }) : super(key: key);

  String getTruncatedString(int length, String str) {
    return str.length <= length ? str : '${str.substring(0, length)}...';
  }

  @override
  Widget build(BuildContext context) {
    String name = data.name ?? "";
    String photoName = data.banner != null ? data.banner.originalName : "";

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NetworkImageWithPlaceholder(name: photoName),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(getTruncatedString(20, name)),
                // Text('Ratings: ${productRatingValue.toString()}',
                //     style: TextStyle(color: Colors.grey, fontSize: 10.0)),
                // Row(
                //   children: <Widget>[
                //     Text('Rs.${productPrice.toString()}'),
                //     SizedBox(
                //       width: 5.0,
                //     ),
                //     // if (productOldPrice != 0.0)
                //     Text(
                //       'Rs.${productOldPrice.toString()}',
                //       style: TextStyle(
                //           color: Colors.grey,
                //           decoration: TextDecoration.lineThrough),
                //     ),
                //   ],
                // ),
                // Text('${productDiscount.toString()}%'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
