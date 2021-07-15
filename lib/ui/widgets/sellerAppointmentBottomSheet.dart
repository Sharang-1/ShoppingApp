import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/server_urls.dart';
import '../../controllers/appointments_controller.dart';
import '../../models/sellers.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import 'custom_text.dart';

class SellerBottomSheetView extends StatefulWidget {
  final Seller sellerData;
  final context;
  const SellerBottomSheetView({Key key, this.sellerData, this.context})
      : super(key: key);

  @override
  _SellerBottomSheetViewState createState() => _SellerBottomSheetViewState();
}

class _SellerBottomSheetViewState extends State<SellerBottomSheetView> {
  AppointmentsController controller = AppointmentsController();
  String _taskMsg = "";
  Map<String, int> weekDayMap = {
    "Mon": 1,
    "Tue": 2,
    "Wed": 3,
    "Thu": 4,
    "Fri": 5,
    "Sat": 6,
    "Sun": 7,
  };

  String getTime(int time) {
    String meridien = "AM";
    if ((time ~/ 12).isOdd) {
      time = (time % 12);
      meridien = "PM";
    }
    time = (time == 0) ? 12 : time;
    return "${time.toString()} ${meridien.toString()}";
  }

  @override
  void initState() {
    controller.getAvaliableTimeSlots(widget.sellerData.key, widget.context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentsController>(
        init: controller,
        builder: (controller) {
          return Container(
            color: Colors.white,
            child: Stack(children: [
              controller.busy
                  ? Center(
                      child: Image.asset(
                        "assets/images/loading_img.gif",
                        height: 50,
                        width: 50,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: 60.0),
                      child: Scrollbar(
                        child: SingleChildScrollView(
                            child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Container(
                                                  height: 300,
                                                  width: 300,
                                                  child: ClipOval(
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      width: 80,
                                                      height: 80,
                                                      fadeInCurve:
                                                          Curves.easeIn,
                                                      placeholder:
                                                          "assets/images/product_preloading.png",
                                                      image: widget?.sellerData
                                                                  ?.key !=
                                                              null
                                                          ? "$SELLER_PHOTO_BASE_URL/${widget?.sellerData?.key}"
                                                          : "https://images.unsplash.com/photo-1567098260939-5d9cee055592?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                                      imageErrorBuilder:
                                                          (context, error,
                                                                  stackTrace) =>
                                                              Image.asset(
                                                        "assets/images/product_preloading.png",
                                                        width: 500,
                                                        height: 500,
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.1),
                                                      width: 8.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    widget.sellerData.name,
                                                    isTitle: true,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize:
                                                        titleFontSizeStyle + 5,
                                                  ),
                                                  verticalSpaceTiny,
                                                  CustomText(
                                                    widget.sellerData.contact
                                                        .address,
                                                    isTitle: true,
                                                    color: Colors.grey,
                                                    fontSize:
                                                        titleFontSizeStyle - 4,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      verticalSpaceSmall,
                                      Divider(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      verticalSpaceSmall,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(curve15)),
                                                border: Border.all(
                                                    width: 0.25,
                                                    color: Colors.grey),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: textIconOrange,
                                                          shape: BoxShape
                                                              .rectangle,
                                                          // border: Border.all(

                                                          //     width: 0.7, color: Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      curve15)),
                                                      width: ((MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  60) /
                                                              4) -
                                                          1.2,
                                                      height: 80,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          CustomText(
                                                            DateFormat('MMM')
                                                                .format(DateTime
                                                                    .now()),
                                                            textStyle:
                                                                TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          verticalSpaceTiny_0,
                                                          Icon(
                                                            Icons
                                                                .calendar_today,
                                                            color: Colors.white,
                                                          )
                                                        ],
                                                      )),
                                                  horizontalSpaceSmall,
                                                  Wrap(
                                                    direction: Axis.horizontal,
                                                    children: controller
                                                        .timeSlotsData.timeSlot
                                                        .map((timeSlot) => SizedBox(
                                                            height: 80,
                                                            width: (MediaQuery.of(context).size.width - 60 - ((MediaQuery.of(context).size.width - 60) / 4) - 10) / 3,
                                                            child: ChoiceChip(
                                                                backgroundColor: Colors.white,
                                                                // selectedShadowColor: Colors.white,
                                                                // shape: RoundedRectangleBorder(
                                                                //     borderRadius: BorderRadius.circular(
                                                                //         curve15),
                                                                //     side: BorderSide(
                                                                //         color: selectedWeekDay ==
                                                                //                 weekDayMap[index]
                                                                //             ? darkRedSmooth
                                                                //             : Colors.grey,
                                                                //         width: 0.5,
                                                                //         style: selectedWeekDay ==
                                                                //                 weekDayMap[index]
                                                                //             ? BorderStyle.solid
                                                                //             : BorderStyle.none)),
                                                                labelStyle: TextStyle(fontSize: subtitleFontSizeStyle - 3, fontWeight: controller.selectedWeekDay == timeSlot.day ? FontWeight.w600 : FontWeight.normal, color: controller.selectedWeekDay == timeSlot.day ? darkRedSmooth : Colors.grey),
                                                                selectedColor: Colors.white,
                                                                label: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    // Text(timeSlot.day
                                                                    //     .toString()),
                                                                    CircleAvatar(
                                                                      radius:
                                                                          25,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          CustomText(
                                                                            timeSlot.day,
                                                                            fontSize:
                                                                                subtitleFontSizeStyle - 4,
                                                                            color: controller.selectedWeekDay == timeSlot.day
                                                                                ? Colors.white
                                                                                : Colors.grey,
                                                                          ),
                                                                          // CustomText(
                                                                          //   "18",
                                                                          //   color: model.selectedWeekDay ==
                                                                          //               timeSlot
                                                                          //                   .day
                                                                          //           ? Colors
                                                                          //               .white
                                                                          //           : Colors
                                                                          //               .black,
                                                                          // )
                                                                        ],
                                                                      ),
                                                                      backgroundColor: controller.selectedWeekDay ==
                                                                              timeSlot.day
                                                                          ? textIconOrange
                                                                          : Colors.white,
                                                                    ),
                                                                  ],
                                                                ),
                                                                selected: controller.selectedWeekDay == timeSlot.day,
                                                                onSelected: (val) {
                                                                  setState(() {
                                                                    controller.selectedWeekDay = val
                                                                        ? timeSlot
                                                                            .day
                                                                        : null;
                                                                  });
                                                                })))
                                                        .toList(),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                      // verticalSpace(10),
                                      // CustomText(
                                      //   "* appointment can be booked within 3 days from today",
                                      //   fontSize: 12,
                                      //   color: Colors.grey[400],
                                      // ),
                                      verticalSpaceMedium,
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              "Time",
                                              isTitle: true,
                                              fontWeight: FontWeight.w700,
                                              fontSize: titleFontSizeStyle,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                "Choose an available time slot",
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      verticalSpaceTiny,
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                                  height: 50,
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: controller
                                                        .timeSlotsData.timeSlot
                                                        .firstWhere((t) =>
                                                            t.day ==
                                                            controller
                                                                .selectedWeekDay)
                                                        .time
                                                        .where((e) {
                                                          var dateTime =
                                                              DateTime.now();
                                                          if (weekDayMap[controller
                                                                  .selectedWeekDay] ==
                                                              dateTime
                                                                  .weekday) {
                                                            return e >
                                                                dateTime.hour;
                                                          }
                                                          return true;
                                                        })
                                                        .toList()
                                                        .map((time) => Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            child: ChoiceChip(
                                                                backgroundColor:
                                                                    controller.seltectedTime == time
                                                                        ? textIconOrange
                                                                        : Colors
                                                                            .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(
                                                                            15),
                                                                        side:
                                                                            BorderSide(
                                                                          color: controller.seltectedTime == time
                                                                              ? textIconOrange
                                                                              : Colors.grey,
                                                                          width:
                                                                              0.5,
                                                                        )),
                                                                labelStyle: TextStyle(
                                                                    fontSize:
                                                                        subtitleFontSizeStyle - 4,
                                                                    fontWeight: controller.seltectedTime == time ? FontWeight.w600 : FontWeight.normal,
                                                                    color: controller.seltectedTime == time ? Colors.white : Colors.grey),
                                                                selectedColor: textIconOrange,
                                                                label: Text(
                                                                  getTime(time) +
                                                                      " - " +
                                                                      getTime(
                                                                          time +
                                                                              1),
                                                                ),
                                                                selected: controller.seltectedTime == time,
                                                                onSelected: (val) {
                                                                  setState(() {
                                                                    controller
                                                                            .seltectedTime =
                                                                        val
                                                                            ? time
                                                                            : null;
                                                                    // selectedIndex = index;
                                                                  });
                                                                })))
                                                        .toList(),
                                                  )))
                                        ],
                                      ),
                                      verticalSpaceMedium,
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomText(
                                          "Task",
                                          isTitle: true,
                                          fontWeight: FontWeight.w700,
                                          fontSize: titleFontSizeStyle,
                                        ),
                                      ),
                                      verticalSpaceTiny,

                                      DropdownButton(
                                        hint: Text("Select Your Message"),
                                        value: _taskMsg == "" ? null : _taskMsg,
                                        items: (<String>[
                                          "Customised stitching",
                                          "Design new Apparel",
                                          "Browse & Shop",
                                          "Alterations",
                                          "Other"
                                        ].map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e)))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _taskMsg = value.toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: "Close",
                  iconSize: 22,
                  icon: Icon(CupertinoIcons.clear_circled_solid),
                  color: Colors.grey[600],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                primary: logoRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  // side: BorderSide(
                                  //     color: Colors.black, width: 0.5)
                                ),
                              ),
                              onPressed: _taskMsg == ""
                                  ? null
                                  : () {
                                      controller.bookAppointment(
                                          widget.sellerData.key, _taskMsg);
                                    },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  "Book Appointment ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )))
                    ],
                  ),
                ),
              )
            ]),
          );
        });
  }
}
