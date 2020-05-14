import 'package:compound/ui/shared/shared_styles.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/views/home_view_list.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/ui/widgets/drawer.dart';
import 'package:compound/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/app_colors.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../widgets/cart_icon_badge.dart';
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
  final _formKey = GlobalKey<FormState>();
  FocusNode nameFocusNode;

  Map<int, String> addressMap = {0: "Address 1", 1: "Address 2"};
  Map<int, String> fullAddressMap = {
    0: "103 /, First Floor, Royal Bldg, Janjikar Street, Masjid Bunder (w), Mumbai, Maharashtra-400003",
    1: "Shivranjani Cross Roads, Satellite,Ahmedabad, Gujarat 380015",
    2: "Sarkhej - Gandhinagar Hwy, Bodakdev, Ahmedabad, Gujarat 380059"
  };
  void initState() {
    super.initState();
    initialString = "Dzor";
    isButtonActive = false;
    isEditable = false;

    nameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    nameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>.withConsumer(
        viewModel: HomeViewModel(),
        onModelReady: (model) => model.init(),
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundWhiteCreamColor,
            bottomNavigationBar: Padding(
                padding:
                    EdgeInsets.only(left: screenPadding, right: screenPadding, top: 10, bottom: 10),
                child: RaisedButton(
                    elevation: 5,
                    onPressed: () {
                      if (isButtonActive) if (_formKey.currentState
                          .validate()) {
                        _formKey.currentState.save();
                        print(nameString);
                      }
                    },
                    color: isButtonActive ?green : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      // side: BorderSide(
                      //     color: Colors.black, width: 0.5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: CustomText(
                        "Save ",
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
                child: Scrollbar(
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
                                      fontSize: 30),
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
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                          verticalSpaceTiny,
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: TextFormField(
                                                focusNode: nameFocusNode,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: "Open-Sans",
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[800]),
                                                readOnly: !isEditable,
                                                initialValue: initialString,
                                                validator: (text) {
                                                  if (text.isEmpty ||
                                                      text.trim().length == 0)
                                                    return "Please enter Proper Address";
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    isButtonActive = true;
                                                  });
                                                },
                                                onSaved: (text) {
                                                  setState(() {
                                                    nameString = text;
                                                  });
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
                                                  nameFocusNode.requestFocus();
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
                                                fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          verticalSpaceSmall,
                                          Row(
                                            children: <Widget>[
                                              CustomText(
                                                "9875243512",
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))),
                            verticalSpace(spaceBetweenCards),
                            Column(
                              children: addressMap.keys.map((int key) {
                                return Container(
                                    margin: EdgeInsets.only(bottom: spaceBetweenCards),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
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
                                                  addressMap[key],
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                                verticalSpaceSmall,
                                                CustomText(
                                                  fullAddressMap[key],
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                )
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ));
                              }).toList(),
                            ),
                            verticalSpaceMedium,
                            RaisedButton(
                                elevation: 5,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddressInputPage()));
                                },
                                color: darkRedSmooth,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  // side: BorderSide(
                                  //     color: Colors.black, width: 0.5)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    horizontalSpaceSmall,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: CustomText(
                                        "Add Address",
                                        isBold: true,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )),
                )))));
  }
}
