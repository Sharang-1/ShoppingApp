import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/user_details_view_model.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'address_input_form_view.dart';
import 'package:compound/models/user_details.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<int, String> buttonNameMap = {
    1: "Send Feedback",
    2: "Customer Service",
    3: "Legal",
    4: "Terms & Conditions",
  };
  String nameString;
  String initialString;
  bool isButtonActive;
  bool isEditable;
  final _formKey = GlobalKey<FormState>();
  FocusNode nameFocusNode;
  // FocusNode mobileFocusNode;

  void initState() {
    super.initState();
    initialString = "Dzor";
    isButtonActive = false;
    isEditable = false;

    nameFocusNode = FocusNode();
    // mobileFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameFocusNode.dispose();
    // mobileFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<UserDetailsViewModel>.withConsumer(
        viewModel: UserDetailsViewModel(),
        onModelReady: (model) => model.getUserDetails(),
        builder: (context, model, child) => WillPopScope(
            onWillPop: () {
              if (this.isButtonActive == false) {
                Navigator.of(context).pop();
                return Future.value(true);
              }

              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: new Text("Are you sure?"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      content: new Text(
                          "Are you sure you don't want to make a change?"),
                      actions: <Widget>[
                        new FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: logoRed,
                          child: new Text("Yes"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        new FlatButton(
                          child: new CustomText(
                            "No",
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.grey[400],
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ],
                    );
                  }).then((result) {
                if (result == null) return;
                if (result) {
                  Navigator.of(context).pop();
                }
              });
            },
            child: Scaffold(
                backgroundColor: backgroundWhiteCreamColor,
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(
                        left: screenPadding,
                        right: screenPadding,
                        top: 10,
                        bottom: 10),
                    child: RaisedButton(
                        elevation: 5,
                        onPressed: () async {
                          if (isButtonActive) if (_formKey.currentState
                              .validate()) {
                            _formKey.currentState.save();

                            await model.updateUserDetails();
                            Fimber.e(model.mUserDetails.name +
                                " " +
                                model.mUserDetails.contact.phone.mobile);
                            setState(() {
                              isButtonActive = false;
                              isEditable = false;
                            });
                          }
                        },
                        color: isButtonActive ? green : Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          // side: BorderSide(
                          //     color: Colors.black, width: 0.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: CustomText(
                            "Save ",
                            fontSize: subtitleFontSizeStyle - 2,
                            isBold: true,
                            color: Colors.white,
                          ),
                        ))),
                appBar: AppBar(
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
                ),
                body: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    child: model.busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Scrollbar(
                            child: SingleChildScrollView(
                            child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      verticalSpace(20),
                                      Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Profile",
                                            style: TextStyle(
                                                fontFamily: headingFont,
                                                fontWeight: FontWeight.w700,
                                                fontSize: headingFontSizeStyle),
                                          )),
                                      verticalSpace(20),
                                      SizedBox(
                                          child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          curve15)),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    CustomText(
                                                      "Name",
                                                      fontSize:
                                                          subtitleFontSizeStyle -
                                                              3,
                                                      color: Colors.grey,
                                                    ),
                                                    verticalSpaceTiny,
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child:
                                                                TextFormField(
                                                          focusNode:
                                                              nameFocusNode,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSizeStyle +
                                                                      2,
                                                              fontFamily:
                                                                  "Open-Sans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[800]),
                                                          readOnly: !isEditable,
                                                          initialValue: model
                                                              .mUserDetails
                                                              ?.name,
                                                          validator: (text) {
                                                            if (text.isEmpty ||
                                                                text
                                                                        .trim()
                                                                        .length ==
                                                                    0)
                                                              return "Add your Name";
                                                            return null;
                                                          },
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isButtonActive =
                                                                  true;
                                                            });
                                                            _formKey
                                                                .currentState
                                                                .validate();
                                                          },
                                                          onSaved: (text) {
                                                            model.mUserDetails
                                                                .name = text;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            10),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          autofocus: true,
                                                          maxLines: 1,
                                                        )),
                                                        IconButton(
                                                          icon:
                                                              Icon(Icons.edit),
                                                          onPressed: () {
                                                            setState(() {
                                                              isEditable = true;
                                                            });
                                                            nameFocusNode
                                                                .requestFocus();
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ))),
                                      verticalSpace(spaceBetweenCards),
                                      SizedBox(
                                          child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        CustomText(
                                                          "Mobile No",
                                                          fontSize:
                                                              subtitleFontSizeStyle -
                                                                  3,
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                    verticalSpaceSmall,
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                            child:
                                                                TextFormField(
                                                          // focusNode:
                                                          //     mobileFocusNode,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  titleFontSizeStyle +
                                                                      2,
                                                              fontFamily:
                                                                  "Open-Sans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[800]),
                                                          readOnly: true,
                                                          initialValue: model
                                                              .mUserDetails
                                                              ?.contact
                                                              ?.phone
                                                              ?.mobile,
                                                          // validator: (text) {
                                                          //   if (text.isEmpty ||
                                                          //       text
                                                          //               .trim()
                                                          //               .length ==
                                                          //           0 ||
                                                          //       text
                                                          //               .trim()
                                                          //               .length !=
                                                          //           10)
                                                          //     return "Please enter Proper Mobile No.";
                                                          //   return null;
                                                          // },
                                                          // onChanged: (value) {
                                                          //   setState(() {
                                                          //     isButtonActive =
                                                          //         true;
                                                          //   });
                                                          //   _formKey
                                                          //       .currentState
                                                          //       .validate();
                                                          // },
                                                          // onSaved: (text) {
                                                          //   model
                                                          //       .mUserDetails
                                                          //       .details
                                                          //       .phone
                                                          //       .mobile = text;
                                                          // },
                                                          decoration:
                                                              const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            10),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          enabled: false,
                                                          autofocus: true,
                                                          maxLines: 1,
                                                        )),
                                                        // IconButton(
                                                        //   icon:
                                                        //       Icon(Icons.edit),
                                                        //   onPressed: () {
                                                        //     setState(() {
                                                        //       isEditable = true;
                                                        //     });
                                                        //     mobileFocusNode
                                                        //         .requestFocus();
                                                        //   },
                                                        // )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ))),
                                      verticalSpace(spaceBetweenCards),
                                      Container(
                                          margin: EdgeInsets.only(
                                              bottom: spaceBetweenCards),
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            elevation: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      CustomText(
                                                        "Address",
                                                        color: Colors.grey,
                                                        fontSize:
                                                            subtitleFontSizeStyle -
                                                                3,
                                                      ),
                                                      verticalSpaceSmall,
                                                      CustomText(
                                                        model
                                                                .mUserDetails
                                                                .contact
                                                                .address +
                                                            "\n" +
                                                            (model
                                                                        .mUserDetails
                                                                        .contact
                                                                        .googleAddress
                                                                        ?.isEmpty ??
                                                                    true
                                                                ? ""
                                                                : model
                                                                    .mUserDetails
                                                                    .contact
                                                                    .googleAddress),
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize:
                                                            subtitleFontSizeStyle -
                                                                1,
                                                      )
                                                    ],
                                                  )),
                                                ],
                                              ),
                                            ),
                                          )),
                                      RaisedButton(
                                          elevation: 5,
                                          onPressed: () async {
                                            PickResult pickedPlace =
                                                await Navigator.push(
                                              context,
                                              PageTransition(
                                                child: AddressInputPage(),
                                                type: PageTransitionType
                                                    .rightToLeft,
                                              ),
                                            );
                                            if (pickedPlace != null) {
                                              // pickedPlace = (PickResult) pickedPlace;
                                              // print(pickedPlace);
                                              // model.mUserDetails.contact
                                              //     .address = pickedPlace;

                                              UserDetailsContact userAdd =
                                                  await showModalBottomSheet(
                                                      context: context,
                                                      builder: (_) =>
                                                          BottomSheetForAddress(
                                                            pickedPlace:
                                                                pickedPlace,
                                                          ));
                                              if (userAdd != null) {
                                                if (userAdd.city
                                                        .toUpperCase() !=
                                                    "AHMEDABAD") {
                                                  model
                                                      .showNotDeliveringDialog();
                                                } else {
                                                  model.mUserDetails.contact
                                                          .googleAddress =
                                                      userAdd.googleAddress;
                                                  model.mUserDetails.contact
                                                          .address =
                                                      userAdd.address;
                                                  model.mUserDetails.contact
                                                          .pincode =
                                                      userAdd.pincode;
                                                  model.mUserDetails.contact
                                                      .state = userAdd.state;
                                                  model.mUserDetails.contact
                                                      .city = userAdd.city;
                                                  setState(() {
                                                    isButtonActive = true;
                                                  });
                                                }
                                              }
                                            }
                                          },
                                          color: darkRedSmooth,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            // side: BorderSide(
                                            //     color: Colors.black, width: 0.5)
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                "assets/icons/address.svg",
                                                color: Colors.white,
                                                width: 25,
                                                height: 25,
                                              ),
                                              horizontalSpaceSmall,
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: CustomText(
                                                  model.mUserDetails.contact
                                                              .address !=
                                                          null
                                                      ? "Change Address"
                                                      : "Add Address",
                                                  isBold: true,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                )),
                          ))))));
  }
}
