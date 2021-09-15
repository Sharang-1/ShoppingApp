import 'package:flutter/material.dart';

import '../../constants/server_urls.dart';
import '../../models/categorys.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';

class CategoryTileUI extends StatelessWidget {
  final Category data;
  const CategoryTileUI({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = data.name ?? "";
    bool isTablet = Tools.checkIfTablet(MediaQuery.of(context));

    double titleFontSize = isTablet ? 28.0 : 20.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
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
  }
}

class NewCategoryTile extends StatelessWidget {
  final Category data;
  final bool fromCategory;
  const NewCategoryTile({
    Key key,
    @required this.data,
    this.fromCategory = false,
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
            shape: BoxShape.circle,
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
