import 'package:compound/viewmodels/appointments_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/app_colors.dart';

import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import '../shared/shared_styles.dart';

class SellerBottomSheetView extends StatefulWidget {
  final sellerData;
  const SellerBottomSheetView({Key key, this.sellerData}) : super(key: key);

  @override
  _SellerBottomSheetViewState createState() => _SellerBottomSheetViewState();
}

class _SellerBottomSheetViewState extends State<SellerBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    final msgController = TextEditingController();

    String getTime(int time) {
      String meridien = "AM";
      if ((time ~/ 12).isOdd) {
        time = (time % 12);
        meridien = "PM";
      }
      time = (time == 0) ? 12 : time;
      return "${time.toString()} ${meridien.toString()}";
    }

    return ViewModelProvider<AppointmentsViewModel>.withConsumer(
        viewModel: AppointmentsViewModel(),
        onModelReady: (model) =>
            model.getAvaliableTimeSlots(widget.sellerData.key),
        builder: (context, model, child) {
          return Stack(children: [
            Align(
              // mainAxisAlignment: MainAxisAlignment.end,
              // children: <Widget>[
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: IconButton(
                  tooltip: "Close",
                  iconSize: 30,
                  icon: Icon(CupertinoIcons.clear_circled_solid),
                  color: Colors.grey[600],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            model.busy
                ? Center(child: CircularProgressIndicator())
                : Scrollbar(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CustomText(
                                      widget.sellerData.name,
                                      isTitle: true,
                                      fontWeight: FontWeight.w700,
                                      fontSize: titleFontSizeStyle + 5,
                                    ),
                                    verticalSpaceSmall,
                                    CustomText(
                                      widget.sellerData.bio,
                                      isTitle: true,
                                      color: Colors.grey,
                                      fontSize: titleFontSizeStyle - 2,
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
                                            // clipBehavior: Clip.antiAlias,
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
                                                        shape:
                                                            BoxShape.rectangle,
                                                        // border: Border.all(

                                                        //     width: 0.7, color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    curve15)),
                                                    width:
                                                        ((MediaQuery.of(context)
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
                                                          textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        verticalSpaceTiny_0,
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    )),
                                                horizontalSpaceSmall,
                                                Wrap(
                                                  direction: Axis.horizontal,
                                                  children: model
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
                                                              labelStyle: TextStyle(fontSize: subtitleFontSizeStyle - 3, fontWeight: model.selectedWeekDay == timeSlot.day ? FontWeight.w600 : FontWeight.normal, color: model.selectedWeekDay == timeSlot.day ? darkRedSmooth : Colors.grey),
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
                                                                    radius: 25,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        CustomText(
                                                                          timeSlot
                                                                              .day,
                                                                          fontSize:
                                                                              subtitleFontSizeStyle - 4,
                                                                          color: model.selectedWeekDay == timeSlot.day
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
                                                                    backgroundColor: model.selectedWeekDay ==
                                                                            timeSlot
                                                                                .day
                                                                        ? textIconOrange
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                ],
                                                              ),
                                                              selected: model.selectedWeekDay == timeSlot.day,
                                                              onSelected: (val) {
                                                                setState(() {
                                                                  model.selectedWeekDay = val
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
                                      child: CustomText(
                                        "Time",
                                        isTitle: true,
                                        fontWeight: FontWeight.w700,
                                        fontSize: titleFontSizeStyle,
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
                                                  children: model
                                                      .timeSlotsData.timeSlot
                                                      .firstWhere((t) =>
                                                          t.day ==
                                                          model.selectedWeekDay)
                                                      .time
                                                      .map((time) => Padding(
                                                          padding: EdgeInsets.only(
                                                              right: 5),
                                                          child: ChoiceChip(
                                                              backgroundColor:
                                                                  model.seltectedTime == time
                                                                      ? textIconOrange
                                                                      : Colors
                                                                          .white,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      side:
                                                                          BorderSide(
                                                                        color: model.seltectedTime ==
                                                                                time
                                                                            ? textIconOrange
                                                                            : Colors.grey,
                                                                        width:
                                                                            0.5,
                                                                      )),
                                                              labelStyle: TextStyle(
                                                                  fontSize: subtitleFontSizeStyle - 4,
                                                                  fontWeight: model.seltectedTime == time ? FontWeight.w600 : FontWeight.normal,
                                                                  color: model.seltectedTime == time ? Colors.white : Colors.grey),
                                                              selectedColor: textIconOrange,
                                                              label: Text(
                                                                getTime(time) +
                                                                    " - " +
                                                                    getTime(
                                                                        time +
                                                                            1),
                                                              ),
                                                              selected: model.seltectedTime == time,
                                                              onSelected: (val) {
                                                                setState(() {
                                                                  model.seltectedTime =
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

                                    // DropdownButton(
                                    //   items: (<String>[
                                    //     "Test 1",
                                    //     "Test 1",
                                    //     "Test 1",
                                    //     "Test 1",
                                    //     "Test 1"
                                    //   ].map((e) => DropdownMenuItem<String>(
                                    //       value: e, child: Text(e)))).toList(),
                                    //   onChanged: (value) {},
                                    // ),

                                    // InputField(
                                    //   smallVersion: true,
                                    //   placeholder:
                                    //       'Specific message for ' + widget.sellerData.name,
                                    //   controller: msgController,
                                    //   textInputType: TextInputType.text,
                                    // ),
                                    verticalSpaceMedium,
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    )),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                            elevation: 5,
                            onPressed: () {
                              model.bookAppointment(
                                  widget.sellerData.key, msgController.text);
                            },
                            color: logoRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              // side: BorderSide(
                              //     color: Colors.black, width: 0.5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
          ]);
        });
  }
}
