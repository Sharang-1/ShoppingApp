// import 'package:compound/models/LookupSetUp.dart';
import 'package:compound/models/WhishListSetUp.dart';
import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/lookups.dart';
import 'package:compound/models/productPageArg.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/dynamic_link_service.dart';
import 'package:compound/services/error_handling_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/cart_view.dart';
import 'package:compound/ui/views/gallery_view.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/ProductTileUI.dart';
import 'package:compound/ui/widgets/reviews.dart';
import 'package:compound/ui/widgets/wishlist_icon.dart';
import 'package:compound/utils/stringUtils.dart';
import 'package:compound/utils/tools.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/product_individual_view_model.dart';
// import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/dynamic_links.dart';
import '../../constants/route_names.dart';
import '../../constants/server_urls.dart';
import '../../locator.dart';
import '../../models/CartCountSetUp.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../views/home_view_slider.dart';
import '../widgets/cart_icon_badge.dart';

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
  final NavigationService _navigationService = locator<NavigationService>();
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  int selectedQty = 0;
  int selectedIndex = -1;
  int maxQty = -1;
  String selectedSize = "";
  String selectedColor = "";
  UniqueKey key = UniqueKey();
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
          loadingBuilder: (context, e) =>
              Center(child: CircularProgressIndicator()),
          backgroundDecoration: BoxDecoration(color: backgroundWhiteCreamColor),
        ),
      ),
    );
    // return showDialog<void>(
    //   context: context,
    //   child: new AlertDialog(
    //     contentPadding: const EdgeInsets.all(16.0),
    //     content: new Row(
    //       children: <Widget>[
    //         new Expanded(
    //           child: GestureDetector(
    //             child: Image.network(
    //               "${BASE_URL}sellers/$sellerId/categories/$cid/sizechart",
    //               errorBuilder: (context, error, stackTrace) => Image.asset(
    //                 'assets/images/product_preloading.png',
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget productNameAndDescInfo(productName, variations, sellermodel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            capitalizeString(productName.toString()),
            style: TextStyle(
              fontSize: titleFontSizeStyle + 12,
              fontFamily: headingFont,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        GestureDetector(
          child: Text(
            "By " + (sellermodel.selleDetail?.name ?? ""),
            style:
                TextStyle(fontSize: subtitleFontSizeStyle - 2, color: darkGrey),
          ),
          onTap: () async => await goToSellerProfile(sellermodel),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Future<void> goToSellerProfile(model) async {
    if (model?.selleDetail?.subscriptionTypeId == 2) {
      await _navigationService.navigateTo(
        ProductsListRoute,
        arguments: ProductPageArg(
          subCategory: model?.selleDetail?.name,
          queryString: "accountKey=${model?.selleDetail?.key};",
          sellerPhoto: "$SELLER_PHOTO_BASE_URL/${model?.selleDetail?.key}",
        ),
      );
    } else {
      await _navigationService.navigateTo(SellerIndiViewRoute,
          arguments: model?.selleDetail);
    }
  }

  Widget priceInfo(productPrice, productDiscount, saved,
      {bool showPrice = true, bool isClothMeterial = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isClothMeterial)
          Text(
            'Price per Meter',
            style: TextStyle(
              fontSize: subtitleFontSizeStyle - 3,
              color: Colors.black54,
            ),
          ),
        Row(children: <Widget>[
          Text(
            '\u20B9${showPrice ? productPrice?.toString() : ' - '}',
            style: TextStyle(
                fontSize: titleFontSizeStyle + 8, fontWeight: FontWeight.bold),
          ),
          (productDiscount != 0.0 && showPrice)
              ? Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Text(
                      '${productDiscount.toInt().toString()}% off',
                      style: TextStyle(
                          fontSize: subtitleFontSizeStyle - 2,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600),
                    ),
                    // SizedBox(width: 5),
                    // Text(
                    //   '(Saved \u20B9$saved)',
                    //   style: TextStyle(
                    //       fontSize: subtitleFontSizeStyle - 2,
                    //       color: Colors.grey,
                    //       fontWeight: FontWeight.w600),
                    // ),
                  ],
                )
              : Container(),
        ]),
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
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: selectedSize == variations[i].size
                    ? darkRedSmooth
                    : Colors.grey,
                width: 0.5,
              )),
          labelStyle: TextStyle(
              fontSize: subtitleFontSizeStyle - 4,
              fontWeight: selectedSize == variations[i].size
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: selectedSize == variations[i].size
                  ? darkRedSmooth
                  : Colors.grey),
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
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: selectedColor == color ? darkRedSmooth : Colors.grey,
              width: 0.5,
            )),
        labelStyle: TextStyle(
            fontSize: subtitleFontSizeStyle - 4,
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

  FittedBox stockWidget({int totalQuantity, bool available}) {
    String text = (totalQuantity == 0)
        ? "Sold Out! \nYou can check back in few days!"
        : (available)
            ? (totalQuantity == 2)
                ? "Only 2 left"
                : (totalQuantity == 1)
                    ? "One in Market Product"
                    : "In Stock"
            : "The product is unavailable right now, check back in few days";

    return FittedBox(
      alignment: Alignment.centerLeft,
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: TextStyle(
            fontSize: titleFontSizeStyle - 2,
            color: (available) ? green : logoRed,
            fontWeight: FontWeight.w600),
      ),
    );
  }

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
    photosKey = UniqueKey();
    uniqueKey = UniqueKey();
  }

  @override
  void initState() {
    setupProductDetails(widget?.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ProductIndividualViewModel>.withConsumer(
      viewModel: ProductIndividualViewModel(),
      onModelReady: (model) => model.init(productData?.account?.key,
          productId: productId, productName: productName),
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundWhiteCreamColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundWhiteCreamColor,
          iconTheme: IconThemeData(color: appBarIconColor),
          automaticallyImplyLeading: !widget.fromCart,
          title: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: (!(widget.fromCart))
                  ? SvgPicture.asset(
                      "assets/svg/logo.svg",
                      color: logoRed,
                      height: 35,
                      width: 35,
                    )
                  : InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(FontAwesomeIcons.chevronDown, size: 30),
                    ),
            ),
          ),
          actions: <Widget>[
            if (!(widget.fromCart))
              IconButton(
                onPressed: () {
                  model.cart();
                },
                icon: CartIconWithBadge(
                  count:
                      Provider.of<CartCountSetUp>(context, listen: true).count,
                  iconColor: appBarIconColor,
                ),
              )
          ],
        ),
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: false,
          child: Stack(
            children: [
              SmartRefresher(
                enablePullDown: true,
                footer: null,
                header: WaterDropHeader(
                  waterDropColor: logoRed,
                  refresh: Container(),
                  complete: Container(),
                ),
                controller: refreshController,
                onRefresh: () async {
                  Product product = await model.refreshProduct(productData.key);
                  setState(() {
                    setupProductDetails(product);
                  });
                  await Future.delayed(Duration(milliseconds: 100));
                  refreshController.refreshCompleted();
                },
                child: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          productNameAndDescInfo(productName,
                              productData?.variations ?? [], model),
                          SizedBox(
                            height: 15,
                          ),
                          Stack(children: <Widget>[
                            HomeSlider(
                              key: photosKey,
                              imgList: imageURLs,
                              aspectRatio: 1,
                            ),
                          ]),
                          verticalSpace(20),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: priceInfo(
                                  productPrice,
                                  productDiscount,
                                  saved,
                                  showPrice:
                                      (available && (totalQuantity != 0)),
                                  isClothMeterial:
                                      (productData.category.id == 13),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (Provider.of<WhishListSetUp>(context,
                                              listen: false)
                                          .list
                                          .indexOf(productId) !=
                                      -1) {
                                    await model.removeFromWhishList(productId);
                                    Provider.of<WhishListSetUp>(context,
                                            listen: false)
                                        .removeFromWhishList(productId);
                                  } else {
                                    await model.addToWhishList(productId);
                                    Provider.of<WhishListSetUp>(context,
                                            listen: false)
                                        .addToWhishList(productId);
                                    Get.snackbar('Added to Your wishlist', '',
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(30),
                                  //     color: Colors.white.withOpacity(1)),
                                  child: WishListIcon(
                                    filled: Provider.of<WhishListSetUp>(context,
                                                listen: true)
                                            .list
                                            .indexOf(productId) !=
                                        -1,
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Share.share(
                                    await _dynamicLinkService
                                        .createLink(productLink + productId),
                                  );
                                  await model.shareProductEvent(
                                      productId: productId,
                                      productName: productName);
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Image.asset(
                                    "assets/images/share_icon.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(),
                          // true || tags.length == 0
                          //     ? Container()
                          //     : Column(
                          //         children: <Widget>[
                          //           verticalSpace(10),
                          //           allTags(tags),
                          //         ],
                          //       ),
                          if (productDiscount != 0.0) verticalSpace(5),
                          if (productDiscount != 0.0)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Save \u20B9$saved',
                                style: TextStyle(
                                    fontSize: subtitleFontSizeStyle - 2,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (available && (totalQuantity != 0))
                            verticalSpace(5),
                          if (available && (totalQuantity != 0))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("(Inclusive of taxes and charges)"),
                                if ((model?.reviews?.ratingAverage?.rating ??
                                        0) >
                                    0)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.scaleDown,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 12.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${model?.reviews?.ratingAverage?.rating?.toString() ?? 0} ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          verticalSpace(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: stockWidget(
                                      totalQuantity: totalQuantity,
                                      available: available),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                    onTap: () async =>
                                        await DialogService.showCustomDialog(
                                          AlertDialog(
                                            content: Text(
                                                "Please read the terms and conditions carefully. We only take returns & refund requests only in case of an error on our end. We don’t allow cancellations."),
                                          ),
                                        ),
                                    child: Icon(Icons.help_outline_rounded)),
                              ),
                            ],
                          ),
                          if (available) verticalSpace(20),
                          if (available)
                            Row(
                              children: <Widget>[
                                Text(
                                  "Delivery By :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitleFontSizeStyle - 3,
                                  ),
                                ),
                                horizontalSpaceSmall,
                                Text(
                                  shipment,
                                  style: TextStyle(
                                    fontSize: subtitleFontSizeStyle - 3,
                                  ),
                                ),
                              ],
                            ),
                          if (productData.whoMadeIt.id == 2)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 8.0),
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: logoRed,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Hand-Crafted",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // verticalSpaceMedium,
                          // Center(
                          //   child: GestureDetector(
                          //     onTap: () async => await model
                          //         .goToProductListPage(ProductPageArg(
                          //             subCategory: model.selleDetail.name,
                          //             queryString:
                          //                 "accountKey=${model.selleDetail.key};",
                          //             sellerPhoto:
                          //                 "$SELLER_PHOTO_BASE_URL/${model.selleDetail.key}")),
                          //     child: Container(
                          //       width: MediaQuery.of(context).size.width * 0.9,
                          //       padding: EdgeInsets.symmetric(vertical: 6),
                          //       decoration: BoxDecoration(
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.grey.withOpacity(0.5),
                          //               spreadRadius: 2,
                          //               blurRadius: 4,
                          //               offset: Offset(
                          //                   0, 3), // changes position of shadow
                          //             ),
                          //           ],
                          //           color: primaryColor,
                          //           borderRadius: BorderRadius.circular(40)),
                          //       child: Center(
                          //         child: Text(
                          //           "Explore Designer's Collection",
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: subtitleFontSizeStyle,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          if (available) verticalSpace(20),
                          if (available)
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(curve15),
                                ),
                                elevation: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(20),
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
                                                    "Select Size",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            subtitleFontSizeStyle),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    _showDialog(
                                                        context,
                                                        model.selleDetail.key,
                                                        productData?.category
                                                                ?.id ??
                                                            1);
                                                  },
                                                  child: Text(
                                                    "size chart",
                                                    style: TextStyle(
                                                        color: darkRedSmooth,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontSize:
                                                            subtitleFontSizeStyle -
                                                                3),
                                                  ),
                                                )
                                              ],
                                            ),
                                      verticalSpace(5),
                                      allSizes(variations),
                                      selectedSize == ""
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                selectedSize == "N/A"
                                                    ? verticalSpace(0)
                                                    : verticalSpace(20),
                                                Text(
                                                  "Select Color",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          subtitleFontSizeStyle),
                                                ),
                                                verticalSpace(5),
                                                allColors(
                                                  variations,
                                                ),
                                              ],
                                            ),
                                      verticalSpace(10),
                                      selectedColor == ""
                                          ? Container()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    "Select ${(productData.category.id == 13) ? 'No. of Meters' : 'Qty'}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            subtitleFontSizeStyle),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Container(
                                                      height: 40,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0,
                                                              horizontal: 0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  darkRedSmooth),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          IconButton(
                                                            color: selectedQty ==
                                                                    0
                                                                ? Colors.grey
                                                                : darkRedSmooth,
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
                                                                fontSize:
                                                                    titleFontSizeStyle,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          IconButton(
                                                            color: maxQty ==
                                                                    selectedQty
                                                                ? Colors.grey
                                                                : darkRedSmooth,
                                                            icon:
                                                                Icon(Icons.add),
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
                                                ),
                                              ],
                                            ),
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
                                                    subtitleFontSizeStyle - 7,
                                              ),
                                            ),
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
                                                            7,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          if (available) verticalSpace(20),
                          if (available)
                            Center(
                              child: GestureDetector(
                                onTap: disabledAddToCartBtn ||
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
                                                  onPressed:
                                                      DialogService.popDialog,
                                                  child: Text("OK")),
                                            ],
                                          ),
                                        )
                                    : () async {
                                        setState(() {
                                          disabledAddToCartBtn = true;
                                        });

                                        var res = await model.addToCart(
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
                                          Provider.of<CartCountSetUp>(context,
                                                  listen: false)
                                              .incrementCartCount();
                                        }

                                        setState(() {
                                          disabledAddToCartBtn = false;
                                        });
                                      },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: logoRed,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(
                                    child: Text(
                                      "ADD TO BAG",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: subtitleFontSizeStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          verticalSpace(30),
                          Text(
                            "   Product Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSizeStyle),
                          ),
                          verticalSpace(5),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fontSize: subtitleFontSizeStyle - 3,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        verticalSpaceSmall,
                                        Text(
                                          productData?.description ?? "",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: subtitleFontSizeStyle - 5,
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
                                      product: productData, model: model),
                                ],
                              ),
                            ),
                          ),
                          verticalSpaceMedium,
                          ReviewWidget(
                            id: productId,
                            expanded: true,
                          ),
                          verticalSpace(20),
                          Text(
                            "   Sold By",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSizeStyle),
                          ),
                          if (model?.selleDetail?.subscriptionTypeId != 2)
                            verticalSpace(5),
                          GestureDetector(
                            onTap: () async => await goToSellerProfile(model),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              model.selleDetail?.name ?? "",
                                              style: TextStyle(
                                                  fontSize:
                                                      subtitleFontSizeStyle,
                                                  color: darkRedSmooth),
                                            ),
                                            if (model?.selleDetail
                                                    ?.subscriptionTypeId !=
                                                2)
                                              verticalSpace(10),
                                            if (model?.selleDetail
                                                    ?.subscriptionTypeId !=
                                                2)
                                              Center(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  child: Divider(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                            if (model?.selleDetail
                                                    ?.subscriptionTypeId !=
                                                2)
                                              verticalSpace(10),
                                            if (model?.selleDetail
                                                    ?.subscriptionTypeId !=
                                                2)
                                              Text(
                                                Tools.getTruncatedString(
                                                    100,
                                                    model.selleDetail?.bio ??
                                                        ""),
                                                style: TextStyle(
                                                    fontSize:
                                                        subtitleFontSizeStyle -
                                                            5,
                                                    color: Colors.grey),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Icon(
                                        Icons.navigate_next,
                                        color: lightGrey,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          verticalSpace(20),
                          Text(
                            "   Recommended Products",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSizeStyle),
                          ),

                          // bottomTag()
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // rattingsInfo(),
                          // SizedBox(
                          //   height: 40,
                          // ),
                          // otherDetails(),
                          // verticalSpaceMedium,
                          // ReviewWidget(productId),

                          verticalSpace(5),
                          SizedBox(
                            height: 200,
                            child: GridListWidget<Products, Product>(
                              key: uniqueKey,
                              context: context,
                              filter: ProductFilter(
                                  existingQueryString:
                                      "subCategory=${productData?.category?.id ?? -1};"),
                              gridCount: 2,
                              emptyListWidget: Container(),
                              viewModel: ProductsGridViewBuilderViewModel(
                                filteredProductKey: productData?.key,
                                randomize: true,
                              ),
                              childAspectRatio: 1.35,
                              scrollDirection: Axis.horizontal,
                              disablePagination: false,
                              tileBuilder: (BuildContext context, productData,
                                  index, onUpdate, onDelete) {
                                return ProductTileUI(
                                  data: productData,
                                  onClick: () =>
                                      model.goToProductPage(productData),
                                  index: index,
                                  cardPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                );
                              },
                            ),
                          ),
                          if (showMoreFromDesigner) verticalSpace(20),
                          if (showMoreFromDesigner)
                            Text(
                              "   More From Designer",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSizeStyle),
                            ),
                          if (showMoreFromDesigner) verticalSpace(5),
                          if (showMoreFromDesigner)
                            SizedBox(
                              height: 200,
                              child: GridListWidget<Products, Product>(
                                key: uniqueKey,
                                context: context,
                                filter: ProductFilter(
                                    existingQueryString: productData
                                                ?.account?.key !=
                                            null
                                        ? "accountKey=${productData?.account?.key};"
                                        : ""),
                                gridCount: 2,
                                viewModel: ProductsGridViewBuilderViewModel(
                                  filteredProductKey: productData?.key,
                                  randomize: true,
                                ),
                                childAspectRatio: 1.35,
                                emptyListWidget: Container(),
                                onEmptyList: () async {
                                  await Future.delayed(
                                      Duration(milliseconds: 500),
                                      () => setState(() {
                                            showMoreFromDesigner = false;
                                          }));
                                },
                                scrollDirection: Axis.horizontal,
                                disablePagination: false,
                                tileBuilder: (BuildContext context, productData,
                                    index, onUpdate, onDelete) {
                                  return ProductTileUI(
                                    data: productData,
                                    onClick: () =>
                                        model.goToProductPage(productData),
                                    index: index,
                                    cardPadding:
                                        EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  );
                                },
                              ),
                            ),
                          // bottomTag()
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // rattingsInfo(),
                          // SizedBox(
                          //   height: 40,
                          // ),
                          // otherDetails(),
                          // verticalSpaceMedium,
                          // ReviewWidget(productId),
                          verticalSpaceMedium,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (available && !widget.fromCart)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FittedBox(
                      child: Center(
                        child: GestureDetector(
                          onTap: (selectedQty == 0 ||
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
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text("OK")),
                                      ],
                                    ),
                                  )
                              : () async {
                                  var res = await model.buyNow(productData,
                                      selectedQty, selectedSize, selectedColor);
                                  if (res != null && res == true) {
                                    Provider.of<CartCountSetUp>(context,
                                            listen: false)
                                        .incrementCartCount();

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: CartView(
                                            productId: productData?.key),
                                        type: PageTransitionType.rightToLeft,
                                      ),
                                    );
                                  }
                                },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: textIconOrange,
                                borderRadius: BorderRadius.circular(40)),
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
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDescriptionTable extends StatelessWidget {
  const ProductDescriptionTable({
    Key key,
    @required this.product,
    @required this.model,
  }) : super(key: key);

  final ProductIndividualViewModel model;
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
      future: model.getLookups(),
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
            padding: EdgeInsets.all(10.0),
            child: Text(
              productDetailsKey,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: subtitleFontSizeStyle - 1,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              productDetailsValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: subtitleFontSizeStyle - 1,
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
