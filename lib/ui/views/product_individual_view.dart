import 'dart:io';
import 'package:compound/ui/views/promotion_recieved_screen.dart';
import 'package:compound/ui/widgets/confetti.dart';
import 'package:compound/ui/widgets/product_detail_card.dart';
import 'package:http/http.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
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
import '../../models/productPageArg.dart';
import '../../models/products.dart';
import '../../models/reviews.dart';
import '../../services/api/api_service.dart';
import '../../services/cart_local_store_service.dart';
import '../../services/dialog_service.dart';
import '../../services/dynamic_link_service.dart';
import '../../services/error_handling_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../../utils/stringUtils.dart';
import '../../utils/tools.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../views/home_view_slider.dart';
import '../widgets/cart_icon_badge.dart';
import '../widgets/custom_text.dart';
import '../widgets/home_view_list_header.dart';
import '../widgets/product_description_table.dart';
import '../widgets/section_builder.dart';
import '../widgets/shimmer/shimmer_widget.dart';
import '../widgets/wishlist_icon.dart';
import 'cart_view.dart';
import 'gallery_view.dart';
import 'help_view.dart';

const weekday = ["Monday", "Tuesday", "wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

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

Map<String, Color> tagColors = {
  PRODUCTSCREEN_ASSURED.tr: Colors.blueAccent,
  PRODUCTSCREEN_RETURNS.tr: Colors.grey[700]!,
  PRODUCTSCREEN_IN_STOCK.tr: lightGreen,
  PRODUCTSCREEN_SOLD_OUT.tr: logoRed,
};

class ProductIndiView extends StatefulWidget {
  final Product data;
  final bool fromCart;
  const ProductIndiView({Key? key, required this.data, this.fromCart = false}) : super(key: key);
  @override
  _ProductIndiViewState createState() => _ProductIndiViewState();
}

class _ProductIndiViewState extends State<ProductIndiView> {
  final refreshController = RefreshController(initialRefresh: false);
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final ErrorHandlingService _errorHandlingService = locator<ErrorHandlingService>();
  late ProductController productController;

  UniqueKey key = UniqueKey();
  GlobalKey variationSelectionCardKey = GlobalKey();

  int selectedQty = 0;
  int selectedIndex = -1;
  int maxQty = -1;
  String selectedSize = "";
  String selectedColor = "";
  bool disabledAddToCartBtn = false;
  Product? productData;
  bool showMoreFromDesigner = true;
  String? productName;
  String? productId;
  double? productDiscount;
  int? productPrice;
  int? saved;
  List<Variation>? variations;
  String? date;
  Key? uniqueKey;
  Key? photosKey;
  Key? knowDesignerKey;
  DateTime? dateParse;
  DateTime? newDate;
  String? formattedDate;
  String? shipment;
  int? totalQuantity;
  bool? available;
  List<String>? imageURLs;
  double height = 100;
  Product? _promotedProductInfo;

  bool showHeader = false;
  bool showSizechart = false;

  GlobalKey cartKey = GlobalKey();

  @override
  void initState() {
    productController = ProductController(
      widget.data.account?.key,
      productId: widget.data.key!,
      productName: widget.data.name!,
    )..init();
    getPromotedProduct();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getPromotedProduct() async {
    final prefs = await SharedPreferences.getInstance();
    String? promotedProduct;

    promotedProduct = prefs.getString('promoted_product');

    print("hehehe ${promotedProduct.toString()}");

    _promotedProductInfo = await getProductInfo(promotedProduct.toString());
  }

  Future<Product> getProductInfo(String promotedProduct) async {
    final product = (await APIService().getProductById(productId: promotedProduct.toString()))!;
    print("Product details fetched");
    return product;
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 700),
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              // height: 500,

              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(curve15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Thanks for sharing !",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: logoRed),
                  ),
                  Lottie.asset('assets/icons/ruffle-gift.json'),
                  verticalSpaceSmall,
                  Text(
                    "You have a chance to win a product for free. Keep Sharing!",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  ),
                  verticalSpaceSmall,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AllConfettiWidget(
                                  child: PromotionScreen(data: _promotedProductInfo))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: CustomText(
                          "View Product",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      // transitionBuilder: (_, anim, __, child) {
      //   Tween<Offset> tween;
      //   if (anim.status == AnimationStatus.reverse) {
      //     tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      //   } else {
      //     tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      //   }

      //   return SlideTransition(
      //     position: tween.animate(anim),
      //     child: FadeTransition(
      //       opacity: anim,
      //       child: child,
      //     ),
      //   );
      // },
    );
  }

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        global: false,
        init: productController,
        initState: (state) {
          setupProductDetails(widget.data);
          showTutorial(
            context,
            photosKey: photosKey as GlobalKey,
            knowDesignerKey: knowDesignerKey as GlobalKey,
          );
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
                      child: Center(
                        child: Image.asset(
                          "assets/images/loading_img.gif",
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    complete: Container(),
                  ),
                  controller: refreshController,
                  onRefresh: () async {
                    Product? product = await controller.refreshProduct(productData!.key!);
                    if (product != null) {
                      setState(() {
                        setupProductDetails(product);
                      });
                    }
                    await Future.delayed(Duration(milliseconds: 100));
                    refreshController.refreshCompleted();
                  },
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            FutureBuilder(
                                future: checkshowSizeChart(),
                                builder: (context, data) {
                                  if (data.connectionState == ConnectionState.done) {
                                    return HomeSlider(
                                      key: photosKey,
                                      imgList: imageURLs ?? [],
                                      sizeChartUrl: showSizechart == true
                                          ? "${BASE_URL}sellers/${productData!.account!.key}/categories/${productData!.category!.id}/sizechart"
                                          : "",
                                      videoList: productData?.video?.videos
                                              .map((e) =>
                                                  "${BASE_URL}products/${productData!.key}/videos/${e.name}")
                                              .toList() ??
                                          [],
                                      aspectRatio: 1,
                                      fromProduct: true,
                                    );
                                  }
                                  return HomeSlider(
                                    key: photosKey,
                                    imgList: imageURLs ?? [],
                                    videoList: productData?.video?.videos
                                            .map((e) =>
                                                "${BASE_URL}products/${productData!.key}/videos/${e.name}")
                                            .toList() ??
                                        [],
                                    aspectRatio: 1,
                                    fromProduct: true,
                                  );
                                }),
                            Positioned(
                              bottom: 32,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 1)]),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: InkWell(
                                        onTap: () async => locator<HomeController>().isLoggedIn
                                            ? controller.onWishlistBtnClicked(productId!)
                                            : await BaseController.showLoginPopup(
                                                nextView: WishListRoute,
                                                shouldNavigateToNextScreen: true,
                                              ),
                                        child: WishListIcon(
                                          filled: controller.isWishlistIconFilled,
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
                                                    .createLink(productLink + productId!) ??
                                                "",
                                          );
                                          await controller.shareProductEvent(
                                              productId: productId!, productName: productName!);

                                          showCustomDialog(context);
                                          // Future.delayed(Duration(seconds: 90), showCustomDialog(context));
                                        },
                                        child: Icon(
                                          Platform.isIOS ? CupertinoIcons.share : Icons.share,
                                          size: 20,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: productPriceInfo(
                                      productName: productData!.name,
                                      designerName: productData!.seller?.name ?? "No Name",
                                      productPrice: productPrice,
                                      actualPrice: (productData!.cost!.cost +
                                              productData!.cost!.convenienceCharges!.cost! +
                                              productData!.cost!.gstCharges!.cost!)
                                          .round(),
                                      showPrice: (available!),
                                      isClothMeterial: (productData!.category!.id == 13),
                                    ),
                                  ),
                                  if ((productData?.discount ?? 0.0) != 0.0)
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: logoRed,
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        width: 40,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            productData!.discount!.round().toString() + "%",
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
                                ],
                              ),
                              elementDivider(),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      "Free Delivery",
                                      style: TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        PRODUCTSCREEN_ASSURED.tr,
                                        if (available! &&
                                            (totalQuantity != 0) &&
                                            locator<HomeController>().cityName.toLowerCase() ==
                                                'ahmedabad')
                                          PRODUCTSCREEN_COD.tr,
                                        PRODUCTSCREEN_RETURNS.tr,
                                        if (available! && (totalQuantity != 0))
                                          PRODUCTSCREEN_IN_STOCK.tr,
                                        if ((available! && (totalQuantity == 0)) || !available!)
                                          PRODUCTSCREEN_SOLD_OUT.tr,
                                        PRODUCTSCREEN_JUST_HERE.tr,
                                        if ((productData?.stitchingType?.id ?? -1) == 2)
                                          PRODUCTSCREEN_UNSTITCHED.tr,
                                        if (productData!.whoMadeIt!.id == 2)
                                          PRODUCTSCREEN_HANDCRAFTED.tr,
                                        if (totalQuantity == 1) PRODUCTSCREEN_ONE_IN_MARKET.tr,
                                      ]
                                          .map(
                                            (e) => InkWell(
                                              onTap: e.contains(PRODUCTSCREEN_RETURNS.tr)
                                                  ? () async => await showModalBottomSheet(
                                                        isScrollControlled: true,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(curve10),
                                                          ),
                                                        ),
                                                        clipBehavior: Clip.antiAlias,
                                                        context: context,
                                                        builder: (con) => HelpView(),
                                                      )
                                                  : null,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 4.0,
                                                  horizontal: 8.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (e.contains(PRODUCTSCREEN_ASSURED.tr)) ...[
                                                      Image.asset(
                                                        "assets/images/assured.png",
                                                        color: Colors.blueAccent,
                                                        height: 16,
                                                        width: 16,
                                                      ),
                                                      horizontalSpaceTiny,
                                                    ],
                                                    Text(
                                                      e,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: tagColors[e] ?? Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/hand-made.png",
                                      height: 75,
                                    ),
                                    horizontalSpaceSmall,
                                    Container(
                                      width: MediaQuery.of(context).size.width - 130,
                                      child: Column(
                                        children: [
                                          Text(
                                            "All products on Dzor are handmade and made to order.",
                                            maxLines: 5,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "Creators really appreciate your patience in getting the products from their home to yours.",
                                            maxLines: 5,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              elementDivider(),
                              if (available!)
                                Container(
                                  // decoration: BoxDecoration(border: Border.all()),
                                  width: MediaQuery.of(context).size.width,
                                  // padding : EdgeInsets.symmetric(horizontal : 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      selectedSize == "N/A"
                                          ? verticalSpace(0)
                                          : Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    PRODUCTSCREEN_SELECT_SIZE.tr,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14,
                                                      letterSpacing: 1.0,
                                                      color: logoRed,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    _showDialog(context, productData?.seller?.key,
                                                        productData?.category?.id ?? 1);
                                                  },
                                                  child: Text(
                                                    PRODUCTSCREEN_SIZE_CHART.tr,
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline,
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                selectedSize == "N/A"
                                                    ? verticalSpace(0)
                                                    : elementDivider(),
                                                Text(
                                                  PRODUCTSCREEN_SELECT_COLOR.tr,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    letterSpacing: 1.0,
                                                    color: logoRed,
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
                                          : (productData!.category!.id != 13)
                                              ? Container()
                                              : Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    elementDivider(),
                                                    Text(
                                                      "Select ${(productData!.category!.id == 13) ? 'No. of Meters' : 'Qty'}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        letterSpacing: 1.0,
                                                        color: logoRed,
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
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            IconButton(
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: 4.0),
                                                              color: selectedQty == 0
                                                                  ? Colors.grey
                                                                  : darkRedSmooth,
                                                              iconSize: 18,
                                                              icon: Icon(Icons.remove),
                                                              onPressed: () {
                                                                if (selectedQty != 0) {
                                                                  setState(() {
                                                                    selectedQty = selectedQty - 1;
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                              selectedQty.toString(),
                                                              style: TextStyle(
                                                                  color: darkRedSmooth,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                            IconButton(
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: 4.0),
                                                              iconSize: 18,
                                                              color: maxQty == selectedQty
                                                                  ? Colors.grey
                                                                  : darkRedSmooth,
                                                              icon: Icon(Icons.add),
                                                              onPressed: () {
                                                                print("maxQty" + maxQty.toString());
                                                                if (maxQty != selectedQty) {
                                                                  setState(() {
                                                                    selectedQty = selectedQty + 1;
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              PRODUCTSCREEN_SELECTION_GUIDE.tr,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: subtitleFontSizeStyle - 2,
                                              ),
                                            ),
                                            verticalSpaceTiny,
                                            GestureDetector(
                                              onTap: () async {
                                                if (await canLaunch(RETURN_POLICY_URL))
                                                  await launch(RETURN_POLICY_URL);
                                              },
                                              child: Text(
                                                "Return Policy",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: subtitleFontSizeStyle - 2,
                                                    decoration: TextDecoration.underline),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              if ((controller.productData?.coupons?.length ?? 0) > 0) ...[
                                // sectionDivider(),
                                elementDivider(),

                                HomeViewListHeader(
                                  title: PRODUCTSCREEN_AVAILABLE_COUPONS.tr,
                                  padding: EdgeInsets.zero,
                                ),
                                verticalSpaceTiny,
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: controller.productData?.coupons
                                              ?.map(
                                                (e) => InkWell(
                                                  onTap: () async {
                                                    await Get.bottomSheet(
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                          top: 16.0,
                                                          right: 8.0,
                                                          left: 8.0,
                                                          bottom: MediaQuery.of(context)
                                                                  .padding
                                                                  .bottom +
                                                              16.0,
                                                        ),
                                                        color: Colors.white,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/images/discount_tag.png',
                                                                      height: 22,
                                                                      width: 22,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    horizontalSpaceSmall,
                                                                    Text(
                                                                      "Deals",
                                                                      style: TextStyle(
                                                                        fontSize: 18,
                                                                        color: logoRed,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                IconButton(
                                                                  tooltip: "Close",
                                                                  iconSize: 28,
                                                                  icon: Icon(CupertinoIcons
                                                                      .clear_circled_solid),
                                                                  color: Colors.grey[500],
                                                                  onPressed: () =>
                                                                      NavigationService.back(),
                                                                ),
                                                              ],
                                                            ),
                                                            verticalSpaceSmall,
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: logoRed,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                      5,
                                                                    ),
                                                                  ),
                                                                  padding: EdgeInsets.symmetric(
                                                                    vertical: 4.0,
                                                                    horizontal: 8.0,
                                                                  ),
                                                                  child: Text(
                                                                    e.code!.toUpperCase(),
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: Colors.white,
                                                                    elevation: 0,
                                                                  ),
                                                                  child: Text(
                                                                    "COPY",
                                                                    style: TextStyle(
                                                                      color: logoRed,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  onPressed: () async {
                                                                    await Clipboard.setData(
                                                                      ClipboardData(
                                                                        text: e.code,
                                                                      ),
                                                                    );

                                                                    Get.snackbar(
                                                                      "Coupon Code Copied",
                                                                      "Use this code while placing order.",
                                                                      snackPosition:
                                                                          SnackPosition.BOTTOM,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            verticalSpaceMedium,
                                                            Text(
                                                              "Get FLAT Rs. ${e.discount} off",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            verticalSpaceTiny,
                                                            Center(
                                                              child: Divider(
                                                                color: Colors.grey[500],
                                                              ),
                                                            ),
                                                            verticalSpaceTiny,
                                                            Text(
                                                              "Use Code ${e.code!.toUpperCase()} and get FLAT Rs.${e.discount} off on order above Rs.${e.minimumOrderValue}.",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    child: DottedBorder(
                                                      color: logoRed,
                                                      borderType: BorderType.RRect,
                                                      radius: Radius.circular(5),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          vertical: 4.0,
                                                          horizontal: 8.0,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/discount_tag.png',
                                                              height: 16,
                                                              width: 16,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            horizontalSpaceTiny,
                                                            Text(
                                                              e.name ?? "",
                                                              style: TextStyle(
                                                                fontSize: 10.0,
                                                                color: logoRed,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList() ??
                                          []),
                                ),
                              ],
                              if (available!) elementDivider(),
                              if (available!)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!widget.fromCart)
                                      GestureDetector(
                                        onTap: () async {
                                          print("buy now clicked");
                                          if (locator<HomeController>().isLoggedIn) {
                                            if (selectedQty == 0 ||
                                                selectedColor == "" ||
                                                selectedSize == "") {
                                              await DialogService.showCustomDialog(
                                                AlertDialog(
                                                  title: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                        PRODUCTSCREEN_SELECT_SIZE_COLOR_QTY.tr),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          DialogService.popDialog();
                                                          await Scrollable.ensureVisible(
                                                            variationSelectionCardKey
                                                                .currentContext!,
                                                            alignment: 0.50,
                                                          );
                                                        },
                                                        child: Text("OK")),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              var res = await controller.buyNow(
                                                  productData!,
                                                  selectedQty,
                                                  context,
                                                  selectedSize,
                                                  selectedColor);
                                              if (res != null && res == true) {
                                                final cartRes = await locator<APIService>()
                                                    .getCartProductItemList();
                                                if (cartRes != null) {
                                                  await locator<CartLocalStoreService>()
                                                      .setCartList(cartRes);
                                                  locator<CartCountController>()
                                                      .setCartCount(cartRes.length);
                                                }

                                                print(
                                                    "UserDetails: ${locator<HomeController>().details?.toJson()}");

                                                if (locator<HomeController>().details?.measure ==
                                                    null) {
                                                  await BaseController.showSizePopup();
                                                }

                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: CartView(
                                                      productId: productData!.key!,
                                                    ),
                                                    type: PageTransitionType.rightToLeft,
                                                  ),
                                                );
                                              }
                                            }
                                          } else {
                                            await BaseController.showLoginPopup(
                                              nextView: "buynow",
                                              shouldNavigateToNextScreen: false,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: double.maxFinite,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
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
                                              PRODUCTSCREEN_BUY_NOW.tr,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: subtitleFontSizeStyle,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    verticalSpaceTiny,
                                    Text(
                                      "${PRODUCTSCREEN_DELIVERY_BY.tr} : $shipment",
                                      style: TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              // sectionDivider(),
                              elementDivider(),
                              CustomText(
                                "Item Details",
                                // PRODUCTSCREEN_ITEM_DETAILS.tr,
                                fontSize: 14,
                                letterSpacing: 0.4,

                                fontWeight: FontWeight.w600,
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[100]),
                                  padding: EdgeInsets.all(5),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      verticalSpace(5),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Divider(color: Colors.grey.withOpacity(0.5), height: 1),
                                      ProductDescriptionTable(
                                        product: productData!,
                                        controller: controller,
                                        workOnMap: workOnMap,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              elementDivider(),
                              ProductDetailCard(
                                key: knowDesignerKey,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Know the Creator",
                                        // PRODUCTSCREEN_KNOW_YOUR_DESIGNER.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 0.4,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20.0),
                                        child: FutureBuilder<Reviews?>(
                                          future: locator<APIService>().getReviews(
                                              productData!.seller!.key!,
                                              isSellerReview: true),
                                          builder: (context, snapshot) => ((snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) &&
                                                  ((snapshot.data?.ratingAverage?.rating ?? 0) > 0))
                                              ? FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                      horizontal: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Tools.getColorAccordingToRattings(
                                                          snapshot.data!.ratingAverage!.rating!,
                                                        ),
                                                      ),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        CustomText(
                                                          snapshot.data!.ratingAverage!.rating!
                                                              .toString(),
                                                          color: Tools.getColorAccordingToRattings(
                                                            snapshot.data!.ratingAverage!.rating!,
                                                          ),
                                                          isBold: true,
                                                          fontSize: 12,
                                                        ),
                                                        horizontalSpaceTiny,
                                                        Icon(
                                                          Icons.star,
                                                          color: Tools.getColorAccordingToRattings(
                                                            snapshot.data!.ratingAverage!.rating!,
                                                          ),
                                                          size: 12,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (productData?.seller?.subscriptionTypeId != 2)
                                    verticalSpace(5),
                                  GestureDetector(
                                    onTap: () async => await goToSellerProfile(controller),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      elevation: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(255, 255, 255, 1),
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                            color: Colors.black38,
                                                            width: 0.5,
                                                          ),
                                                        ),
                                                        child: ClipOval(
                                                          child: FadeInImage(
                                                              width: 50,
                                                              height: 50,
                                                              fadeInCurve: Curves.easeIn,
                                                              fit: BoxFit.cover,
                                                              placeholder: AssetImage(
                                                                  "assets/images/user.png"),
                                                              image: NetworkImage(
                                                                "$DESIGNER_PROFILE_PHOTO_BASE_URL/${productData?.seller?.owner?.key}",
                                                                headers: {
                                                                  "Authorization":
                                                                      "Bearer ${locator<HomeController>().prefs?.getString(Authtoken) ?? ''}",
                                                                },
                                                              ),
                                                              imageErrorBuilder:
                                                                  (context, error, stackTrace) {
                                                                print(
                                                                    "Image Error: $error $stackTrace");
                                                                return Image.asset(
                                                                  "assets/images/user.png",
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit.cover,
                                                                );
                                                              }),
                                                        ),
                                                      ),
                                                      verticalSpaceTiny,
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons.mapMarkerAlt,
                                                            color: logoRed,
                                                            size: 10,
                                                          ),
                                                          CustomText(
                                                              productData!.seller!.contact!.city!,
                                                              fontSize: 10,
                                                              color: textIconBlue),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  horizontalSpaceSmall,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        CustomText(
                                                          "${productData?.seller?.owner?.name ?? ""}",
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: titleFontSize,
                                                          dotsAfterOverFlow: true,
                                                        ),
                                                        CustomText(
                                                          "(${productData?.seller?.name ?? ''})",
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: subtitleFontSize,
                                                          dotsAfterOverFlow: true,
                                                        ),
                                                        if ((productData?.seller?.education !=
                                                                null) ||
                                                            (productData?.seller?.designation !=
                                                                null))
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: CustomText(
                                                                  "${productData?.seller?.education ?? ''} ${productData?.seller?.designation ?? ''}",
                                                                  fontSize: subtitleFontSize,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.grey.shade600,
                                                                  dotsAfterOverFlow: true,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ReadMoreText(
                                                          productData?.seller?.intro ??
                                                              (productData?.seller?.bio ?? ""),
                                                          trimLines:
                                                              ((productData?.seller?.education ==
                                                                          null) &&
                                                                      (productData?.seller
                                                                              ?.designation ==
                                                                          null))
                                                                  ? 2
                                                                  : 1,
                                                          colorClickableText: logoRed,
                                                          trimMode: TrimMode.Line,
                                                          style: TextStyle(
                                                            fontSize: subtitleFontSize - 2,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                      ],
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
                                ],
                              ),
                              // sectionDivider(),
                              // ReviewWidget(
                              //   onSubmit: () {},
                              //   id: productId,
                              // ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                width: double.maxFinite,
                                decoration: BoxDecoration(color: Colors.grey[300]),
                                child: Text(
                                  "Recommended Products",
                                  // PRODUCTSCREEN_RECOMMENDED_PRODUCTS.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    letterSpacing: 0.4,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SectionBuilder(
                                key: uniqueKey ?? UniqueKey(),
                                context: context,
                                onEmptyList: () {},
                                filter: ProductFilter(
                                  subCategories: ["${productData?.category?.id}"],
                                ),
                                // existingQueryString:
                                //     "subCategory=${productData?.category?.id};"),
                                layoutType: LayoutType.PRODUCT_LAYOUT_2,
                                controller: ProductsGridViewBuilderController(
                                  filteredProductKey: productData?.key,
                                  randomize: true,
                                ),
                                scrollDirection: Axis.horizontal,
                              ),
                              // if (showMoreFromDesigner) sectionDivider(),
                              if (showMoreFromDesigner)
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(color: Colors.grey[300]),
                                  child: Text(
                                    "More from Designer",
                                    // PRODUCTSCREEN_MORE_FROM_DESIGNER.tr,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      letterSpacing: 0.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (showMoreFromDesigner) verticalSpace(5),
                              if (showMoreFromDesigner)
                                SectionBuilder(
                                  key: uniqueKey ?? UniqueKey(),
                                  context: context,
                                  filter: ProductFilter(
                                      existingQueryString: productData?.account?.key != null
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
                        if (available!)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Center(
                                child: CustomText("${BaseController.formatPrice(productPrice)}")),
                          ),
                      ],
                    ),
                  ),
                ),
                if (available!)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // height: 60,
                      color: Colors.grey[200],
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // mainAxisSize: MainAxisSize.min,
                        // price dalna
                        children: [
                          productPriceDetail(
                            productName: productData!.name,
                            designerName: productData!.seller?.name ?? "No Name",
                            productPrice: productPrice,
                            actualPrice: (productData!.cost!.cost +
                                    productData!.cost!.convenienceCharges!.cost! +
                                    productData!.cost!.gstCharges!.cost!)
                                .round(),
                            showPrice: (available!),
                            isClothMeterial: (productData!.category!.id == 13),
                          ),

                          // ? buy now button commented
                          // if (!widget.fromCart)
                          //   GestureDetector(
                          //     onTap: () async {
                          //       print("buy now clicked");
                          //       if (locator<HomeController>().isLoggedIn) {
                          //         if (selectedQty == 0 ||
                          //             selectedColor == "" ||
                          //             selectedSize == "") {
                          //           await DialogService.showCustomDialog(
                          //             AlertDialog(
                          //               title: FittedBox(
                          //                 fit: BoxFit.scaleDown,
                          //                 child: Text(PRODUCTSCREEN_SELECT_SIZE_COLOR_QTY.tr),
                          //               ),
                          //               actions: [
                          //                 TextButton(
                          //                     onPressed: () async {
                          //                       DialogService.popDialog();
                          //                       await Scrollable.ensureVisible(
                          //                         variationSelectionCardKey.currentContext!,
                          //                         alignment: 0.50,
                          //                       );
                          //                     },
                          //                     child: Text("OK")),
                          //               ],
                          //             ),
                          //           );
                          //         } else {
                          //           var res = await controller.buyNow(productData!, selectedQty,
                          //               context, selectedSize, selectedColor);
                          //           if (res != null && res == true) {
                          //             final cartRes =
                          //                 await locator<APIService>().getCartProductItemList();
                          //             if (cartRes != null) {
                          //               await locator<CartLocalStoreService>()
                          //                   .setCartList(cartRes);
                          //               locator<CartCountController>()
                          //                   .setCartCount(cartRes.length);
                          //             }

                          //             print(
                          //                 "UserDetails: ${locator<HomeController>().details?.toJson()}");

                          //             if (locator<HomeController>().details?.measure == null) {
                          //               await BaseController.showSizePopup();
                          //             }

                          //             Navigator.push(
                          //               context,
                          //               PageTransition(
                          //                 child: CartView(
                          //                   productId: productData!.key!,
                          //                 ),
                          //                 type: PageTransitionType.rightToLeft,
                          //               ),
                          //             );
                          //           }
                          //         }
                          //       } else {
                          //         await BaseController.showLoginPopup(
                          //           nextView: "buynow",
                          //           shouldNavigateToNextScreen: false,
                          //         );
                          //       }
                          //     },
                          //     child: Container(
                          //       width: MediaQuery.of(context).size.width * 0.40,
                          //       padding: EdgeInsets.symmetric(
                          //         vertical: 10,
                          //       ),
                          //       margin: EdgeInsets.only(
                          //         right: 4.0,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         border: Border.all(
                          //           color: lightGreen,
                          //         ),
                          //         color: lightGreen,
                          //         borderRadius: BorderRadius.circular(5),
                          //       ),
                          //       child: Center(
                          //         child: Text(
                          //           PRODUCTSCREEN_BUY_NOW.tr,
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: subtitleFontSizeStyle,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          GestureDetector(
                            onTap: () async {
                              if (locator<HomeController>().isLoggedIn) {
                                if (disabledAddToCartBtn ||
                                    selectedQty == 0 ||
                                    selectedColor == "" ||
                                    selectedSize == "") {
                                  await DialogService.showCustomDialog(
                                    AlertDialog(
                                      title: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(PRODUCTSCREEN_SELECT_SIZE_COLOR_QTY.tr),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              DialogService.popDialog();
                                              await Scrollable.ensureVisible(
                                                variationSelectionCardKey.currentContext!,
                                                alignment: 0.50,
                                              );
                                            },
                                            child: Text("OK")),
                                      ],
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    disabledAddToCartBtn = true;
                                  });

                                  var res = await controller.addToCart(productData!, selectedQty,
                                      context, selectedSize, selectedColor,
                                      fromCart: widget.fromCart,
                                      onProductAdded:
                                          widget.fromCart ? () => Navigator.pop(context) : null);

                                  if (res == 0)
                                    _errorHandlingService.showError(Errors.CouldNotAddToCart);
                                  else if (res == 1) {
                                    locator<CartCountController>().incrementCartCount();
                                  }

                                  setState(() {
                                    disabledAddToCartBtn = false;
                                  });

                                  showTutorial(context, cartKey: cartKey);
                                }
                              } else {
                                await BaseController.showLoginPopup(
                                  nextView: "addtocart",
                                  shouldNavigateToNextScreen: false,
                                );
                              }
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width *
                                  (widget.fromCart ? 0.80 : 0.40),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: widget.fromCart ? lightGreen : logoRed,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  PRODUCTSCREEN_ADD_TO_BAG.tr,
                                  style: TextStyle(
                                    color: widget.fromCart ? Colors.white : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitleFontSizeStyle + (widget.fromCart ? 2 : 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (available == false)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.red,
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 8.0,
                        bottom: MediaQuery.of(context).padding.bottom + 10.0,
                      ),
                      child: Text(
                        "SOLD OUT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2),
                      ],
                    ),
                    // width: MediaQuery.of(context).size.width * 0.20,
                    // margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      key: cartKey,
                      onTap: () async => locator<HomeController>().isLoggedIn
                          ? await BaseController.cart()
                          : await BaseController.showLoginPopup(
                              nextView: CartViewRoute,
                              shouldNavigateToNextScreen: true,
                            ),
                      child: Obx(
                        () => CartIconWithBadge(
                          count: locator<CartCountController>().count.value,
                          iconColor: appBarIconColor,
                        ),
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
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 2),
                      ],
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

  _showDialog(context, sellerId, cid) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: ["${BASE_URL}sellers/$sellerId/categories/$cid/sizechart"],
          scrollDirection: Axis.horizontal,
          initialIndex: 0,
          showImageLabel: false,
          isSizeChart: true,
          loadingBuilder: (context, e) => ShimmerWidget(),
          // Center(
          //   child: Image.asset(
          //     "assets/images/loading_img.gif",
          //     height: 50,
          //     width: 50,
          //   ),
          // ),
          backgroundDecoration: BoxDecoration(color: Colors.white),
          appbarColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> checkshowSizeChart() async {
    var abs = await get(Uri.parse(
        "${BASE_URL}sellers/${productData!.account!.key}/categories/${productData!.category!.id}/sizechart"));
    if (abs.statusCode == 400 || abs.statusCode == 404)
      showSizechart = false;
    else
      showSizechart = true;
  }

  Future<void> goToSellerProfile(controller) async {
    if (locator<HomeController>().isLoggedIn) {
      if (productData?.seller?.subscriptionTypeId == 2) {
        await NavigationService.to(
          ProductsListRoute,
          arguments: ProductPageArg(
            subCategory: productData?.seller?.name,
            queryString: "accountKey=${productData?.seller?.key};",
            sellerPhoto: "$SELLER_PHOTO_BASE_URL/${productData?.seller?.key}",
          ),
        );
      } else {
        await NavigationService.to(SellerIndiViewRoute, arguments: productData?.seller);
      }
    } else {
      await BaseController.showLoginPopup(
        nextView: SellerIndiViewRoute,
        shouldNavigateToNextScreen: false,
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
        Expanded(
          child: Column(
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
              ),
            ],
          ),
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Row(
        //       children: <Widget>[
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: [
        //             Row(
        //               children: [
        //                 if (productDiscount != 0.0 && showPrice)
        //                   Padding(
        //                     padding: const EdgeInsets.only(right: 8.0),
        //                     child: Row(
        //                       crossAxisAlignment: CrossAxisAlignment.end,
        //                       children: <Widget>[
        //                         Text(
        //                           '${BaseController.formatPrice(actualPrice)}',
        //                           style: TextStyle(
        //                             fontSize: 8,
        //                             color: Colors.grey[500],
        //                             decoration: TextDecoration.lineThrough,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 if (available!)
        //                   Text(
        //                     '${showPrice ? BaseController.formatPrice(productPrice) : ' - '}',
        //                     style: TextStyle(
        //                       fontSize: 14,
        //                       fontWeight: FontWeight.bold,
        //                       color: lightGreen,
        //                     ),
        //                   )
        //                 else
        //                   Text(
        //                     PRODUCTSCREEN_SOLD_OUT.tr,
        //                     style: TextStyle(
        //                       fontSize: 14,
        //                       fontWeight: FontWeight.bold,
        //                       color: logoRed,
        //                     ),
        //                   ),
        //               ],
        //             ),
        //             if (available!)
        //               Text(
        //                 "(${PRODUCTSCREEN_TAXES_AND_CHARGES.tr})",
        //                 style: TextStyle(
        //                   fontSize: 8,
        //                 ),
        //               ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget productPriceDetail({
    productName,
    designerName,
    productPrice,
    actualPrice,
    bool showPrice = true,
    bool isClothMeterial = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (available!)
                      Text(
                        '${showPrice ? BaseController.formatPrice(productPrice) : ' - '}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: logoRed,
                        ),
                      )
                    else
                      Text(
                        PRODUCTSCREEN_SOLD_OUT.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: logoRed,
                        ),
                      ),
                    SizedBox(
                      width: 4,
                    ),
                    if (productDiscount != 0.0 && showPrice)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${BaseController.formatPrice(actualPrice)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (available!)
                  Text(
                    "(${PRODUCTSCREEN_TAXES_AND_CHARGES.tr})",
                    style: TextStyle(fontSize: 8, color: Colors.black54),
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
    for (int i = 0; i < variations.length; i++) {
      if (!sizes.contains(variations[i].size) && (variations[i].quantity != 0)) {
        allChips.add(ChoiceChip(
          backgroundColor: Colors.white,
          selectedShadowColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: selectedSize == variations[i].size ? darkRedSmooth : Colors.black,
                width: 0.5,
              )),
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: selectedSize == variations[i].size ? FontWeight.w600 : FontWeight.normal,
            color: selectedSize == variations[i].size ? darkRedSmooth : Colors.black,
          ),
          selectedColor: Colors.white,
          label: Text(variations[i].size),
          selected: selectedSize == variations[i].size,
          onSelected: (val) {
            setState(() => {selectedSize = variations[i].size, selectedIndex = i, selectedQty = 0});
          },
        ));
        sizes.add(variations[i].size);
      }
    }
    return allChips;
  }

  Wrap allSizes(variations) {
    if (variations[0].size == "N/A") {
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
      print("check this" + (uniqueColor.containsKey(color.color)).toString() + color.color);
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
              color: selectedColor == color.color ? darkRedSmooth : Colors.black,
              width: 0.5,
            )),
        labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: selectedColor == color.color ? FontWeight.w600 : FontWeight.normal,
            color: selectedColor == color.color ? darkRedSmooth : Colors.black),
        selectedColor: Colors.white,
        label: Text(color.color),
        selected: selectedColor == color.color,
        onSelected: (val) {
          setState(() => {
                selectedColor = color.color,
                maxQty = color.quantity,
                selectedQty = (productData!.category!.id == 13) ? 0 : 1
              });
        },
      ));
    }
    return Wrap(
      spacing: 8,
      children: allColorChips,
    );
  }

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

  int calculateSavedCost(Cost cost) {
    num actualCost = (cost.cost + cost.convenienceCharges!.cost! + cost.gstCharges!.cost!);
    return (actualCost - cost.costToCustomer).round();
  }

  void setupProductDetails(Product data) {
    productData = data;
    productName = data.name ?? "Test Product";
    productId = data.key;
    productDiscount = data.cost?.productDiscount?.rate as double? ?? 0.0;
    productPrice = (data.cost!.costToCustomer).round();
    saved = calculateSavedCost(data.cost!);
    variations = data.variations ?? null;

    date = DateTime.now().toString();
    uniqueKey = UniqueKey();
    dateParse = DateTime.parse(date!);
    newDate = new DateTime(dateParse!.year, dateParse!.month,
        dateParse!.day + (data.shipment?.days == null ? 0 : data.shipment!.days! + 1) as int);
    dateParse = DateTime.parse(newDate.toString());
    formattedDate =
        "${weekday[dateParse!.weekday - 1]} , ${dateParse!.day + 4} ${month[dateParse!.month - 1]}";
    shipment = data.shipment?.days == null ? "Not Available" : formattedDate;
    totalQuantity = 0;
    variations!.forEach((variation) {
      totalQuantity = totalQuantity! + variation.quantity!.toInt();
    });
    available = (totalQuantity == 0) ? false : (data.available ?? false);

    imageURLs = (data.photo?.photos ?? <PhotoElement>[])
        .map((e) => '$PRODUCT_PHOTO_BASE_URL/$productId/${e.name}')
        .toList();
    photosKey = GlobalKey();
    knowDesignerKey = GlobalKey();
    uniqueKey = UniqueKey();
  }

  void showTutorial(BuildContext context,
      {GlobalKey? photosKey, GlobalKey? knowDesignerKey, GlobalKey? cartKey}) {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(cartKey == null ? ShouldShowProductPageTutorial : ShouldShowCartTutorial) ??
          true) {
        late TutorialCoachMark tutorialCoachMark;
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Image.asset(
                              'assets/images/finger_tap.png',
                              height: 180,
                              width: 130,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (knowDesignerKey != null)
            TargetFocus(
              identify: "Know the Creator",
              keyTarget: knowDesignerKey,
              shape: ShapeLightFocus.RRect,
              contents: [
                TargetContent(
                  align: ContentAlign.top,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Know the Creator",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
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
              alignSkip: Alignment.bottomLeft,
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
        Future.delayed(Duration(milliseconds: 300), () {
          tutorialCoachMark = TutorialCoachMark(
            context,
            targets: targets,
            colorShadow: Colors.black45,
            paddingFocus: 5,
            onClickOverlay: (targetFocus) {
              if (knowDesignerKey != null)
                Scrollable.ensureVisible(
                  knowDesignerKey.currentContext!,
                  alignment: 0.5,
                );
              Future.delayed(Duration(milliseconds: 100), () {
                tutorialCoachMark.next();
              });
            },
            onClickTarget: (targetFocus) {
              if (knowDesignerKey != null)
                Scrollable.ensureVisible(
                  knowDesignerKey.currentContext!,
                  alignment: 0.5,
                );
              Future.delayed(Duration(milliseconds: 100), () {
                tutorialCoachMark.next();
              });
            },
            onSkip: () async => await prefs.setBool(
                cartKey == null ? ShouldShowProductPageTutorial : ShouldShowCartTutorial, false),
            onFinish: () async => await prefs.setBool(
                cartKey == null ? ShouldShowProductPageTutorial : ShouldShowCartTutorial, false),
          )..show();
        });
      }
    });
  }

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
        horizontal: 0.0,
      ),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1.0,
      ),
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
