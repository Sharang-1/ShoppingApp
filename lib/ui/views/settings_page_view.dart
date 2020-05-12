import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/home_view_list.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/widgets/drawer.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/cart_icon_badge.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key key}) : super(key: key);

  Map<int, String> buttonNameMap = {
    1: "Send Feedback",
    2: "Customer Service",
    3: "Legal",
    4: "Terms & Conditions",
  };
  Map<int, String> buttonToURLMap = {
    1: 'https://dzor.in/policy.html?source=c',
    2: 'https://dzor.in/policy.html?source=c',
    3: 'https://dzor.in/policy.html?source=c',
    4: 'https://dzor.in/policy.html?source=c',
  };

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundWhiteCreamColor,
            // drawer: HomeDrawer(),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: logoRed, width: 2.5)),
              onPressed: model.logout,
              label: CustomText(
                "Logout",
                color: logoRed,
                isBold: true,
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Image.asset(
                "assets/images/logo_red.png",
                height: 35,
                width: 35,
              ),
              iconTheme: IconThemeData(
                color: appBarIconColor,
              ),
              backgroundColor: backgroundWhiteCreamColor,
            ),
            body: SafeArea(
              top: false,
              left: false,
              right: false,
              child: SingleChildScrollView(
                  child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    verticalSpace(20),
                    Text(
                      "Settings",
                      style: TextStyle(
                          fontFamily: headingFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                    verticalSpace(50),
                    Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 8,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      verticalSpaceTiny_0,
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: RaisedButton(
                                                elevation: 0,
                                                onPressed: () {
                                                  const url =
                                                      'https://dzor.in/policy.html?source=c';
                                                  _launchURL(url);
                                                },
                                                color: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  // side: BorderSide(
                                                  //     color: Colors.black, width: 0.5)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  child: CustomText(
                                                    "Rate The App ",
                                                    fontSize: 20,
                                                    isBold: true,
                                                    color: Colors.grey[800],
                                                  ),
                                                )))
                                      ]),
                                      Opacity(
                                          opacity: 0.9,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Divider())),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: buttonNameMap.keys
                                              .map((int key) {
                                                return <Widget>[
                                                  Row(children: <Widget>[
                                                    Expanded(
                                                        child: FlatButton(
                                                            splashColor: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.1),
                                                            onPressed: () {
                                                              _launchURL(
                                                                  buttonToURLMap[
                                                                      key]);
                                                            },
                                                            child: CustomText(
                                                              buttonNameMap[
                                                                  key],
                                                              isBold: true,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .grey[800],
                                                            )))
                                                  ]),
                                                  key < 4
                                                      ? Opacity(
                                                          opacity: 0.9,
                                                          child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6,
                                                              child: Divider()))
                                                      : Container()
                                                ];
                                              })
                                              .expand((element) => element)
                                              .toList())
                                    ],
                                  ),
                                ))))
                  ],
                ),
              )),
            )));
  }

  _launchURL(url) async {
    //const url = 'https://www.google.co.in';
    //print(canLaunch(url));
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
