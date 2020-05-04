import 'package:compound/ui/views/home_view_list.dart';
import 'package:compound/ui/widgets/drawer.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';

class HomeView extends StatelessWidget {
  final searchController = TextEditingController();

  HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
              drawerEdgeDragWidth: 0,
              primary: false,
              backgroundColor: backgroundWhiteCreamColor,
              drawer: HomeDrawer(),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.grey[800],
                onPressed: model.logout,
                label: Text("Logout"),
              ),
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(color: textIconBlue),
                backgroundColor: backgroundWhiteCreamColor,
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: AppBar(
                      elevation: 0,
                      iconTheme: IconThemeData(color: textIconBlue),
                      backgroundColor: backgroundWhiteCreamColor,
                      title: Center(
                          child: Image.asset(
                        "assets/images/logo_red.png",
                        height: 40,
                        width: 40,
                      )),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
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
                  child: CustomScrollView(
                    // Add the app bar and list of items as slivers in the next steps.
                    slivers: <Widget>[
                      SliverAppBar(
                        primary: false,
                        floating: true,
                        automaticallyImplyLeading: false,
                        iconTheme: IconThemeData(color: textIconBlue),
                        backgroundColor: backgroundWhiteCreamColor,
                        actions: <Widget>[
                          IconButton(
                            tooltip: 'map',
                            icon: Icon(
                              Icons.map,
                              color: textIconBlue,
                            ),
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
                              child: Text(
                                "Search",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.normal),
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
                            child: HomeViewList(),
                          ),
                          childCount: 1,
                        ),
                      ),
                    ],
                  )
                  // Builds 1000 ListTiles
                  ),
            ));
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
