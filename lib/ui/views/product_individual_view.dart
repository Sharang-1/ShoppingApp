import 'package:compound/services/cart_local_store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../constants/shared_pref.dart';
import '../../controllers/base_controller.dart';
import '../../controllers/cart_count_controller.dart';
import '../../controllers/grid_view_builder/products_grid_view_builder_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/product_controller.dart';
import '../../locator.dart';
import '../../models/grid_view_builder_filter_models/productFilter.dart';
import '../../models/lookups.dart';
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/reviews.dart';
import '../../services/api/api_service.dart';
import '../../services/dialog_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/error_handling_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/stringUtils.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/home_view_slider.dart';
import '../widgets/cart_icon_badge.dart';
import '../widgets/custom_text.dart';
import '../widgets/reviews.dart';
import '../widgets/section_builder.dart';
import '../widgets/wishlist_icon.dart';
import 'cart_view.dart';
import 'gallery_view.dart';

const weekday = [
  "Monday",
  "Tuesday",
  "wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

var month = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

const Map<int, String> workOnMap = {
  -1: "N/A",
  1: "Sleeve",
  2: "Neck",
  3: "Throughout the Kurta",
  4: "Throughout the Blouse",
  5: "Throughout the Dress",
  6: "Throughout the Suit",
  7: "Throughout the Gown",
  8: "Borders and throughout the Dupatta",
  9: "Throughout the Dupatta",
  10: "Borders",
  11: "Buttas throughout the Saree",
  12: "Borders and Buttas throughout the Saree",
};

class ProductIndiView extends StatefulWidget {
  final Product data;
  final bool fromCart;
  const ProductIndiView({Key key, @required this.data, this.fromCart = false})
      : super(key: key);
  @override
  _ProductIndiViewState createState() => _ProductIndiViewState();
}

class _ProductIndiViewState extends State<ProductIndiView> {
  final refreshController = RefreshController(initialRefresh: false);
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();
  ScrollController _scrollController;

  UniqueKey key = UniqueKey();
  GlobalKey variationSelectionCardKey = GlobalKey();

  int selectedQty = 0;
  int selectedIndex = -1;
  int maxQty = -1;
  String selectedSize = "";
  String selectedColor = "";
  bool disabledAddToCartBtn = false;
  Product productData;
  bool showMoreFromDesigner = true;
  num deliveryCharges = 35.4;
  String productName;
  String productId;
  double productDiscount;
  int productPrice;
  int saved;
  List<Variation> variations;
  String date;
  Key uniqueKey;
  Key photosKey;
  DateTime dateParse;
  DateTime newDate;
  String formattedDate;
  String shipment;
  int totalQuantity;
  bool available;
  List<String> imageURLs;
  double height = 100;

  bool showHeader = false;

  GlobalKey cartKey = GlobalKey();

  _showDialog(context, sellerId, cid) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: [
            "${BASE_URL}sellers/$sellerId/categories/$cid/sizechart"
          ],
          scrollDirection: Axis.horizontal,
          initialIndex: 0,
          showImageLabel: false,
          loadingBuilder: (context, e) => Center(
            child: CircularProgressIndicator(),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.white),
          appbarColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> goToSellerProfile(controller) async {
    if (locator<HomeController>().isLoggedIn) {
      if (controller?.sellerDetail?.subscriptionTypeId == 2) {
        await NavigationService.to(
          ProductsListRoute,
          arguments: ProductPageArg(
            subCategory: controller?.sellerDetail?.name,
            queryString: "accountKey=${controller?.sellerDetail?.key};",
            sellerPhoto:
                "$SELLER_PHOTO_BASE_URL/${controller?.sellerDetail?.key}",
          ),
        );
      } else {
        await NavigationService.to(SellerIndiViewRoute,
            arguments: controller?.sellerDetail);
      }
    } else {
      await BaseController.showLoginPopup(
        nextView: SellerIndiViewRoute,
        shouldNavigateToNextScreen: false,
        // arguments: data,
      );
    }
  }

  Widget productPriceInfo({
    productName,
    designerName,
    productPrice,
    actualPrice,
    bool showPrice = true,
    bool isClothMeterial = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                capitalizeString(productName.toString()),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: headingFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              child: Text(
                "By " + designerName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              // onTap: () async => await goToSellerProfile(controller),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (isClothMeterial)
            //   Text(
            //     'Price per Meter',
            //     style: TextStyle(
            //       fontSize: subtitleFontSizeStyle - 3,
            //       color: Colors.black54,
            //     ),
            //   ),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        if (productDiscount != 0.0 && showPrice)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${BaseController.formatPrice(actualPrice)}',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (available)
                          Text(
                            '${showPrice ? BaseController.formatPrice(productPrice) : ' - '}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: lightGreen,
                            ),
                          )
                        else
                          Text(
                            "Unavailable",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: logoRed,
                            ),
                          ),
                      ],
                    ),
                    if (available)
                      Text(
                        "(Inclusive of taxes and charges)",
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> choiceChips(variations) {
    List<Widget> allChips = [];
    List<String> sizes = [];
    // List jsonParsed = json.decode(variations.toString());
    for (int i = 0; i < variations.length; i++) {
      if (!sizes.contains(variations[i].size) &&
          (variations[i].quantity != 0)) {
        allChips.add(ChoiceChip(
          backgroundColor: Colors.white,
          selectedShadowColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: selectedSize == variations[i].size
                    ? darkRedSmooth
                    : Colors.grey,
                width: 0.5,
              )),
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: selectedSize == variations[i].size
                ? FontWeight.w600
                : FontWeight.normal,
            color: selectedSize == variations[i].size
                ? darkRedSmooth
                : Colors.grey,
          ),
          selectedColor: Colors.white,
          label: Text(variations[i].size),
          selected: selectedSize == variations[i].size,
          onSelected: (val) {
            setState(() => {
                  selectedSize = variations[i].size,
                  selectedIndex = i,
                  selectedQty = 0
                });
          },
        ));
        sizes.add(variations[i].size);
      }
    }
    return allChips;
  }

  Wrap allSizes(variations) {
    // print("check this "+variations[0].size);
    if (variations[0].size == "N/A") {
      // print("cond true");
      selectedSize = "N/A";
      selectedIndex = 0;
      return Wrap(
        spacing: 8,
        children: [],
      );
    } else {
      return Wrap(
        spacing: 8,
        children: choiceChips(variations),
      );
    }
  }

  Wrap allColors(colors) {
    List<Widget> allColorChips = [];
    var uniqueColor = new Map();
    for (var color in colors) {
      print("check this" +
          (uniqueColor.containsKey(color.color)).toString() +
          color.color);
      if (selectedSize != color.size) {
        continue;
      }
      if (!uniqueColor.containsKey(color.color)) {
        uniqueColor[color.color] = true;
      } else {
        continue;
      }
      allColorChips.add(ChoiceChip(
        backgroundColor: Colors.white,
        selectedShadowColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: selectedColor == color ? darkRedSmooth : Colors.grey,
              width: 0.5,
            )),
        labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: selectedColor == color.color
                ? FontWeight.w600
                : FontWeight.normal,
            color: selectedColor == color.color ? darkRedSmooth : Colors.grey),
        selectedColor: Colors.white,
        label: Text(color.color),
        selected: selectedColor == color.color,
        onSelected: (val) {
          setState(() => {
                selectedColor = color.color,
                maxQty = color.quantity,
                selectedQty = 0
              });
        },
      ));
    }
    return Wrap(
      spacing: 8,
      children: allColorChips,
    );
  }

  // Color _colorFromHex(String hexColor) {
  //   final hexCode = hexColor.replaceAll('#', '');
  //   return Color(int.parse('FF$hexCode', radix: 16));
  // }

  Widget allTags(tags) {
    var alltags = "";
    for (var item in tags) {
      alltags += "#" + item + "  ";
    }
    return Text(
      alltags,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget paddingWidget(Widget item) {
    return Padding(child: item, padding: EdgeInsets.fromLTRB(0, 10, 0, 0));
  }

  // FittedBox stockWidget({int totalQuantity, bool available}) {
  //   String text = (totalQuantity == 0)
  //       ? "Sold Out! \nYou can check back in few days!"
  //       : (available)
  //           ? (totalQuantity == 2)
  //               ? "Only 2 left"
  //               : (totalQuantity == 1)
  //                   ? "One in Market Product"
  //                   : "In Stock"
  //           : "The product is unavailable right now, check back in few days";

  //   return FittedBox(
  //     alignment: Alignment.centerLeft,
  //     fit: BoxFit.scaleDown,
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //           fontSize: titleFontSizeStyle - 2,
  //           color: (available) ? green : logoRed,
  //           fontWeight: FontWeight.w600),
  //     ),
  //   );
  // }

  int calculateSavedCost(Cost cost) {
    double actualCost =
        (cost.cost + cost.convenienceCharges.cost + cost.gstCharges.cost);
    return (actualCost - cost.costToCustomer).round();
  }

  void setupProductDetails(Product data) {
    productData = data;
    productName = data?.name ?? "Test Product";
    productId = data?.key;
    productDiscount = data?.cost?.productDiscount?.rate ?? 0.0;
    productPrice = (data.cost.costToCustomer + deliveryCharges).round() ?? 0.0;
    saved = calculateSavedCost(data?.cost);
    variations = data?.variations ?? null;

    date = DateTime.now().toString();
    uniqueKey = UniqueKey();
    dateParse = DateTime.parse(date);
    newDate = new DateTime(
        dateParse.year,
        dateParse.month,
        dateParse.day +
            (data?.shipment?.days == null
                ? 0
                // ignore: null_aware_before_operator
                : data?.shipment?.days + 1));
    dateParse = DateTime.parse(newDate.toString());
    formattedDate =
        "${weekday[dateParse.weekday - 1]} , ${dateParse.day} ${month[dateParse.month - 1]}";
    shipment = data?.shipment?.days == null ? "Not Availabel" : formattedDate;
    totalQuantity = 0;
    variations.forEach((variation) {
      totalQuantity += variation.quantity.toInt();
    });
    available = (totalQuantity == 0) ? false : (data?.available ?? false);

    imageURLs = (data?.photo?.photos ?? <PhotoElement>[])
        .map((e) => '$PRODUCT_PHOTO_BASE_URL/$productId/${e.name}')
        .toList();
    // imageURLs.add(
    //   "${BASE_URL}sellers/${data.account.key}/categories/${data.category.id}/sizechart",
    // );
    photosKey = GlobalKey();
    uniqueKey = UniqueKey();
  }

  void showTutorial(BuildContext context,
      {GlobalKey photosKey, GlobalKey cartKey}) {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs?.getBool(cartKey == null
              ? ShouldShowProductPageTutorial
              : ShouldShowCartTutorial) ??
          true) {
        TutorialCoachMark tutorialCoachMark;
        List<TargetFocus> targets = <TargetFocus>[
          if (photosKey != null)
            TargetFocus(
              identify: "Photos",
              keyTarget: photosKey,
              shape: ShapeLightFocus.RRect,
              contents: [
                TargetContent(
                  align: ContentAlign.bottom,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Tap on Image to zoom it.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'assets/images/finger_tap.png',
                            height: 150,
                            width: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (cartKey != null)
            TargetFocus(
              identify: "Cart Target",
              keyTarget: cartKey,
              contents: [
                TargetContent(
                  align: ContentAlign.bottom,
                  child: Container(
                    child: Text(
                      "Tap on Bag to view Items.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ];
        tutorialCoachMark = TutorialCoachMark(
          context,
          targets: targets,
          colorShadow: Colors.black45,
          paddingFocus: 5,
          onClickOverlay: (targetFocus) => tutorialCoachMark.next(),
          onClickTarget: (targetFocus) => tutorialCoachMark.next(),
          onFinish: () async => await prefs?.setBool(
              cartKey == null
                  ? ShouldShowProductPageTutorial
                  : ShouldShowCartTutorial,
              false),
        )..show();
      }
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > Get.width) {
        if (!showHeader)
          setState(() {
            showHeader = true;
          });
      } else {
        if (showHeader)
          setState(() {
            showHeader = false;
          });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        init: ProductController(
          widget.data?.account?.key,
          productId: widget?.data?.key,
          productName: widget?.data?.name,
        )..init(),
        initState: (state) {
          setupProductDetails(widget?.data);
          showTutorial(context, photosKey: photosKey);
        },
        builder: (controller) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            bottom: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SmartRefresher(
                  enablePullDown: true,
                  footer: null,
                  header: WaterDropHeader(
                    waterDropColor: logoRed,
                    refresh: Center(
                      child: CircularProgressIndicator(),
                    ),
                    complete: Container(),
                  ),
                  controller: refreshController,
                  onRefresh: () async {
                    Product product =
                        await controller.refreshProduct(productData.key);
                    setState(() {
                      setupProductDetails(product);
                    });
                    await Future.delayed(Duration(milliseconds: 100));
                    refreshController.refreshCompleted();
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            HomeSlider(
                              key: photosKey,
                              imgList: imageURLs,
                              sizeChartUrl:
                                  "${BASE_URL}sellers/${productData.account.key}/categories/${productData.category.id}/sizechart",
                              videoList: productData?.video?.videos
                                      ?.map((e) =>
                                          "${BASE_URL}products/${productData.key}/videos/${e.name}")
                                      ?.toList() ??
                                  [],
                              aspectRatio: 1,
                              fromProduct: true,
                            ),
                            if ((productData?.discount ?? 0.0) != 0.0)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: logoRed,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        productData.discount
                                                .round()
                                                .toString() +
                                            "%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: subtitleFontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () => NavigationService.back(),
                                ),
                              ),
                            Positioned(
                              bottom: 32,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: InkWell(
                                        onTap: () async =>
                                            locator<HomeController>().isLoggedIn
                                                ? controller
                                                    .onWishlistBtnClicked(
                                                        productId)
                                                : await BaseController
                                                    .showLoginPopup(
                                                    nextView: WishListRoute,
                                                    shouldNavigateToNextScreen:
                                                        true,
                                                  ),
                                        child: WishListIcon(
                                          filled:
                                              controller.isWishlistIconFilled,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    horizontalSpaceSmall,
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await Share.share(
                                            await _dynamicLinkService
                                                .createLink(
                                                    productLink + productId),
                                          );
                                          await controller.shareProductEvent(
                                              productId: productId,
                                              productName: productName);
                                        },
                                        child: Image.asset(
                                          "assets/images/share_icon.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              productPriceInfo(
                                productName: productData.name,
                                designerName: productData.seller.name,
                                productPrice: productPrice,
                                actualPrice: (productData.cost.cost +
                                        productData
                                            .cost.convenienceCharges.cost +
                                        productData.cost.gstCharges.cost +
                                        deliveryCharges)
                                    .round(),
                                showPrice: (available),
                                isClothMeterial:
                                    (productData.category.id == 13),
                              ),
                              if (productData.coupons.isNotEmpty)
                                sectionDivider(),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: productData.coupons
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              await Get.bottomSheet(
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 16.0,
                                                    horizontal: 8.0,
                                                  ),
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Coupon",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: logoRed,
                                                        ),
                                                      ),
                                                      verticalSpaceSmall,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: logoRed,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                5,
                                                              ),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical: 4.0,
                                                              horizontal: 8.0,
                                                            ),
                                                            child: Text(
                                                              e.code
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.white,
                                                              elevation: 0,
                                                            ),
                                                            child: Text(
                                                              "COPY",
                                                              style: TextStyle(
                                                                color: logoRed,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await Clipboard
                                                                  .setData(
                                                                ClipboardData(
                                                                  text: e.code,
                                                                ),
                                                              );

                                                              Get.snackbar(
                                                                "Coupon Code Copied",
                                                                "Use this code while placing order.",
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      verticalSpaceSmall,
                                                      Text(
                                                        "Get FLAT Rs. ${e.discount} off",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      verticalSpaceMedium,
                                                      Center(
                                                        child: Divider(
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                                      verticalSpaceTiny,
                                                      Text(
                                                        "Use Code ${e.code.toUpperCase()} and get FLAT Rs. ${e.discount} off on order above Rs.${e.minimumOrderValue}. No Upper Limit.",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // isScrollControlled: true,
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(8.0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: logoRed,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                e.name,
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: logoRed,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()),
                              ),
                              sectionDivider(),
                              if (available)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      selectedSize == "N/A"
                                          ? verticalSpace(0)
                                          : Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    "Select Size".toUpperCase(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    _showDialog(
                                                        context,
                                                        controller
                                                            .sellerDetail?.key,
                                                        productData?.category
                                                                ?.id ??
                                                            1);
                                                  },
                                                  child: Text(
                                                    "size chart",
                                                    style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                      verticalSpaceTiny,
                                      allSizes(variations),
                                      selectedSize == ""
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                selectedSize == "N/A"
                                                    ? verticalSpace(0)
                                                    : elementDivider(),
                                                Text(
                                                  "Select Color".toUpperCase(),
                                                  style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                verticalSpace(5),
                                                allColors(
                                                  variations,
                                                ),
                                              ],
                                            ),
                                      selectedColor == ""
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                elementDivider(),
                                                Text(
                                                  "Select ${(productData.category.id == 13) ? 'No. of Meters' : 'Qty'}"
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    // fontWeight:
                                                    //     FontWeight.bold,
                                                    fontSize: 14,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                verticalSpaceSmall,
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Container(
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: darkRedSmooth,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      4.0),
                                                          color: selectedQty ==
                                                                  0
                                                              ? Colors.grey
                                                              : darkRedSmooth,
                                                          iconSize: 18,
                                                          icon: Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            if (selectedQty !=
                                                                0) {
                                                              setState(() {
                                                                selectedQty =
                                                                    selectedQty -
                                                                        1;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        Text(
                                                          selectedQty
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  darkRedSmooth,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      4.0),
                                                          iconSize: 18,
                                                          color: maxQty ==
                                                                  selectedQty
                                                              ? Colors.grey
                                                              : darkRedSmooth,
                                                          icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            print("maxQty" +
                                                                maxQty
                                                                    .toString());
                                                            if (maxQty !=
                                                                selectedQty) {
                                                              setState(() {
                                                                selectedQty =
                                                                    selectedQty +
                                                                        1;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      verticalSpaceTiny,
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "*Please select size, color, quantity carefully by referring to the size chart.",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    subtitleFontSizeStyle - 2,
                                              ),
                                            ),
                                            verticalSpaceTiny,
                                            GestureDetector(
                                              onTap: () async {
                                                if (await canLaunch(
                                                    RETURN_POLICY_URL))
                                                  await launch(
                                                      RETURN_POLICY_URL);
                                              },
                                              child: Text(
                                                "Return Policy",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        subtitleFontSizeStyle -
                                                            2,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              elementDivider(),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    "#JustHere",
                                    if (totalQuantity != 0) "In Stock",
                                    if ((productData?.stitchingType?.id ??
                                            -1) ==
                                        2)
                                      "Unstitched",
                                    if (productData.whoMadeIt.id == 2)
                                      "Hand-Crafted",
                                    if (totalQuantity == 1)
                                      "One in Market Product",
                                    if (!available) "Unavailable",
                                  ]
                                      .map(
                                        (e) => Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                color: e == "In Stock"
                                                    ? lightGreen
                                                    : Colors.grey),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              if (available) sectionDivider(),
                              if (available)
                                Text(
                                  "Delivery By : $shipment",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              // if (available) sectionDivider(),
                              sectionDivider(),
                              Text(
                                "Know Your Designer".toUpperCase(),
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  fontSize: 14,
                                ),
                              ),
                              if (controller
                                      ?.sellerDetail?.subscriptionTypeId !=
                                  2)
                                verticalSpace(5),
                              GestureDetector(
                                onTap: () async =>
                                    await goToSellerProfile(controller),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.black38,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    width: 50,
                                                    height: 50,
                                                    fadeInCurve: Curves.easeIn,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        "assets/images/product_preloading.png",
                                                    image: controller
                                                                .sellerDetail
                                                                ?.key !=
                                                            null
                                                        ? "$SELLER_PHOTO_BASE_URL/${controller.sellerDetail.key}"
                                                        : "assets/images/product_preloading.png",
                                                    imageErrorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Image.asset(
                                                      "assets/images/product_preloading.png",
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              horizontalSpaceSmall,
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            controller
                                                                    .sellerDetail
                                                                    ?.name ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          FutureBuilder<
                                                              Reviews>(
                                                            future: locator<
                                                                    APIService>()
                                                                .getReviews(
                                                                    controller
                                                                        .sellerDetail
                                                                        ?.key,
                                                                    isSellerReview:
                                                                        true),
                                                            builder: (context,
                                                                    snapshot) =>
                                                                ((snapshot.connectionState ==
                                                                            ConnectionState
                                                                                .done) &&
                                                                        ((snapshot?.data?.ratingAverage?.rating ??
                                                                                0) >
                                                                            0))
                                                                    ? FittedBox(
                                                                        fit: BoxFit
                                                                            .scaleDown,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            vertical:
                                                                                2,
                                                                            horizontal:
                                                                                5,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Tools.getColorAccordingToRattings(
                                                                                snapshot.data.ratingAverage.rating,
                                                                              ),
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              CustomText(
                                                                                snapshot.data.ratingAverage.rating.toString(),
                                                                                color: Tools.getColorAccordingToRattings(
                                                                                  snapshot.data.ratingAverage.rating,
                                                                                ),
                                                                                isBold: true,
                                                                                fontSize: 12,
                                                                              ),
                                                                              horizontalSpaceTiny,
                                                                              Icon(
                                                                                Icons.star,
                                                                                color: Tools.getColorAccordingToRattings(
                                                                                  snapshot.data.ratingAverage.rating,
                                                                                ),
                                                                                size: 12,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                          ),
                                                        ],
                                                      ),
                                                      if (controller
                                                              ?.sellerDetail
                                                              ?.subscriptionTypeId !=
                                                          2)
                                                        Text(
                                                          Tools
                                                              .getTruncatedString(
                                                            100,
                                                            controller
                                                                    .sellerDetail
                                                                    ?.name ??
                                                                "",
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.navigate_next,
                                          color: lightGrey,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              sectionDivider(),
                              ReviewWidget(
                                id: productId,
                              ),
                              sectionDivider(),
                              Text(
                                "Item Details".toUpperCase(),
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.0),
                              ),
                              verticalSpace(5),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Description',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            verticalSpaceTiny,
                                            Text(
                                              productData?.description ?? "",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey.withOpacity(0.5),
                                          height: 1),
                                      ProductDescriptionTable(
                                          product: productData,
                                          controller: controller),
                                    ],
                                  ),
                                ),
                              ),
                              sectionDivider(),
                              Text(
                                "Recommended Products".toUpperCase(),
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              verticalSpace(5),
                              SectionBuilder(
                                key: uniqueKey ?? UniqueKey(),
                                context: context,
                                filter: ProductFilter(
                                    existingQueryString:
                                        "subCategory=${productData?.category?.id ?? -1};"),
                                layoutType: LayoutType.PRODUCT_LAYOUT_2,
                                controller: ProductsGridViewBuilderController(
                                  filteredProductKey: productData?.key,
                                  randomize: true,
                                ),
                                scrollDirection: Axis.horizontal,
                              ),
                              if (showMoreFromDesigner) sectionDivider(),
                              if (showMoreFromDesigner)
                                Text(
                                  "More From Designer".toUpperCase(),
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              if (showMoreFromDesigner) verticalSpace(5),
                              if (showMoreFromDesigner)
                                SectionBuilder(
                                  key: uniqueKey ?? UniqueKey(),
                                  context: context,
                                  filter: ProductFilter(
                                      existingQueryString: productData
                                                  ?.account?.key !=
                                              null
                                          ? "accountKey=${productData?.account?.key};"
                                          : ""),
                                  layoutType: LayoutType.PRODUCT_LAYOUT_2,
                                  controller: ProductsGridViewBuilderController(
                                    filteredProductKey: productData?.key,
                                    randomize: true,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  onEmptyList: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 500),
                                        () => setState(() {
                                              showMoreFromDesigner = false;
                                            }));
                                  },
                                ),
                              verticalSpaceLarge,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showHeader,
                  child: Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: AppBar(
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.black),
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomText(
                          "${productData?.name?.capitalizeFirst ?? ''}",
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      actions: [
                        if (available)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Center(
                                child: CustomText(
                                    "${BaseController.formatPrice(productPrice)}")),
                          ),
                      ],
                    ),
                  ),
                ),
                if (available)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 4,
                        top: 8.0,
                        bottom: MediaQuery.of(context).padding.bottom + 4.0,
                      ),
                      child: FittedBox(
                        child: Row(
                          children: [
                            if (!widget.fromCart)
                              GestureDetector(
                                onTap: (locator<HomeController>().isLoggedIn)
                                    ? (selectedQty == 0 ||
                                            selectedColor == "" ||
                                            selectedSize == "")
                                        ? () => DialogService.showCustomDialog(
                                              AlertDialog(
                                                title: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                      'Please select size, color & quantity'),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        DialogService
                                                            .popDialog();
                                                        await Scrollable
                                                            .ensureVisible(
                                                          variationSelectionCardKey
                                                              .currentContext,
                                                          alignment: 0.50,
                                                        );
                                                      },
                                                      child: Text("OK")),
                                                ],
                                              ),
                                            )
                                        : () async {
                                            var res = await controller.buyNow(
                                                productData,
                                                selectedQty,
                                                selectedSize,
                                                selectedColor);
                                            if (res != null && res == true) {
                                              final cartRes =
                                                  await locator<APIService>()
                                                      .getCartProductItemList();
                                              if (cartRes != null) {
                                                await locator<
                                                        CartLocalStoreService>()
                                                    .setCartList(cartRes);
                                                locator<CartCountController>()
                                                    .setCartCount(
                                                        cartRes.length);
                                              }

                                              print(
                                                  "UserDetails: ${locator<HomeController>().details?.toJson()}");

                                              if (locator<HomeController>()
                                                      .details
                                                      ?.measure ==
                                                  null) {
                                                await BaseController
                                                    .showSizePopup();
                                              }

                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  child: CartView(
                                                    productId: productData?.key,
                                                  ),
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                ),
                                              );
                                            }
                                          }
                                    : () async =>
                                        await BaseController.showLoginPopup(
                                          nextView: "buynow",
                                          shouldNavigateToNextScreen: false,
                                        ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  margin: EdgeInsets.only(
                                    right: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: lightGreen,
                                    ),
                                    color: lightGreen,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "BUY NOW",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: subtitleFontSizeStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: (locator<HomeController>().isLoggedIn)
                                  ? disabledAddToCartBtn ||
                                          selectedQty == 0 ||
                                          selectedColor == "" ||
                                          selectedSize == ""
                                      ? () => DialogService.showCustomDialog(
                                            AlertDialog(
                                              title: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                    'Please select size, color & quantity'),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      DialogService.popDialog();
                                                      await Scrollable
                                                          .ensureVisible(
                                                        variationSelectionCardKey
                                                            .currentContext,
                                                        alignment: 0.50,
                                                      );
                                                    },
                                                    child: Text("OK")),
                                              ],
                                            ),
                                          )
                                      : () async {
                                          setState(() {
                                            disabledAddToCartBtn = true;
                                          });

                                          var res = await controller.addToCart(
                                              productData,
                                              selectedQty,
                                              selectedSize,
                                              selectedColor,
                                              fromCart: widget.fromCart,
                                              onProductAdded: widget.fromCart
                                                  ? () => Navigator.pop(context)
                                                  : null);

                                          if (res == 0)
                                            _errorHandlingService.showError(
                                                Errors.CouldNotAddToCart);
                                          else if (res == 1) {
                                            locator<CartCountController>()
                                                .incrementCartCount();
                                          }

                                          setState(() {
                                            disabledAddToCartBtn = false;
                                          });

                                          showTutorial(context,
                                              cartKey: cartKey);
                                        }
                                  : () async =>
                                      await BaseController.showLoginPopup(
                                        nextView: "addtocart",
                                        shouldNavigateToNextScreen: false,
                                      ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  // border: Border.all(color: lightGreen),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    "ADD TO BAG",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: subtitleFontSizeStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              // color: Colors.white,
                              child: Column(
                                children: [
                                  InkWell(
                                    key: cartKey,
                                    onTap: () async => (locator<
                                                HomeController>()
                                            .isLoggedIn)
                                        ? await BaseController.cart()
                                        : await BaseController.showLoginPopup(
                                            nextView: CartViewRoute,
                                            shouldNavigateToNextScreen: true,
                                          ),
                                    child: Obx(
                                      () => CartIconWithBadge(
                                        count: locator<CartCountController>()
                                            .count
                                            .value,
                                        iconColor: appBarIconColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "View Bag",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: InkWell(
                      child: Icon(
                        Icons.navigate_before,
                        size: 40,
                      ),
                      onTap: () => NavigationService.back(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget sectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey[300],
        thickness: 5,
      ),
    );
  }

  Widget elementDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 25.0,
      ),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1.0,
      ),
    );
  }
}

class ProductDescriptionTable extends StatelessWidget {
  const ProductDescriptionTable({
    Key key,
    @required this.product,
    @required this.controller,
  }) : super(key: key);

  final ProductController controller;
  final Product product;

  String getNameFromLookupId(Lookups section, String option, num id) {
    return section?.sections
            ?.where((element) =>
                element?.option?.toLowerCase() == option?.toLowerCase())
            ?.first
            ?.values
            ?.where((element) => element?.id == id)
            ?.first
            ?.name ??
        "No Lookup Found";
  }

  String getWorkOn(List<BlousePadding> workOn) {
    List<String> workOnStrings = [];
    workOn.forEach((e) => workOnStrings.add(workOnMap[e.id]));
    return workOnStrings.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getLookups(),
      builder: (c, AsyncSnapshot<List<Lookups>> s) {
        if (s.connectionState == ConnectionState.done) {
          if (s.error != null) {
            return Container(
              child: Text(
                s.error.toString(),
              ),
            );
          }

          var lookups = s.data;
          if (lookups == null) {
            return Container();
          }
          var productSection = lookups
              .where(
                  (element) => element.sectionName.toLowerCase() == "product")
              .first;
          if (productSection == null) {
            return Container();
          }
          return Table(
            children: [
              // divider,
              if (product?.fabricDetails != null &&
                  product?.fabricDetails != "")
                getProductDetailsRow(
                  "Fabric Feel",
                  product?.fabricDetails,
                ),
              // divider,
              if (product?.typeOfWork != null && product?.typeOfWork != "")
                getProductDetailsRow(
                  "Type Of Work",
                  product?.typeOfWork,
                ),
              // divider,
              if (product?.neck != null && product?.neck != "")
                getProductDetailsRow("Neck", product?.neck?.toString()),
              // divider,
              if (product?.waist != null)
                getProductDetailsRow("Waist", product?.waist?.toString()),
              // divider,
              if (product?.typeOfSaree != null && product?.typeOfSaree != "")
                getProductDetailsRow("Type of Saree", product?.typeOfSaree),
              // divider,
              if (product?.pieces != null && product?.pieces?.id != -1)
                getProductDetailsRow(
                    "Pieces",
                    getNameFromLookupId(
                        productSection, "pieces", product?.pieces?.id)),
              // divider,
              if (product?.workOn != null && product?.workOn?.length != 0)
                getProductDetailsRow("Work on", getWorkOn(product?.workOn)),
              // divider,
              if (product?.topsLength != null && product?.topsLength?.id != -1)
                getProductDetailsRow(
                    "Top's length",
                    getNameFromLookupId(
                        productSection, "topsLength", product?.topsLength?.id)),
              // divider,
              if (product?.made != null && product?.made?.id != -1)
                getProductDetailsRow(
                    "Made",
                    getNameFromLookupId(
                        productSection, "made", product?.made?.id)),
              // divider,
              // if (product?.whoMadeIt != null && product?.whoMadeIt?.id != -1)
              //   getProductDetailsRow(
              //       "Who Made It",
              //       getNameFromLookupId(
              //           productSection, "whoMadeIt", product?.whoMadeIt?.id)),
              // divider,
              if (product?.flair != null)
                getProductDetailsRow("Flair", product?.flair?.toString()),
              // divider,
              if ((product?.washing != null) && (product?.washing != ''))
                getProductDetailsRow("Washing", product?.washing?.toString()),
              // divider,
              if (product?.pricePerMeter != null)
                getProductDetailsRow(
                    "Price Per Meter", product?.pricePerMeter?.toString()),
              // divider,
              if ((product?.hangings != null) && (product?.category?.id == 7))
                getProductDetailsRow(
                  "Hangings",
                  product.hangings ? "Yes" : "No",
                ),
              // divider,
              if ((product?.occasionToWearIn != null) &&
                  (product?.occasionToWearIn != ''))
                getProductDetailsRow(
                  "Occasion To Wear In",
                  product?.occasionToWearIn?.toString(),
                ),

              // divider,
              if ((product?.made != null) && (product?.made?.id != -1))
                getProductDetailsRow(
                  "Made",
                  product?.made?.id == 1 ? "Made on Demand" : "Ready Made",
                ),

              // divider,
              if ((product?.whatDoesItHave != null) &&
                  (product?.whatDoesItHave?.id != -1) &&
                  (product?.category?.id == 9))
                getProductDetailsRow(
                  "what Does It Have",
                  ((product?.whatDoesItHave?.id == 1)
                      ? 'Sling'
                      : (product?.whatDoesItHave?.id == 2)
                          ? 'Handel'
                          : (product?.whatDoesItHave?.id == 3)
                              ? 'Bag-Pack Straps'
                              : ''),
                ),

              // divider,
              if ((product?.canCan != null) && (product?.category?.id == 14))
                getProductDetailsRow("Can Can", product.canCan ? "Yes" : "No"),

              // divider,
              if (product?.sleeveLength != null &&
                  product?.sleeveLength?.id != -1)
                getProductDetailsRow(
                  "Sleeve Length",
                  getNameFromLookupId(productSection, "sleeveLength",
                      product?.sleeveLength?.id),
                ),
              // divider,
              if (product?.stitchingType != null &&
                  product?.stitchingType?.id != -1)
                getProductDetailsRow(
                  "Stiching Type",
                  getNameFromLookupId(productSection, "stitchingType",
                      product?.stitchingType?.id),
                ),
              // divider,
              if (product?.blousePadding != null &&
                  product?.blousePadding?.id != -1)
                getProductDetailsRow(
                  "Blouse Padding",
                  getNameFromLookupId(productSection, "blousePadding",
                      product?.blousePadding?.id),
                ),
              // divider,
              if (product?.backCut != null && product?.backCut != "")
                getProductDetailsRow(
                  "Back Cut",
                  product?.backCut,
                ),
              // divider,
              if (product?.neckCut != null && product?.neckCut != "")
                getProductDetailsRow(
                  "Neck Cut",
                  product?.neckCut,
                ),
              // divider,
              if (product?.dimensions != null && product?.dimensions != "")
                getProductDetailsRow(
                  "Dimensions",
                  product?.dimensions,
                ),
              // divider,
              if (product?.style != null && product?.style != "")
                getProductDetailsRow(
                  "Style",
                  product?.style,
                ),
              // divider,
              if (product?.length != null)
                getProductDetailsRow(
                  "Length",
                  product?.length?.toString(),
                ),
              // divider,
              if (product?.breadth != null && product?.breadth != 0)
                getProductDetailsRow(
                  "Breadth",
                  product?.breadth?.toString(),
                ),
              // divider,
              if (product?.heelHeight != null && product?.heelHeight != 0)
                getProductDetailsRow(
                  "Heel Height",
                  product?.heelHeight?.toString(),
                ),
              if (product?.margin != null && product.margin)
                getProductDetailsRow("Margin", "Margin left in selai"),

              // divider
              if ((product?.art?.length ?? 0) > 0)
                getProductDetailsRow("Art", product.art),
              // divider
              if ((product?.bottomStyle?.length ?? 0) > 0)
                getProductDetailsRow("BottomStyle", product.bottomStyle),
              // divider
              if ((product?.closureType?.length ?? 0) > 0)
                getProductDetailsRow("ClosureType", product.closureType),
              // divider
              if ((product?.fittingType?.length ?? 0) > 0)
                getProductDetailsRow("FittingType", product.fittingType),
              // divider
              if ((product?.riseStyle?.length ?? 0) > 0)
                getProductDetailsRow("RiseStyle", product.riseStyle),
              // divider
              if ((product?.weaveType?.length ?? 0) > 0)
                getProductDetailsRow("WeaveType", product.weaveType),
            ],
          );
        }
        return Container();
      },
    );
  }

  TableRow getProductDetailsRow(productDetailsKey, productDetailsValue) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              productDetailsKey,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              productDetailsValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const rowSpacer = TableRow(children: [
  SizedBox(
    height: 3,
  ),
  SizedBox(
    height: 3,
  )
]);
const divider = TableRow(children: [
  Divider(
    color: Colors.grey,
    thickness: 0.2,
  ),
  Divider(
    color: Colors.grey,
    thickness: 0.2,
  )
]);
