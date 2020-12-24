// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:compound/models/cart.dart';
// import 'package:compound/models/categorys.dart';
// import 'package:compound/ui/views/categories_view.dart';
// import 'package:compound/ui/widgets/GridListWidget.dart';
// import 'package:compound/ui/widgets/categoryTileUI.dart';
// import 'package:compound/viewmodels/grid_view_builder_view_models/categories_view_builder_view_model.dart';
import 'package:compound/constants/server_urls.dart';
import 'package:compound/models/categorys.dart';
import 'package:compound/models/grid_view_builder_filter_models/categoryFilter.dart';
import 'package:compound/models/grid_view_builder_filter_models/productFilter.dart';
import 'package:compound/models/grid_view_builder_filter_models/sellerFilter.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/ui/views/promotion_products_view.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/categoryTileUI.dart';
import 'package:compound/ui/widgets/promotion_slider.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/categories_view_builder_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/sellers_grid_view_builder_view.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';

import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/widgets/sellerTileUi.dart';

import '../shared/shared_styles.dart';
import '../widgets/top_picks_deals_card.dart';

class HomeViewList extends StatefulWidget {
  final HomeViewModel model;
  final gotoCategory;

  HomeViewList({
    Key key,
    @required this.gotoCategory,
    this.model,
  }) : super(key: key);

  @override
  _HomeViewListState createState() => _HomeViewListState();
}

class _HomeViewListState extends State<HomeViewList> {
  final productUniqueKey = new UniqueKey();
  List<Promotion> bottomPromotion = [];
  bool bottomPromotionUpdated = false;

  final Map<String, String> sellerCardDetails = {
    "name": "Sejal Works",
    "type": "SELLER",
    "sells": "Dresses , Kurtas",
    "discount": "10% Upto 30%",
  };

  final Map<String, String> boutiqueCardDetails = {
    "name": "Ketan Works",
    "type": "BOUTIQUE",
    "Speciality": "Spec1 , Spec2 , Spec3 , Spec4 , Spec5",
    "WorksOffered": "Work1 , Work2 , Work3 , Work4",
  };

  @override
  Widget build(BuildContext context) {
    // const double headingFontSize=25;
    // const double titleFontSize=20;
    const double subtitleFontSize = subtitleFontSizeStyle + 2;

    return Container(
      padding:
          EdgeInsets.fromLTRB(screenPadding - 15, 5, screenPadding - 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: widget.model.getPromotions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Text("No Data"),
                  ),
                );
              }

              var data = snapshot.data as List<Promotion>;

              bottomPromotion = data
                  .where(
                      (element) => element.position.toLowerCase() == "bottom")
                  .toList();

              data = data
                  .where((element) => element.position.toLowerCase() == "top")
                  .toList();

              return PromotionSlider(promotions: data);
            },
          ),
          verticalSpace(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text('Shop By Category',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700)),
              ),
              InkWell(
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: subtitleFontSize - 8,
                    fontWeight: FontWeight.bold,
                    color: textIconBlue,
                  ),
                ),
                onTap: () {
                  widget.gotoCategory();
                },
              ),
            ],
          ),
          verticalSpace(20),
          SizedBox(
            height: 140,
            child: GridListWidget<Categorys, Category>(
              key: UniqueKey(),
              context: context,
              filter: new CategoryFilter(),
              gridCount: 1,
              childAspectRatio: 0.5,
              viewModel: CategoriesGridViewBuilderViewModel(),
              disablePagination: true,
              scrollDirection: Axis.horizontal,
              emptyListWidget: Container(),
              tileBuilder:
                  (BuildContext context, data, index, onDelete, onUpdate) {
                return GestureDetector(
                  onTap: () => widget.model.showProducts(
                    data.filter,
                    data.name,
                  ),
                  child: CategoryTileUI(
                    data: data,
                  ),
                );
              },
            ),
          ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Top Picks for you',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          SizedBox(
            height: 170,
            child: GridListWidget<Products, Product>(
              key: productUniqueKey,
              context: context,
              filter: ProductFilter(),
              gridCount: 2,
              viewModel: ProductsGridViewBuilderViewModel(randomize: true),
              childAspectRatio: 0.65,
              scrollDirection: Axis.horizontal,
              disablePagination: true,
              tileBuilder: (BuildContext context, productData, index, onUpdate,
                  onDelete) {
                var product = productData as Product;
                return GestureDetector(
                  onTap: () => widget.model.goToProductPage(productData),
                  child: TopPicksAndDealsCard(
                    data: {
                      "key": product?.key ?? "Test",
                      "name": product?.name ?? "Test",
                      "price": product?.price ?? 0,
                      "discount": product?.discount ?? 0,
                      "photo": product?.photo?.photos?.first?.name,
                      "sellerName": product?.seller?.name ?? "",
                      "isDiscountAvailable":
                          product?.discount != null && product.discount != 0
                              ? "true"
                              : null,
                    },
                  ),
                );
              },
            ),
          ),
          if (bottomPromotion != null && bottomPromotion.length > 0)
            verticalSpace(40),
          if (bottomPromotion != null && bottomPromotion.length > 0)
            GestureDetector(
              onTap: () {
                var promoTitle = bottomPromotion[0]?.name;
                List<String> productIds = bottomPromotion[0]
                    ?.products
                    ?.map((e) => e.toString())
                    ?.toList();
                print(productIds);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => PromotionProduct(
                      productIds: productIds ?? [],
                      promotionTitle: promoTitle,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width - 40) * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(curve15),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        bottomPromotion[0]?.banner != null
                            ? "$PROMOTION_PHOTO_BASE_URL/${bottomPromotion[0]?.key}"
                            : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Best Deals Today',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          SizedBox(
            height: 170,
            child: GridListWidget<Products, Product>(
              key: productUniqueKey,
              context: context,
              filter: ProductFilter(minDiscount: 5),
              gridCount: 2,
              viewModel: ProductsGridViewBuilderViewModel(randomize: true),
              childAspectRatio: 0.57,
              scrollDirection: Axis.horizontal,
              disablePagination: true,
              tileBuilder: (BuildContext context, productData, index, onUpdate,
                  onDelete) {
                var product = productData as Product;
                return GestureDetector(
                  onTap: () => widget.model.goToProductPage(productData),
                  child: TopPicksAndDealsCard(
                    data: {
                      "key": product?.key ?? "Test",
                      "name": product?.name ?? "Test",
                      "price": product?.price ?? 0,
                      "discount": product?.discount ?? 0,
                      "photo": product?.photo?.photos?.first?.name,
                      "sellerName": product?.seller?.name ?? "",
                      "isDiscountAvailable":
                          product?.discount != null && product.discount != 0
                              ? "true"
                              : null,
                    },
                  ),
                );
              },
            ),
          ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Boutiques Near You',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          SizedBox(
            height: 190,
            child: GridListWidget<Sellers, Seller>(
              key: UniqueKey(),
              context: context,
              filter: new SellerFilter(),
              gridCount: 1,
              childAspectRatio: 0.65,
              viewModel: SellersGridViewBuilderViewModel(
                  boutiquesOnly: true, random: true),
              disablePagination: true,
              scrollDirection: Axis.horizontal,
              emptyListWidget: Container(),
              tileBuilder:
                  (BuildContext context, data, index, onDelete, onUpdate) {
                return GestureDetector(
                  onTap: () => {},
                  child: SellerTileUi(
                    data: data,
                    fromHome: true,
                  ),
                );
              },
            ),
          ),
          if (bottomPromotion != null && bottomPromotion.length > 1)
            verticalSpace(40),
          if (bottomPromotion != null && bottomPromotion.length > 1)
            GestureDetector(
              onTap: () {
                var promoTitle = bottomPromotion[0]?.name;
                List<String> productIds = bottomPromotion[1]
                    ?.products
                    ?.map((e) => e.toString())
                    ?.toList();
                print(productIds);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => PromotionProduct(
                      productIds: productIds ?? [],
                      promotionTitle: promoTitle,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width - 40) * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(curve15),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        bottomPromotion[0]?.banner != null
                            ? "$PROMOTION_PHOTO_BASE_URL/${bottomPromotion[1]?.key}"
                            : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Product Delivered Same Day',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          SizedBox(
            height: 170,
            child: GridListWidget<Products, Product>(
              key: productUniqueKey,
              context: context,
              filter: ProductFilter(),
              gridCount: 2,
              viewModel: ProductsGridViewBuilderViewModel(
                  randomize: true, sameDayDelivery: true),
              childAspectRatio: 0.65,
              scrollDirection: Axis.horizontal,
              disablePagination: true,
              tileBuilder: (BuildContext context, productData, index, onUpdate,
                  onDelete) {
                var product = productData as Product;
                return GestureDetector(
                  onTap: () => widget.model.goToProductPage(productData),
                  child: TopPicksAndDealsCard(
                    data: {
                      "key": product?.key ?? "Test",
                      "name": product?.name ?? "Test",
                      "price": product?.price ?? 0,
                      "discount": product?.discount ?? 0,
                      "photo": product?.photo?.photos?.first?.name,
                      "sellerName": product?.seller?.name ?? "",
                      "isDiscountAvailable":
                          product?.discount != null && product.discount != 0
                              ? "true"
                              : null,
                    },
                  ),
                );
              },
            ),
          ),
          verticalSpace(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text('Popular Cateogories\nNear You',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w700)),
              ),
              InkWell(
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: subtitleFontSize - 8,
                    fontWeight: FontWeight.bold,
                    color: textIconBlue,
                  ),
                ),
                onTap: () {
                  widget.gotoCategory();
                },
              ),
            ],
          ),
          verticalSpace(20),
          SizedBox(
            height: 140,
            child: GridListWidget<Categorys, Category>(
              key: UniqueKey(),
              context: context,
              filter: new CategoryFilter(),
              gridCount: 1,
              childAspectRatio: 0.5,
              viewModel:
                  CategoriesGridViewBuilderViewModel(popularCategories: true),
              disablePagination: true,
              scrollDirection: Axis.horizontal,
              emptyListWidget: Container(),
              tileBuilder:
                  (BuildContext context, data, index, onDelete, onUpdate) {
                return GestureDetector(
                  onTap: () => widget.model.showProducts(
                    data.filter,
                    data.name,
                  ),
                  child: CategoryTileUI(
                    data: data,
                  ),
                );
              },
            ),
          ),
          if (bottomPromotion != null && bottomPromotion.length > 2)
            verticalSpace(40),
          if (bottomPromotion != null && bottomPromotion.length > 2)
            GestureDetector(
              onTap: () {
                var promoTitle = bottomPromotion[0]?.name;
                List<String> productIds = bottomPromotion[2]
                    ?.products
                    ?.map((e) => e.toString())
                    ?.toList();
                print(productIds);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => PromotionProduct(
                      productIds: productIds ?? [],
                      promotionTitle: promoTitle,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SizedBox(
                  height: (MediaQuery.of(context).size.width - 40) * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(curve15),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        bottomPromotion[0]?.banner != null
                            ? "$PROMOTION_PHOTO_BASE_URL/${bottomPromotion[2]?.key}"
                            : "https://templates.designwizard.com/663467c0-7840-11e7-81f8-bf6782823ae8.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Sellers Delivering To You',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          SizedBox(
            height: 190,
            child: GridListWidget<Sellers, Seller>(
              key: UniqueKey(),
              context: context,
              filter: new SellerFilter(),
              gridCount: 1,
              childAspectRatio: 0.65,
              viewModel: SellersGridViewBuilderViewModel(random: true),
              disablePagination: true,
              scrollDirection: Axis.horizontal,
              emptyListWidget: Container(),
              tileBuilder:
                  (BuildContext context, data, index, onDelete, onUpdate) {
                return GestureDetector(
                  onTap: () => {},
                  child: SellerTileUi(
                    data: data,
                    fromHome: true,
                  ),
                );
              },
            ),
          ),
          /*
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Best Deals Today',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: bestDealsDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: bestDealsDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          verticalSpace(40),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
                height: (MediaQuery.of(context).size.width - 40) * 0.8,
                width: MediaQuery.of(context).size.width - 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(curve15),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://mir-s3-cdn-cf.behance.net/projects/404/8417d853121653.Y3JvcCwxNjAzLDEyNTUsMCww.png"),
                  ),
                )),
          ),
          verticalSpace(40),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Products Delivered The Same Day',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          Container(
            height: 180,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: sameDayDeliveryDataMap
                    .map(
                      (e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        ),
                      ),
                    )
                    .toList()),
          ),
          verticalSpace(30),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Products That Awed Us',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: productAwedDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          Container(
            height: 150,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: productAwedDataMap
                    .map((e) => SizedBox(
                        width: 250,
                        child: TopPicksAndDealsCard(
                          data: e,
                        )))
                    .toList()),
          ),
          verticalSpace(30),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Products Delivered The Same Day',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories
                    .map((category) => SizedBox(
                        width: 192,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                          child: InkWell(
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.grey,
                              child: Stack(children: <Widget>[
                                Positioned.fill(
                                    child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.srcATop),
                                  child: FadeInImage.assetNetwork(
                                      fit: BoxFit.fill,
                                      fadeInCurve: Curves.easeIn,
                                      placeholder:
                                          'assets/images/placeholder.png',
                                      image:
                                          // photoName == null?

                                          'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                                      // : photoName

                                      ),
                                )),
                                Positioned.fill(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CustomText(category,
                                            align: TextAlign.center,
                                            color: Colors.white,
                                            fontSize: subtitleFontSizeStyle - 2,
                                            fontWeight: FontWeight.w600),
                                      ]),
                                ))
                              ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(curve15),
                              ),
                              elevation: 5,
                            ),
                            onTap: () {},
                          ),
                        )))
                    .toList(),
              )),
          verticalSpace(40),
          Row(children: <Widget>[
            Expanded(
              child: Text(
                'Sellers Delivering To You',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ]),
          verticalSpaceSmall,
          Container(
            padding: EdgeInsets.only(left: 0),
            height: 175,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
                SellerTileUi(
                  data: sellerCardDetails,
                  fromHome: true,
                ),
              ],
            ),
          ),
          verticalSpaceMedium,
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ))
          ]),
          */
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                      elevation: 5,
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             SelectAddress()));
                      },
                      color: darkRedSmooth,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(curve30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Locate Tailors ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )))
            ],
          ),
          verticalSpaceLarge_1
        ],
      ),
    );
  }
}

class CategoriesHomeList extends StatelessWidget {
  const CategoriesHomeList({
    Key key,
    @required this.categories,
    @required this.subtitleFontSize,
  }) : super(key: key);

  final List<String> categories;
  final double subtitleFontSize;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: categories
          .map((category) => SizedBox(
              width: 192,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 0, 5),
                child: InkWell(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.grey,
                    child: Stack(children: <Widget>[
                      Positioned.fill(
                          child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.srcATop),
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
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomText(category,
                                  align: TextAlign.center,
                                  color: Colors.white,
                                  fontSize: subtitleFontSize - 2,
                                  fontWeight: FontWeight.w600),
                            ]),
                      ))
                    ]),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(curve15),
                    ),
                    elevation: 5,
                  ),
                  onTap: () {},
                ),
              )))
          .toList(),
    );
  }
}
