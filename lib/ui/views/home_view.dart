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

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
      setState(() {
      key = UniqueKey();
      productKey = UniqueKey();
      });
      await Future.delayed(Duration(milliseconds: 100));
      refreshController.refreshCompleted(resetFooterState: true);
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
              preferredSize: Size.fromHeight(45),
              child: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(color: appBarIconColor),
                backgroundColor: backgroundWhiteCreamColor,
                title: Center(
                    child: SvgPicture.asset(
                  "assets/svg/logo.svg",
                  color: logoRed,
                  height: 35,
                  width: 35,
                )),
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
          child: SmartRefresher(
      enablePullDown: true,
      footer: null,
      header: WaterDropHeader(
        waterDropColor: logoRed,
        refresh: Container(),
        complete: Container(),
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      child: CustomScrollView(
              // Add the app bar and list of items as slivers in the next steps.
              slivers: <Widget>[
                SliverAppBar(
                  primary: false,
                  floating: true,
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(color: appBarIconColor),
                  backgroundColor: backgroundWhiteCreamColor,
                  actions: <Widget>[
                    IconButton(
                      tooltip: 'map',
                      icon: new Image.asset("assets/icons/map.png"),
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
                        // color: Colors.grey[200],
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

/*
 model.posts != null
  ? ListView.builder(
      itemCount: model.posts.length,
      itemBuilder: (context, index) =>
          GestureDetector(
        onTap: () => model.editPost(index),
        child: PostItem(
          post: model.posts[index],
          onDeleteItem: () => model.deletePost(index),
        ),
      ),
    )
  : Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
            Theme.of(context).secondaryHeaderColor),
      ),
    )
*/
