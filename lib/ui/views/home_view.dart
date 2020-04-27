import 'package:compound/ui/views/home_view_list.dart';
import 'package:compound/ui/widgets/drawer.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
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
              backgroundColor: Colors.white,
              drawer: HomeDrawer(),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.grey[800],
                onPressed: model.logout,
                label: Text("Logout"),
              ),
              body: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  child: CustomScrollView(
                    // Add the app bar and list of items as slivers in the next steps.
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(color: Colors.black),
                        backgroundColor: Colors.white,
                        title: Center(child:Image.asset("assets/images/logo_red.png",height: 40,width: 40,)),
                        floating: true,
                        // snap: true,
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.shopping_cart,color: Colors.black,),
                            onPressed: () => model.cart(),
                          ),
                        ],

                        //Do experiment with this for Icon Button else make
                        //flexiblespace to bottom
                        expandedHeight: 2 * kToolbarHeight,
                        forceElevated: true,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(
                            top: 1.4 * kToolbarHeight,
                          ),
                          child: PreferredSize(
                            preferredSize: const Size.fromHeight(50),
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        model.search();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            border: Border.all(width: 1),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          child: Text("Search"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'map',
                                    icon: Icon(
                                      Icons.map,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      model.openmap();
                                    },
                                  )
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
                          (context, index) => HomeViewList(),
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
