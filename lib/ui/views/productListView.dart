// import 'package:fimber/fimber_base.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

import '../../constants/dynamic_links.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/reviews_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/products.dart';
import '../../models/reviews.dart';
import '../../services/api/api_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../ui/widgets/custom_text.dart';
import '../../ui/widgets/reviews.dart';
import '../../ui/widgets/writeReview.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/product_filter_dialog.dart';
import '../widgets/product_tile_ui.dart';

class ProductListView extends StatefulWidget {
  final String queryString;
  final String subCategory;
  final String sellerPhoto;

  ProductListView({
    Key key,
    @required this.queryString,
    @required this.subCategory,
    this.sellerPhoto,
  }) : super(key: key);

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  ProductFilter filter;
  String sellerKey;
  Reviews reviews;
  bool showRandomProducts = true;
  UniqueKey key = UniqueKey();
  final refreshController = RefreshController(initialRefresh: false);
  DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();

  Color getColorAccordingToRattings(num rattings) {
    switch (rattings) {
      case 5:
        return Color.fromRGBO(0, 100, 0, 1);
      case 4:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 2:
        return Colors.orange;
      default:
        return logoRed;
    }
  }

  void showReviewBottomsheet() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        context: context,
        builder: (context) {
          // double selectedRating;
          // final textController = TextEditingController();

          UniqueKey reviewsKey = UniqueKey();
          UniqueKey writeReviewKey = UniqueKey();

          return GetBuilder<ReviewsController>(
            init: ReviewsController(id: sellerKey, isSeller: true),
            builder: (controller) => SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.height / 1.5),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ReviewWidget(
                          key: reviewsKey,
                          id: sellerKey,
                          isSeller: true,
                          expanded: true,
                        ),

                        FutureBuilder<bool>(
                          key: writeReviewKey,
                          future: locator<APIService>()
                              .hasReviewed(sellerKey, isSeller: true),
                          builder: (context, snapshot) =>
                              ((snapshot.connectionState ==
                                          ConnectionState.done) &&
                                      !snapshot.data)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: WriteReviewWidget(
                                        sellerKey,
                                        isSeller: true,
                                        fromProductList: true,
                                        onSubmit: () {
                                          reviewsKey = UniqueKey();
                                          writeReviewKey = UniqueKey();
                                        },
                                      ),
                                    )
                                  : Container(),
                        ),

                        // Container(
                        //   child: Card(
                        //     elevation: 5,
                        //     clipBehavior: Clip.antiAlias,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(curve15),
                        //     ),
                        //     child: Container(
                        //       height: 202,
                        //       color: Colors.white,
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(16.0),
                        //         child: Column(
                        //           children: <Widget>[
                        //             Padding(
                        //               padding: const EdgeInsets.only(
                        //                   left: 8.0, right: 8.0),
                        //               child: InputField(
                        //                 controller: textController,
                        //                 placeholder: 'Write a Review',
                        //               ),
                        //             ),
                        //             RatingBar.builder(
                        //               initialRating: 0,
                        //               direction: Axis.horizontal,
                        //               allowHalfRating: true,
                        //               itemCount: 5,
                        //               itemPadding:
                        //                   EdgeInsets.symmetric(horizontal: 4.0),
                        //               unratedColor: Colors.grey[400],
                        //               itemBuilder: (context, _) => Icon(
                        //                 Icons.star,
                        //                 color: Colors.amber,
                        //               ),
                        //               onRatingUpdate: (rating) {
                        //                 selectedRating = rating;
                        //               },
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.only(top: 16.0),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: <Widget>[
                        //                   new TextButton(
                        //                     style: TextButton.styleFrom(
                        //                       shape: RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(30),
                        //                       ),
                        //                       backgroundColor: logoRed,
                        //                     ),
                        //                     child: new CustomText(
                        //                       "Submit",
                        //                       color: Colors.white,
                        //                     ),
                        //                     onPressed: () async {
                        //                       await controller.writeReiew(
                        //                         sellerKey,
                        //                         selectedRating,
                        //                         textController.text,
                        //                         isSellerReview: true,
                        //                       );
                        //                       textController.text = "";
                        //                     },
                        //                   ),
                        //                   SizedBox(
                        //                     width: 15,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    filter = ProductFilter(existingQueryString: widget.queryString);
    sellerKey = widget?.queryString?.split('=')?.last?.replaceAll(';', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        // title: SvgPicture.asset(
        //   "assets/svg/logo.svg",
        //   color: logoRed,
        //   height: 35,
        //   width: 35,
        // ),
        actions: [
          IconButton(
            icon:
                Icon(FontAwesomeIcons.slidersH, color: Colors.black, size: 20),
            padding: EdgeInsets.all(8.0),
            onPressed: () async {
              ProductFilter filterDialogResponse = await showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                isScrollControlled: true,
                clipBehavior: Clip.antiAlias,
                context: context,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                      heightFactor: 0.75,
                      child: ProductFilterDialog(
                        oldFilter: filter,
                      ));
                },
              );

              if (filterDialogResponse != null) {
                setState(() {
                  showRandomProducts = false;
                  filter = filterDialogResponse;
                  key = UniqueKey();
                });
              }
            },
          ),
          if (!(widget.queryString.isEmpty && widget.subCategory.isEmpty))
            InkWell(
              onTap: () async {
                await Share.share(
                  await _dynamicLinkService.createLink(sellerLink + sellerKey),
                  sharePositionOrigin: Rect.fromCenter(
                    center: Offset(100, 100),
                    width: 100,
                    height: 100,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Platform.isIOS ? CupertinoIcons.share : Icons.share,
                  size: 25,
                ),
              ),
            ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      floatingActionButton: (widget.sellerPhoto != null)
          ? FloatingActionButton.extended(
              label: Text(
                'Reviews',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: showReviewBottomsheet,
              backgroundColor: logoRed,
            )
          : null,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: false,
        child: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            waterDropColor: logoRed,
            refresh: Center(
              child: CircularProgressIndicator(),
            ),
            complete: Container(),
          ),
          controller: refreshController,
          onRefresh: () async {
            setState(() {
              key = new UniqueKey();
            });
            refreshController.refreshCompleted(resetFooterState: true);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.queryString.isNotEmpty ||
                    widget.subCategory.isNotEmpty)
                  verticalSpace(20),
                if ((widget.queryString.isNotEmpty ||
                        widget.subCategory.isNotEmpty) &&
                    widget.sellerPhoto == null)
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screenPadding,
                              right: screenPadding - 5,
                              top: 10,
                              bottom: 10,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.subCategory,
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: headingFont,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.sellerPhoto != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(right: 6.0),
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            width: 80,
                            height: 80,
                            fadeInCurve: Curves.easeIn,
                            placeholder: "assets/images/product_preloading.png",
                            image: widget.sellerPhoto,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              "assets/images/product_preloading.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 0.1),
                            width: 8.0,
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      Text(
                        widget.subCategory,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: headingFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      verticalSpaceSmall,
                      FutureBuilder<Reviews>(
                        future: reviews == null
                            ? locator<APIService>().getReviews(
                                sellerKey,
                                isSellerReview: true,
                              )
                            : Future.value(reviews),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) reviews = snapshot.data;

                          return ((snapshot.connectionState ==
                                      ConnectionState.done) &&
                                  ((snapshot?.data?.ratingAverage?.rating ??
                                          0) >
                                      0))
                              ? InkWell(
                                  onTap: showReviewBottomsheet,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: newBackgroundColor,
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ),
                                        border: Border.all(
                                          color: getColorAccordingToRattings(
                                            snapshot.data.ratingAverage.rating,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CustomText(
                                            snapshot.data.ratingAverage.rating
                                                .toStringAsFixed(1),
                                            color: getColorAccordingToRattings(
                                              snapshot
                                                  .data.ratingAverage.rating,
                                            ),
                                            isBold: true,
                                            fontSize: 15,
                                          ),
                                          // horizontalSpaceTiny,
                                          // Icon(
                                          //   Icons.star,
                                          //   color: Colors.white,
                                          //   size: 15,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ],
                  ),
                verticalSpace(20),
                FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: 500)),
                  builder: (c, s) => s.connectionState == ConnectionState.done
                      ? GridListWidget<Products, Product>(
                          key: key,
                          context: context,
                          filter: filter,
                          gridCount: 2,
                          emptyListWidget: EmptyListWidget(text: ""),
                          controller: ProductsGridViewBuilderController(
                            limit: (widget.queryString.isEmpty &&
                                    widget.subCategory.isEmpty)
                                ? 50
                                : 1000,
                            randomize: showRandomProducts,
                          ),
                          childAspectRatio: 0.7,
                          tileBuilder: (BuildContext context, data, index,
                              onUpdate, onDelete) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey[300],
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                              child: ProductTileUI(
                                data: data,
                                cardPadding: EdgeInsets.zero,
                                onClick: () =>
                                    BaseController.goToProductPage(data),
                                index: index,
                              ),
                            );
                          },
                        )
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
