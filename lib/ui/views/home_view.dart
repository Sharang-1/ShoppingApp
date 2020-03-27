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
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Center(child: Text("DZOR")),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {},
                  ),
                ],
                bottom: PreferredSize(
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
                                      borderRadius: BorderRadius.circular(7),
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
                            IconButton(tooltip: 'map', icon: Icon(Icons.map, color: Colors.white), onPressed: () {})
                          ],
                        ))),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.grey[800],
                onPressed: model.logout,
                label: Text("Logout"),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: SingleChildScrollView(
                      child: null,
                    ))
                  ],
                ),
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
