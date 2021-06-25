import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import '../../constants/server_urls.dart';
import '../../models/categorys.dart';
import '../../utils/tools.dart';
import '../shared/shared_styles.dart';

class CategoryTileUI extends StatelessWidget {
  final Category data;
  const CategoryTileUI({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = data.name ?? "";
    // String photoName = data.banner != null ? data.banner.name : "";
    bool isTablet = Tools.checkIfTablet(MediaQuery.of(context));
    // String bannerURL = '$CATEGORY_PHOTO_BASE_URL/${data.id}/$photoName';

    double titleFontSize = isTablet ? 28.0 : 20.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(curve15),
      ),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      color: Colors.grey,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.srcATop),
            child: FadeInImage.assetNetwork(
              fit: BoxFit.fill,
              fadeInCurve: Curves.easeIn,
              placeholder: 'assets/images/category_preloading.png',
              image: data?.id != null
                  ? '$CATEGORY_PHOTO_BASE_URL/${data.id}'
                  : 'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/category_preloading.png",
                  fit: BoxFit.fill),
            ),
          )),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Tools.getTruncatedString(20, name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

class HomeScreenCategoryTile extends StatelessWidget {
  final Category data;
  const HomeScreenCategoryTile({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = data.name ?? "";
    double titleFontSize = 10.0;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: logoRed,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                fit: BoxFit.fill,
                fadeInCurve: Curves.easeIn,
                placeholder: 'assets/images/category_preloading.png',
                image: data?.id != null
                    ? '$CATEGORY_PHOTO_BASE_URL/${data.id}'
                    : 'assets/images/category_preloading.png',
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/images/category_preloading.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        verticalSpaceTiny,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                Tools.getTruncatedString(20, name),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
