import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/server_urls.dart';
import '../../controllers/user_details_controller.dart';
import '../../locator.dart';
import '../../models/user_details.dart';
import '../../packages/google_maps_place_picker/google_maps_place_picker.dart';
import '../../services/dialog_service.dart';
import '../../services/navigation_service.dart';
import '../../utils/lang/translation_keys.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import 'address_input_form_view.dart';

class ProfileView extends StatefulWidget {
  final UserDetailsController controller;
  ProfileView({Key key, this.controller}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String nameString;
  String initialString;
  bool isButtonActive;
  bool isEditable;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    initialString = "Dzor";
    isButtonActive = false;
    isEditable = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailsController>(
      init: widget.controller ?? (UserDetailsController()..getUserDetails()),
      builder: (controller) => WillPopScope(
        onWillPop: () {
          if (this.isButtonActive == false) {
            Navigator.of(context).pop();
            return Future.value(true);
          }

          return DialogService.showCustomDialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  SETTINGS_PROFILE_ALERT.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              buttonPadding: EdgeInsets.all(12.0),
              actions: <Widget>[
                new TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: logoRed,
                  ),
                  child: CustomText(YES.tr, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                new TextButton(
                  child: CustomText(
                    NO.tr,
                    color: Colors.white,
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
          backgroundColor: newBackgroundColor,
          bottomNavigationBar: isButtonActive
              ? Padding(
                  padding: EdgeInsets.only(
                    left: screenPadding,
                    right: screenPadding,
                    top: 10,
                    bottom: MediaQuery.of(context).padding.bottom + 4.0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: isButtonActive ? lightGreen : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (isButtonActive) if (_formKey.currentState
                          .validate()) {
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
                        SAVE.tr,
                        fontSize: titleFontSizeStyle,
                        isBold: true,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : null,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              SETTINGS_PROFILE.tr,
              style: TextStyle(
                fontFamily: headingFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(
              color: appBarIconColor,
            ),
            backgroundColor: Colors.white,
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: false,
            child: controller.busy
                ? Center(
                    child: Image.asset(
                      "assets/images/loading_img.gif",
                      height: 50,
                      width: 50,
                    ),
                  )
                : Scrollbar(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              verticalSpace(spaceBetweenCards),
                              Stack(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    margin: EdgeInsets.only(right: 6.0),
                                    child: ClipOval(
                                      child: FadeInImage(
                                        width: 100,
                                        height: 100,
                                        fadeInCurve: Curves.easeIn,
                                        placeholder: AssetImage(
                                            "assets/images/user.png"),
                                        image: NetworkImage(
                                            "$USER_PROFILE_PHOTO_BASE_URL/${controller?.mUserDetails?.key}?v=${controller.dateTimeString}",
                                            headers: {
                                              "Authorization":
                                                  "Bearer ${controller?.token ?? ''}",
                                            }),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          print(
                                              "User Photo: $USER_PROFILE_PHOTO_BASE_URL/${controller?.mUserDetails?.photo?.name} $error $stackTrace");
                                          return Image.asset(
                                            "assets/images/user.png",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.1),
                                        width: 8.0,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: InkWell(
                                        onTap: controller.updateUserPhoto,
                                        child: Icon(
                                          Icons.edit,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpaceMedium,
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          SETTINGS_PERSONAL_DETAILS.tr,
                                          fontSize: 16,
                                        ),
                                        IconButton(
                                          icon: Column(
                                            children: [
                                              Icon(Icons.edit),
                                              CustomText(
                                                SETTINGS_EDIT.tr,
                                                textStyle: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 8,
                                                  letterSpacing: 0.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                          iconSize: 18,
                                          onPressed: () {
                                            if (!isEditable) {
                                              setState(() {
                                                isEditable = true;
                                              });
                                            } else {
                                              setState(() {
                                                isEditable = false;
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: CustomText(
                                            SETTINGS_NAME.tr,
                                            fontSize: titleFontSizeStyle,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: TextFormField(
                                            style: TextStyle(
                                              fontSize: subtitleFontSizeStyle,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[800],
                                            ),
                                            readOnly: !isEditable,
                                            initialValue:
                                                controller.mUserDetails?.name,
                                            validator: (text) {
                                              if (text.isEmpty ||
                                                  text.trim().length == 0)
                                                return SETTINGS_ADD_YOUR_NAME
                                                    .tr;
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                isButtonActive = true;
                                              });
                                              _formKey.currentState.validate();
                                            },
                                            onSaved: (text) {
                                              controller.mUserDetails.name =
                                                  text;
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 8.0),
                                              border: isEditable
                                                  ? OutlineInputBorder()
                                                  : InputBorder.none,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: CustomText(
                                            SETTINGS_MOBILE.tr,
                                            fontSize: titleFontSizeStyle,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: TextFormField(
                                            style: TextStyle(
                                              fontSize: subtitleFontSizeStyle,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[800],
                                            ),
                                            readOnly: true,
                                            initialValue: controller
                                                ?.mUserDetails
                                                ?.contact
                                                ?.phone
                                                ?.mobile
                                                ?.replaceRange(5, 10, 'XXXXX')
                                                .toString(),
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 8.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            enabled: false,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: CustomText(
                                            SETTINGS_AGE.tr,
                                            fontSize: titleFontSizeStyle,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: DropdownButton<String>(
                                                value:
                                                    "${controller?.mUserDetails?.age?.id ?? 0}",
                                                items: controller.ageLookup
                                                    .map(
                                                      (e) => DropdownMenuItem<
                                                          String>(
                                                        child: Text(e.name,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  subtitleFontSizeStyle,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[800],
                                                            )),
                                                        value: e.id.toString(),
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: isEditable
                                                    ? (value) {
                                                        setState(() {
                                                          controller
                                                                  .mUserDetails
                                                                  .age =
                                                              Age(
                                                                  id: int.parse(
                                                                      value));
                                                          isButtonActive = true;
                                                        });
                                                        _formKey.currentState
                                                            .validate();
                                                      }
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: CustomText(
                                            SETTINGS_GENDER.tr,
                                            fontSize: titleFontSizeStyle,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: DropdownButton<String>(
                                                value:
                                                    "${controller?.mUserDetails?.gender?.id ?? 0}",
                                                items: controller.genderLookup
                                                    .map(
                                                      (e) => DropdownMenuItem<
                                                          String>(
                                                        child: Text(
                                                          e.name,
                                                          style: TextStyle(
                                                            fontSize:
                                                                subtitleFontSizeStyle,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .grey[800],
                                                          ),
                                                        ),
                                                        value: e.id.toString(),
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: isEditable
                                                    ? (value) {
                                                        setState(() {
                                                          controller
                                                                  .mUserDetails
                                                                  .gender =
                                                              Gender(
                                                                  id: int.parse(
                                                                      value));
                                                          isButtonActive = true;
                                                        });
                                                        _formKey.currentState
                                                            .validate();
                                                      }
                                                    : null,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpaceSmall,
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: CustomText(
                                            SETTINGS_ADDRESS.tr,
                                            color: Colors.black,
                                            fontSize: titleFontSizeStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: InkWell(
                                            onTap: isEditable
                                                ? () async {
                                                    PickResult pickedPlace =
                                                        await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        child:
                                                            AddressInputPage(),
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                      ),
                                                    );
                                                    if (pickedPlace != null) {
                                                      UserDetailsContact
                                                          userAdd =
                                                          await showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (_) =>
                                                            BottomSheetForAddress(
                                                          pickedPlace:
                                                              pickedPlace,
                                                        ),
                                                      );
                                                      if (userAdd != null) {
                                                        controller
                                                                .mUserDetails
                                                                .contact
                                                                .googleAddress =
                                                            userAdd
                                                                .googleAddress;
                                                        controller
                                                                .mUserDetails
                                                                .contact
                                                                .address =
                                                            userAdd.address;
                                                        controller
                                                                .mUserDetails
                                                                .contact
                                                                .pincode =
                                                            userAdd.pincode;
                                                        controller.mUserDetails
                                                                .contact.state =
                                                            userAdd.state;
                                                        controller.mUserDetails
                                                                .contact.city =
                                                            userAdd.city;
                                                        setState(() {
                                                          isButtonActive = true;
                                                        });
                                                      }
                                                    }
                                                  }
                                                : null,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: isEditable
                                                        ? BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))
                                                        : BoxDecoration(),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            top: 10,
                                                            bottom: 10),
                                                    child: (controller
                                                                    ?.mUserDetails
                                                                    ?.contact
                                                                    ?.address
                                                                    ?.length ??
                                                                0) >
                                                            0
                                                        ? CustomText(
                                                            controller
                                                                .mUserDetails
                                                                .contact
                                                                .address,
                                                            color: Colors
                                                                .grey[800],
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                subtitleFontSizeStyle,
                                                          )
                                                        : CustomText(
                                                            SETTINGS_ADD_ADDRESS
                                                                .tr,
                                                            color: logoRed,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                subtitleFontSizeStyle,
                                                          ),
                                                  ),
                                                ),
                                                if (isEditable &&
                                                    ((controller
                                                                ?.mUserDetails
                                                                ?.contact
                                                                ?.address
                                                                ?.length ??
                                                            0) >
                                                        0))
                                                  horizontalSpaceTiny,
                                                if (isEditable &&
                                                    ((controller
                                                                ?.mUserDetails
                                                                ?.contact
                                                                ?.address
                                                                ?.length ??
                                                            0) >
                                                        0))
                                                  CustomText(
                                                    SETTINGS_CHANGE.tr,
                                                    color: logoRed,
                                                    fontSize: subtitleFontSize,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSpaceLarge,
                                    CustomText(
                                      MY_MEASUREMENTS.tr,
                                      fontSize: 16,
                                    ),
                                    SizedBox(
                                      height: Get.height / 2,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/measurements.png",
                                            height: Get.height / 2,
                                          ),
                                          horizontalSpaceMedium,
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              getSizeWidget(
                                                initialValue: (controller
                                                            ?.mUserDetails
                                                            ?.measure
                                                            ?.shoulders ??
                                                        '')
                                                    .toString(),
                                                hint: "*Shoulders",
                                                onSaved: (text) {
                                                  controller.mUserDetails
                                                          .measure.shoulders =
                                                      num.parse(text);
                                                },
                                              ),
                                              verticalSpaceSmall,
                                              getSizeWidget(
                                                  hint: "*Chest",
                                                  initialValue: (controller
                                                              ?.mUserDetails
                                                              ?.measure
                                                              ?.chest ??
                                                          '')
                                                      .toString(),
                                                  onSaved: (text) {
                                                    controller.mUserDetails
                                                            .measure.chest =
                                                        num.parse(text);
                                                  }),
                                              verticalSpaceSmall,
                                              getSizeWidget(
                                                  hint: "*Waist",
                                                  initialValue: (controller
                                                              ?.mUserDetails
                                                              ?.measure
                                                              ?.waist ??
                                                          '')
                                                      .toString(),
                                                  onSaved: (text) {
                                                    controller.mUserDetails
                                                            .measure.waist =
                                                        num.parse(text);
                                                  }),
                                              verticalSpaceSmall,
                                              getSizeWidget(
                                                  hint: "*Hips",
                                                  initialValue: (controller
                                                              ?.mUserDetails
                                                              ?.measure
                                                              ?.hips ??
                                                          '')
                                                      .toString(),
                                                  onSaved: (text) {
                                                    controller
                                                        .mUserDetails
                                                        .measure
                                                        .hips = num.parse(text);
                                                  }),
                                              verticalSpaceSmall,
                                              getSizeWidget(
                                                  hint: "*Height",
                                                  initialValue: (controller
                                                              ?.mUserDetails
                                                              ?.measure
                                                              ?.height ??
                                                          '')
                                                      .toString(),
                                                  onSaved: (text) {
                                                    controller.mUserDetails
                                                            .measure.height =
                                                        num.parse(text);
                                                  }),
                                              verticalSpaceSmall,
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  "*In inches",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  getSizeWidget(
      {String hint = '', String initialValue = '', Function(String) onSaved}) {
    return SizedBox(
      width: 120,
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              hint,
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                fontSize: subtitleFontSizeStyle,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              readOnly: !isEditable,
              initialValue: initialValue,
              validator: (text) => (GetUtils.isNum(text)) &&
                      (num.parse(text) > 0 && num.parse(text) < 100)
                  ? null
                  : ENTER_VALID_SIZE.tr,
              onChanged: (value) {
                setState(() {
                  isButtonActive = true;
                });
                _formKey.currentState.validate();
              },
              onSaved: onSaved,
              decoration: InputDecoration(
                hintText: ' ',
                hintStyle: TextStyle(
                  fontSize: subtitleFontSize - 4,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
