import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../controllers/user_details_controller.dart';
import '../../google_maps_place_picker/google_maps_place_picker.dart';
import '../../locator.dart';
import '../../models/user_details.dart';
import '../../services/dialog_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import 'address_input_form_view.dart';

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
  bool isEmailEditable;
  bool isAgeEditable;
  final _formKey = GlobalKey<FormState>();
  FocusNode nameFocusNode;
  FocusNode emailFocusNode;
  FocusNode ageFocusNode;
  // FocusNode mobileFocusNode;

  void initState() {
    super.initState();
    initialString = "Dzor";
    isButtonActive = false;
    isEditable = false;
    isEmailEditable = false;
    isAgeEditable = false;

    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    ageFocusNode = FocusNode();
    // mobileFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    // mobileFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailsController>(
      init: UserDetailsController()..getUserDetails(),
      builder: (controller) => WillPopScope(
        onWillPop: () {
          if (this.isButtonActive == false) {
            Navigator.of(context).pop();
            return Future.value(true);
          }

          return DialogService.showCustomDialog(
            AlertDialog(
              // title: new Text("Are you sure?"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  "Are you sure you don't want to make a change?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              buttonPadding: EdgeInsets.all(12.0),
              actions: <Widget>[
                new TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: logoRed,
                  ),
                  child: CustomText("Yes", color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                new TextButton(
                  child: CustomText(
                    "No",
                    color: Colors.white,
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.grey[400],
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ],
            ),
            // ignore: missing_return
          ).then((result) {
            if (result == null) return;
            if (result) {
              locator<NavigationService>().pop();
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
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: isButtonActive ? green : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      // side: BorderSide(
                      //     color: Colors.black, width: 0.5)
                    ),
                  ),
                  onPressed: () async {
                    if (isButtonActive) if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      await controller.updateUserDetails();
                      Fimber.e(controller.mUserDetails.name +
                          " " +
                          controller.mUserDetails.contact.phone.mobile);
                      setState(() {
                        isButtonActive = false;
                        isEditable = false;
                      });
                    }
                  },
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
          // resizeToAvoidBottomInset: false,
          body: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: false,
            child: controller.busy
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                                BorderRadius.circular(curve15)),
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              CustomText(
                                                "Name",
                                                fontSize:
                                                    subtitleFontSizeStyle - 3,
                                                color: Colors.grey,
                                              ),
                                              verticalSpaceTiny,
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: TextFormField(
                                                    focusNode: nameFocusNode,
                                                    style: TextStyle(
                                                        fontSize:
                                                            titleFontSizeStyle +
                                                                2,
                                                        fontFamily: "Open-Sans",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors.grey[800]),
                                                    readOnly: !isEditable,
                                                    initialValue: controller
                                                        .mUserDetails?.name,
                                                    validator: (text) {
                                                      if (text.isEmpty ||
                                                          text.trim().length ==
                                                              0)
                                                        return "Add your Name";
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isButtonActive = true;
                                                      });
                                                      _formKey.currentState
                                                          .validate();
                                                    },
                                                    onSaved: (text) {
                                                      controller.mUserDetails
                                                          .name = text;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      border: InputBorder.none,
                                                    ),
                                                    autofocus: true,
                                                    maxLines: 1,
                                                  )),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
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
                                            BorderRadius.circular(15)),
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
                                                    subtitleFontSizeStyle - 3,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          verticalSpaceSmall,
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: TextFormField(
                                                // focusNode:
                                                //     mobileFocusNode,
                                                style: TextStyle(
                                                    fontSize:
                                                        titleFontSizeStyle + 2,
                                                    fontFamily: "Open-Sans",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[800]),
                                                readOnly: true,
                                                initialValue: controller
                                                    ?.mUserDetails
                                                    ?.contact
                                                    ?.phone
                                                    ?.mobile?.replaceRange(5, 10, 'XXXXX').toString(),
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
                                                //   controller
                                                //       .mUserDetails
                                                //       .details
                                                //       .phone
                                                //       .mobile = text;
                                                // },
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10),
                                                  border: InputBorder.none,
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
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CustomText(
                                                "Email Address",
                                                fontSize:
                                                    subtitleFontSizeStyle - 3,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          verticalSpaceSmall,
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TextFormField(
                                                  focusNode: emailFocusNode,
                                                  style: TextStyle(
                                                    fontSize:
                                                        titleFontSizeStyle + 2,
                                                    fontFamily: "Open-Sans",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[800],
                                                  ),
                                                  readOnly: !isEmailEditable,
                                                  initialValue: controller
                                                          .mUserDetails
                                                          ?.email ??
                                                      '',
                                                  validator: (text) => GetUtils
                                                          .isEmail(text)
                                                      ? null
                                                      : "Please Enter Valid Email Address",
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isButtonActive = true;
                                                    });
                                                    _formKey.currentState
                                                        .validate();
                                                  },
                                                  onSaved: (text) {
                                                    controller.mUserDetails
                                                        .email = text;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    border: InputBorder.none,
                                                  ),
                                                  autofocus: true,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  setState(() {
                                                    isEmailEditable = true;
                                                  });
                                                  emailFocusNode.requestFocus();
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              CustomText(
                                                "Age",
                                                fontSize:
                                                    subtitleFontSizeStyle - 3,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          verticalSpaceSmall,
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TextFormField(
                                                  focusNode: ageFocusNode,
                                                  style: TextStyle(
                                                    fontSize:
                                                        titleFontSizeStyle + 2,
                                                    fontFamily: "Open-Sans",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[800],
                                                  ),
                                                  readOnly: !isAgeEditable,
                                                  initialValue: controller
                                                          .mUserDetails?.age ??
                                                      '',
                                                  validator: (text) => (GetUtils
                                                              .isNum(text)) &&
                                                          (text.length < 3)
                                                      ? null
                                                      : "Please Enter Valid Age",
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isButtonActive = true;
                                                    });
                                                    _formKey.currentState
                                                        .validate();
                                                  },
                                                  onSaved: (text) {
                                                    controller.mUserDetails
                                                        .age = text;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    border: InputBorder.none,
                                                  ),
                                                  autofocus: true,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  setState(() {
                                                    isAgeEditable = true;
                                                  });
                                                  ageFocusNode.requestFocus();
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                verticalSpace(spaceBetweenCards),
                                if (controller.mUserDetails.contact.address !=
                                    "")
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
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                    controller.mUserDetails
                                                            .contact.address +
                                                        "\n" +
                                                        controller
                                                            .mUserDetails
                                                            .contact
                                                            .googleAddress,
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.w500,
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
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      primary: darkRedSmooth,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        // side: BorderSide(
                                        //     color: Colors.black, width: 0.5)
                                      ),
                                    ),
                                    onPressed: () async {
                                      PickResult pickedPlace =
                                          await Navigator.push(
                                        context,
                                        PageTransition(
                                          child: AddressInputPage(),
                                          type: PageTransitionType.rightToLeft,
                                        ),
                                      );
                                      if (pickedPlace != null) {
                                        // pickedPlace = (PickResult) pickedPlace;
                                        // print(pickedPlace);
                                        // controller.mUserDetails.contact
                                        //     .address = pickedPlace;

                                        UserDetailsContact userAdd =
                                            await showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (_) => BottomSheetForAddress(
                                            pickedPlace: pickedPlace,
                                          ),
                                        );
                                        if (userAdd != null) {
                                          if (userAdd.city.toUpperCase() !=
                                              "AHMEDABAD") {
                                            controller
                                                .showNotDeliveringDialog();
                                          } else {
                                            controller.mUserDetails.contact
                                                    .googleAddress =
                                                userAdd.googleAddress;
                                            controller.mUserDetails.contact
                                                .address = userAdd.address;
                                            controller.mUserDetails.contact
                                                .pincode = userAdd.pincode;
                                            controller.mUserDetails.contact
                                                .state = userAdd.state;
                                            controller.mUserDetails.contact
                                                .city = userAdd.city;
                                            setState(() {
                                              isButtonActive = true;
                                            });
                                          }
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/svg/address.svg",
                                          color: Colors.white,
                                          width: 25,
                                          height: 25,
                                        ),
                                        horizontalSpaceSmall,
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: CustomText(
                                            controller.mUserDetails.contact
                                                        .address !=
                                                    ""
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
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
