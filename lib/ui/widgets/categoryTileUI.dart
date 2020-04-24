import 'package:compound/models/categorys.dart';
import 'package:compound/ui/widgets/network_image_with_placeholder.dart';
import 'package:compound/utils/tools.dart';
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
    bool isTablet = Tools.checkIfTablet(MediaQuery.of(context));

    double titleFontSize = isTablet ? 24.0 : 20.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.grey,
      child: Stack(children: <Widget>[
        Positioned.fill(
            child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.srcATop),
          child: FadeInImage.assetNetwork(
              fit: BoxFit.fill,
              fadeInCurve: Curves.easeIn,
              placeholder: 'assets/images/placeholder.png',
              image:
                  // photoName == null?

                  'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
              // : photoName

              ),
        )),
        Positioned.fill(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Divider(
                color: Colors.white,
                height: 2,
              ),
              Text(getTruncatedString(20, name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600)),
              Divider(
                color: Colors.white,
                height: 2,
              ),
            ]))
      ]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 5,
    );

    // Card(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       NetworkImageWithPlaceholder(name: photoName),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             Text(getTruncatedString(20, name)),
    //             // Text('Ratings: ${productRatingValue.toString()}',
    //             //     style: TextStyle(color: Colors.grey, fontSize: 10.0)),
    //             // Row(
    //             //   children: <Widget>[
    //             //     Text('Rs.${productPrice.toString()}'),
    //             //     SizedBox(
    //             //       width: 5.0,
    //             //     ),
    //             //     // if (productOldPrice != 0.0)
    //             //     Text(
    //             //       'Rs.${productOldPrice.toString()}',
    //             //       style: TextStyle(
    //             //           color: Colors.grey,
    //             //           decoration: TextDecoration.lineThrough),
    //             //     ),
    //             //   ],
    //             // ),
    //             // Text('${productDiscount.toString()}%'),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
