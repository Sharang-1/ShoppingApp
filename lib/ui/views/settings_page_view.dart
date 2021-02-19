import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/bottom_tag.dart';
import 'package:compound/ui/shared/app_colors.dart';
import '../shared/shared_styles.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key key}) : super(key: key);

  final Map<int, String> buttonNameMap = {
    1: "Customer Service",
    2: "Terms & Conditions",
  };
  final Map<int, String> buttonToURLMap = {
    1: 'https://dzor.in/#/contact-us',
    2: 'https://dzor.in/#/terms-of-use',
  };
  final AppBar appbar = AppBar(
    elevation: 0,
    centerTitle: true,
    title: SvgPicture.asset(
      "assets/svg/logo.svg",
      color: logoRed,
      height: 35,
      width: 35,
    ),
    iconTheme: IconThemeData(
      color: appBarIconColor,
    ),
    backgroundColor: backgroundWhiteCreamColor,
  );

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundWhiteCreamColor,
            // drawer: HomeDrawer(),

            appBar: appbar,
            body: SafeArea(
              top: false,
              left: false,
              right: false,
              bottom: false,
              child: SingleChildScrollView(
                  child: BottomTag(
                appBarHeight: appbar.preferredSize.height,
                statusBarHeight: MediaQuery.of(context).padding.top,
                childWidget: Padding(
                  padding: EdgeInsets.only(
                      left: screenPadding,
                      right: screenPadding,
                      top: 10,
                      bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      verticalSpace(20),
                      Text(
                        "Settings",
                        style: TextStyle(
                            fontFamily: headingFont,
                            fontWeight: FontWeight.w700,
                            fontSize: headingFontSizeStyle),
                      ),
                      verticalSpace(50),
                      Align(
                          child: Container(
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(curve15)),
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
                                                        BorderRadius.circular(
                                                            30),
                                                    // side: BorderSide(
                                                    //     color: Colors.black, width: 0.5)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12),
                                                    child: CustomText(
                                                      "Rate The App ",
                                                      fontSize:
                                                          titleFontSizeStyle,
                                                      isBold: true,
                                                      color: Colors.grey[800],
                                                    ),
                                                  )))
                                        ]),
                                        Row(children: <Widget>[
                                          Expanded(
                                              child: RaisedButton(
                                                  elevation: 0,
                                                  onPressed: () {
                                                    const url =
                                                        'mailto:admin@dzor.in';
                                                    _launchURL(url);
                                                  },
                                                  color: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    // side: BorderSide(
                                                    //     color: Colors.black, width: 0.5)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12),
                                                    child: CustomText(
                                                      "Send Feedback ",
                                                      fontSize:
                                                          titleFontSizeStyle,
                                                      isBold: true,
                                                      color: Colors.grey[800],
                                                    ),
                                                  )))
                                        ]),
                                        // Opacity(
                                        //     opacity: 0.9,
                                        //     child: SizedBox(
                                        //         width: MediaQuery.of(context)
                                        //                 .size
                                        //                 .width *
                                        //             0.6,
                                        //         child: Divider())),
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
                                                                fontSize:
                                                                    titleFontSizeStyle,
                                                                color: Colors
                                                                    .grey[800],
                                                              )))
                                                    ]),
                                                    // key < 4
                                                    //     ? Opacity(
                                                    //         opacity: 0.9,
                                                    //         child: SizedBox(
                                                    //             width: MediaQuery.of(
                                                    //                         context)
                                                    //                     .size
                                                    //                     .width *
                                                    //                 0.6,
                                                    //             child:
                                                    //                 Divider()))
                                                    //     : Container()
                                                  ];
                                                })
                                                .expand((element) => element)
                                                .toList())
                                      ],
                                    ),
                                  )))),
                      verticalSpace(50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(curve30),
                                side: BorderSide(color: logoRed, width: 2.5)),
                            onPressed: model.logout,
                            label: CustomText(
                              "Logout",
                              color: logoRed,
                              isBold: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
