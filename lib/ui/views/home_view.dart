import 'package:compound/models/CartCountSetUp.dart';
import 'package:compound/models/LookupSetUp.dart';
import 'package:compound/models/WhishListSetUp.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/home_view_list.dart';
import 'package:compound/ui/widgets/drawer.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/cart_icon_badge.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:rating_dialog/rating_dialog.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../shared/shared_styles.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final searchController = TextEditingController();

  UniqueKey key = UniqueKey();
  UniqueKey productKey = UniqueKey();
  UniqueKey sellerKey = UniqueKey();
  UniqueKey categoryKey = UniqueKey();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      key = UniqueKey();
      productKey = UniqueKey();
      sellerKey = UniqueKey();
      categoryKey = UniqueKey();
    });
    await Future.delayed(Duration(milliseconds: 100));
    refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  void initState() {
    super.initState();
    final RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 0,
      remindDays: 2,
      remindLaunches: 2,
      googlePlayIdentifier: 'in.dzor.dzor_app',
      appStoreIdentifier: 'in.dzor.dzor-app',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int launches = preferences.getInt('rateMyApp_launches') ?? 0;
      bool doNotOpenAgain =
          preferences.getBool('rateMyApp_doNotOpenAgain') ?? false;

      if (mounted && !doNotOpenAgain && (launches > 0) && (launches % 2 == 0) && (launches % 5 == 0)) {
        await rateMyApp.showRateDialog(context, title: 'Dzor',
            // message: '',
            onDismissed: () async {
          await preferences.setBool('rateMyApp_doNotOpenAgain', true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // const double subtitleFontSize = subtitleFontSizeStyle;
    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      onModelReady: (model) async {
        final values = await model.init(context);
        Provider.of<CartCountSetUp>(context, listen: false)
            .setCartCount(values[0]);
        Provider.of<WhishListSetUp>(context, listen: false)
            .setUpWhishList(values[1]);
        Provider.of<LookupSetUp>(context, listen: false)
            .setUpLookups(values[2]);
        final lastDeliveredProduct = await model.getLastDeliveredProduct();
        if (lastDeliveredProduct != null)
          await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return RatingDialog(
                  icon: Image.network(
                    lastDeliveredProduct["image"],
                    height: 150,
                    width: 150,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/product_preloading.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  title: lastDeliveredProduct["name"],
                  description: "Tap a star to give your review.",
                  submitButton: "Submit",
                  positiveComment: "We’re glad you liked it!! 😊",
                  negativeComment:
                      "Please reach us out and help us understand your concerns!",
                  accentColor: logoRed,
                  onSubmitPressed: (int rating) async {
                    print("onSubmitPressed: rating = $rating");
                    model.postReview(
                        lastDeliveredProduct['id'], rating.toDouble());
                  },
                );
              });
      },
      builder: (context, model, child) => Scaffold(
        drawerEdgeDragWidth: 0,
        primary: false,
        backgroundColor: backgroundWhiteCreamColor,
        drawer: HomeDrawer(
          logout: () => model.logout(),
        ),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: appBarIconColor),
          backgroundColor: backgroundWhiteCreamColor,
          bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(MediaQuery.of(context).padding.top),
              child: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(color: appBarIconColor),
                backgroundColor: backgroundWhiteCreamColor,
                title: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: SvgPicture.asset(
                      "assets/svg/logo.svg",
                      color: logoRed,
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: CartIconWithBadge(
                      iconColor: appBarIconColor,
                      count: Provider.of<CartCountSetUp>(context, listen: true)
                          .count,
                    ),
                    onPressed: () => model.cart(),
                  ),
                ],
              )),

          //Do experiment with this for Icon Button else make
          //flexiblespace to bottom
        ),
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          bottom: false,
          child: SmartRefresher(
            enablePullDown: true,
            footer: null,
            header: WaterDropHeader(
              waterDropColor: logoRed,
              refresh: Container(),
              complete: Container(),
            ),
            controller: refreshController,
            onRefresh: () async {
              final values = await model.init(context);
              Provider.of<CartCountSetUp>(context, listen: false)
                  .setCartCount(values[0]);
              Provider.of<WhishListSetUp>(context, listen: false)
                  .setUpWhishList(values[1]);
              Provider.of<LookupSetUp>(context, listen: false)
                  .setUpLookups(values[2]);
              _onRefresh();
            },
            child: CustomScrollView(
              // Add the app bar and list of items as slivers in the next steps.
              slivers: <Widget>[
                SliverAppBar(
                  primary: false,
                  floating: true,
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(color: appBarIconColor),
                  backgroundColor: backgroundWhiteCreamColor,
                  pinned: true,
                  actions: <Widget>[
                    IconButton(
                      tooltip: 'map',
                      // icon: Icon(FontAwesomeIcons.mapMarkedAlt),
                      // icon: Image.asset("assets/images/location-4.png"),
                      icon: Image.asset("assets/images/dzor_map.png"),
                      onPressed: () {
                        model.openmap();
                      },
                    )
                  ],
                  title: InkWell(
                    onTap: () {
                      model.search();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: backgroundBlueGreyColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: appBarIconColor,
                            ),
                            horizontalSpaceSmall,
                            Text(
                              "Search",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontFamily: "Raleway",
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: HomeViewList(
                        gotoCategory: model.category,
                        model: model,
                        productUniqueKey: productKey,
                        sellerUniqueKey: sellerKey,
                        categoryUniqueKey: categoryKey,
                      ),
                    ),
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
