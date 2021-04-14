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
import 'package:compound/models/productPageArg.dart';
import 'package:compound/models/products.dart';
import 'package:compound/models/promotions.dart';
import 'package:compound/models/sellers.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/promotion_products_view.dart';
import 'package:compound/ui/widgets/GridListWidget.dart';
import 'package:compound/ui/widgets/categoryTileUI.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/widgets/home_view_list_header.dart';
import 'package:compound/ui/widgets/promotion_slider.dart';
import 'package:compound/ui/widgets/sellerTileUi.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/categories_view_builder_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/products_grid_view_builder_view_model.dart';
import 'package:compound/viewmodels/grid_view_builder_view_models/sellers_grid_view_builder_view.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../shared/shared_styles.dart';
import '../widgets/top_picks_deals_card.dart';

class HomeViewList extends StatefulWidget {
  final HomeViewModel model;
  final gotoCategory;
  final productUniqueKey;
  final sellerUniqueKey;
  final categoryUniqueKey;

  HomeViewList(
      {Key key,
      @required this.gotoCategory,
      this.model,
      this.productUniqueKey,
      this.sellerUniqueKey,
      this.categoryUniqueKey})
      : super(key: key);

  @override
  _HomeViewListState createState() => _HomeViewListState();
}

class _HomeViewListState extends State<HomeViewList> {
  final productUniqueKey = UniqueKey();
  final sellerUniqueKey = UniqueKey();
  final categoryUniqueKey = UniqueKey();

  List<Promotion> bottomPromotion = [];
  bool bottomPromotionUpdated = false;
  final num deliveryCharges = 35.40;

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
          verticalSpace(25),
          HomeViewListHeader(
            title: 'Shop By Category 🛍️',
            subTitle: 'Shop designer wear by specific categories',
            viewAll: () => widget.gotoCategory(),
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 140,
            child: GridListWidget<Categorys, Category>(
              key: widget.categoryUniqueKey ?? categoryUniqueKey,
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
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Boutiques Near You ✌️',
            subTitle: 'Discover designer boutiques and labels around you',
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 190,
            child: GridListWidget<Sellers, Seller>(
              key: widget.sellerUniqueKey ?? sellerUniqueKey,
              context: context,
              filter: SellerFilter(),
              gridCount: 1,
              childAspectRatio: 0.60,
              viewModel: SellersGridViewBuilderViewModel(
                  profileOnly: true, random: true, boutiquesOnly: true),
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
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Explore Designer\'s Creations',
            viewAll: () {
              widget.model.goToProductListPage(ProductPageArg(
                queryString: '',
                subCategory: '',
              ));
            },
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 220,
            child: GridListWidget<Products, Product>(
              key: widget.productUniqueKey ?? productUniqueKey,
              context: context,
              filter: ProductFilter(),
              gridCount: 2,
              viewModel:
                  ProductsGridViewBuilderViewModel(randomize: true, limit: 10),
              childAspectRatio: 1.50,
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
                      "actualCost": (product.cost.cost +
                              product.cost.convenienceCharges.cost +
                              product.cost.gstCharges.cost +
                              deliveryCharges)
                          .round(),
                      "price": (product.cost.costToCustomer + deliveryCharges)
                              .round() ??
                          0,
                      "discount": product?.cost?.productDiscount?.rate ?? 0,
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
            verticalSpace(30),
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
                      promotionId: bottomPromotion[0]?.key,
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
                  height: (MediaQuery.of(context).size.width) / 1.6,
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
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Designers Delivering To You ✨',
            subTitle: 'Check out fresh new collections of these Designers ',
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 190,
            child: GridListWidget<Sellers, Seller>(
              key: widget.sellerUniqueKey ?? sellerUniqueKey,
              context: context,
              filter: new SellerFilter(),
              gridCount: 1,
              childAspectRatio: 0.65,
              viewModel: SellersGridViewBuilderViewModel(
                sellerDeliveringToYou: true,
                random: true,
                sellerWithNoProducts: false,
              ),
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
                    toProduct: true,
                  ),
                );
              },
            ),
          ),
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Best Deals Today',
            subTitle: 'Explore great deals on designer wear and accessories!',
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 220,
            child: GridListWidget<Products, Product>(
              key: widget.productUniqueKey ?? productUniqueKey,
              context: context,
              filter: ProductFilter(minDiscount: 5),
              gridCount: 2,
              viewModel: ProductsGridViewBuilderViewModel(randomize: true),
              childAspectRatio: 1.50,
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
                      "actualCost": (product.cost.cost +
                              product.cost.convenienceCharges.cost +
                              product.cost.gstCharges.cost +
                              deliveryCharges)
                          .round(),
                      "price": (product.cost.costToCustomer + deliveryCharges)
                              .round() ??
                          0,
                      "discount": product?.cost?.productDiscount?.rate ?? 0,
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
          if (bottomPromotion != null && bottomPromotion.length > 1)
            verticalSpace(30),
          if (bottomPromotion != null && bottomPromotion.length > 1)
            GestureDetector(
              onTap: () {
                var promoTitle = bottomPromotion[1]?.name;
                List<String> productIds = bottomPromotion[1]
                    ?.products
                    ?.map((e) => e.toString())
                    ?.toList();
                print(productIds);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => PromotionProduct(
                      promotionId: bottomPromotion[1]?.key,
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
                  height: (MediaQuery.of(context).size.width) / 1.6,
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
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Quickly Delivered ⚡!',
            subTitle:
                'Get designer wear delivered home as soon as the same day',
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 220,
            child: GridListWidget<Products, Product>(
              key: widget.productUniqueKey ?? productUniqueKey,
              context: context,
              filter: ProductFilter(),
              gridCount: 2,
              viewModel: ProductsGridViewBuilderViewModel(
                  randomize: true, sameDayDelivery: true),
              childAspectRatio: 1.50,
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
                      "actualCost": (product.cost.cost +
                              product.cost.convenienceCharges.cost +
                              product.cost.gstCharges.cost +
                              deliveryCharges)
                          .round(),
                      "price": (product.cost.costToCustomer + deliveryCharges)
                              .round() ??
                          0,
                      "discount": product?.cost?.productDiscount?.rate ?? 0,
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
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Categories people are searching for 😊',
            subTitle: 'Explore the categories people are looking at',
            viewAll: () {
              widget.gotoCategory();
            },
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 140,
            child: GridListWidget<Categorys, Category>(
              key: widget.categoryUniqueKey ?? categoryUniqueKey,
              context: context,
              filter: new CategoryFilter(),
              gridCount: 1,
              childAspectRatio: 0.5,
              viewModel:
                  CategoriesGridViewBuilderViewModel(popularCategories: true, categoriesWithNoProducts: false),
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
            verticalSpace(30),
          if (bottomPromotion != null && bottomPromotion.length > 2)
            GestureDetector(
              onTap: () {
                var promoTitle = bottomPromotion[2]?.name;
                List<String> productIds = bottomPromotion[2]
                    ?.products
                    ?.map((e) => e.toString())
                    ?.toList();
                print(productIds);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => PromotionProduct(
                      promotionId: bottomPromotion[2]?.key,
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
                  height: (MediaQuery.of(context).size.width) / 1.6,
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
          verticalSpace(30),
          HomeViewListHeader(
            title: 'Top Picks for you 👗!',
            subTitle: 'Designer wear we though you might like',
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 220,
            child: GridListWidget<Products, Product>(
              key: widget.productUniqueKey ?? productUniqueKey,
              context: context,
              filter: ProductFilter(),
              gridCount: 2,
              viewModel: ProductsGridViewBuilderViewModel(randomize: true),
              childAspectRatio: 1.50,
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
                      "actualCost": (product.cost.cost +
                              product.cost.convenienceCharges.cost +
                              product.cost.gstCharges.cost +
                              deliveryCharges)
                          .round(),
                      "price": (product.cost.costToCustomer + deliveryCharges)
                              .round() ??
                          0,
                      "discount": product?.cost?.productDiscount?.rate ?? 0,
                      "photo": product?.photo?.photos?.first?.name,
                      "sellerName": product?.seller?.name ?? "",
                      "isDiscountAvailable":
                          product?.cost?.productDiscount?.rate != null &&
                                  product?.cost?.productDiscount?.rate != 0
                              ? "true"
                              : null,
                    },
                  ),
                );
              },
            ),
          ),
          verticalSpace(30),
          HomeViewListHeader(
              title: 'Discover Designers 🔝',
              subTitle: 'Discover the best designers in Ahmedabad'),
          verticalSpaceSmall,
          SizedBox(
            // height: 300,
            child: GridListWidget<Sellers, Seller>(
              key: widget.sellerUniqueKey ?? sellerUniqueKey,
              context: context,
              filter: new SellerFilter(),
              gridCount: 1,
              childAspectRatio: 1.80,
              viewModel: SellersGridViewBuilderViewModel(random: true),
              disablePagination: true,
              scrollDirection: Axis.vertical,
              emptyListWidget: Container(),
              tileBuilder:
                  (BuildContext context, data, index, onDelete, onUpdate) {
                return GestureDetector(
                  onTap: () => {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SellerTileUi(
                      data: data,
                      fromHome: true,
                    ),
                  ),
                );
              },
            ),
          ),
          verticalSpaceMedium,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                  onPressed: () {
                    widget.model.showSellers();
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: darkRedSmooth,
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(curve30),
                    ),
                  ),
                  child: Text(
                    "Search Designers",
                  ),
                ),
              ),
            ],
          ),
          verticalSpaceMedium,
          Container(
            color: Colors.grey[300],
            height: 80,
            padding:
                EdgeInsets.symmetric(horizontal: screenPadding, vertical: 10),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  "assets/svg/dzor_logo.svg",
                  color: Colors.grey[800],
                  height: 35,
                  width: 35,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Made with Love in Ahmedabad!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                // fontSize: 25,
                              ),
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
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
                          placeholder: 'assets/images/promotion_preloading.png',
                          image:
                              // photoName == null?

                              'https://images.pexels.com/photos/934070/pexels-photo-934070.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
                          // : photoName
                          ,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            'assets/images/promotion_preloading.png',
                            fit: BoxFit.fill,
                          ),
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
