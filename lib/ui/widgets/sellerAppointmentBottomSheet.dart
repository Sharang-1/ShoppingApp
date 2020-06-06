import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../shared/app_colors.dart';
import '../views/home_view_slider.dart';

import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import '../shared/shared_styles.dart';

class SellerBottomSheetView extends StatefulWidget {
  @override
  _SellerBottomSheetViewState createState() => _SellerBottomSheetViewState();
}

class _SellerBottomSheetViewState extends State<SellerBottomSheetView> {
  Map<int, String> timeDetails = {
    0: "7:00",
    1: "8:00",
    2: "9:10",
    3: "13:10",
    4: "12:10",
    5: "15:10",
    6: "17:30",
    7: "18:10",
  };

  Map<int, String> weekDayMap = {
    DateTime.now().day: DateFormat('EE').format(DateTime.now()),
    DateTime.now().add(Duration(days: 1)).day:
        DateFormat('EE').format(DateTime.now().add(Duration(days: 1))),
    DateTime.now().add(Duration(days: 2)).day:
        DateFormat('EE').format(DateTime.now().add(Duration(days: 2))),
  };

  String selectedTime;
  String selectedWeekDay;

  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
      child: Container(
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
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
            ]),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    "Ketan Works",
                    isTitle: true,
                    fontWeight: FontWeight.w700,
                    fontSize: titleFontSizeStyle,
                  ),
                  CustomText(
                    "Naranpura",
                    isTitle: true,
                    color: Colors.grey,
                    fontSize: titleFontSizeStyle - 2,
                  ),
                  verticalSpaceSmall,
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  verticalSpaceMedium,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          // clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(curve15)),
                            border: Border.all(width: 0.25, color: Colors.grey),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      color: textIconOrange,
                                      shape: BoxShape.rectangle,
                                      // border: Border.all(

                                      //     width: 0.7, color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(curve15)),
                                  width: ((MediaQuery.of(context).size.width -
                                              60) /
                                          4) -
                                      1.2,
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CustomText(
                                        DateFormat('MMM')
                                            .format(DateTime.now()),
                                        color: Colors.white,
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
                                children: weekDayMap.keys
                                    .map((index) => SizedBox(
                                        height: 80,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    60 -
                                                    ((MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            60) /
                                                        4) -
                                                    10) /
                                                3,
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
                                            labelStyle: TextStyle(
                                                fontSize:
                                                    subtitleFontSizeStyle - 3,
                                                fontWeight: selectedWeekDay ==
                                                        weekDayMap[index]
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: selectedWeekDay ==
                                                        weekDayMap[index]
                                                    ? darkRedSmooth
                                                    : Colors.grey),
                                            selectedColor: Colors.white,
                                            label: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(weekDayMap[index]
                                                    .toString()),
                                                CircleAvatar(
                                                  child: CustomText(
                                                    index.toString(),
                                                    fontSize:
                                                        subtitleFontSizeStyle -
                                                            4,
                                                    color: selectedWeekDay ==
                                                            weekDayMap[index]
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                                  backgroundColor:
                                                      selectedWeekDay ==
                                                              weekDayMap[index]
                                                          ? textIconOrange
                                                          : Colors.white,
                                                ),
                                              ],
                                            ),
                                            selected: selectedWeekDay ==
                                                weekDayMap[index],
                                            onSelected: (val) {
                                              setState(() {
                                                selectedWeekDay = val
                                                    ? weekDayMap[index]
                                                    : null;
                                                selectedIndex = index;
                                              });
                                            })))
                                    .toList(),
                              )
                            ],
                          )),
                    ],
                  ),
                  verticalSpace(10),
                  CustomText("* appointment can only be booked within 3 days from today",fontSize: 12,color: Colors.grey[400],),
                  verticalSpace(30),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText("Time",
                          isTitle: true,
                          fontWeight: FontWeight.w700,
                          fontSize: titleFontSizeStyle)),
                  verticalSpaceTiny,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: timeDetails.keys
                                    .map((index) => Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: ChoiceChip(
                                            backgroundColor: selectedTime ==
                                                    timeDetails[index]
                                                ? textIconOrange
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: BorderSide(
                                                  color: selectedTime ==
                                                          timeDetails[index]
                                                      ? textIconOrange
                                                      : Colors.grey,
                                                  width: 0.5,
                                                )),
                                            labelStyle: TextStyle(
                                                fontSize:
                                                    subtitleFontSizeStyle - 4,
                                                fontWeight: selectedTime ==
                                                        timeDetails[index]
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: selectedTime ==
                                                        timeDetails[index]
                                                    ? Colors.white
                                                    : Colors.grey),
                                            selectedColor: textIconOrange,
                                            label: Text(timeDetails[index]),
                                            selected: selectedTime ==
                                                timeDetails[index],
                                            onSelected: (val) {
                                              setState(() {
                                                selectedTime = val
                                                    ? timeDetails[index]
                                                    : null;
                                                selectedIndex = index;
                                              });
                                              print(selectedTime +
                                                  selectedIndex.toString());
                                            })))
                                    .toList(),
                              )))
                    ],
                  ),
                  verticalSpaceLarge,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              elevation: 5,
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             SelectAddress()));
                              },
                              color: logoRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                // side: BorderSide(
                                //     color: Colors.black, width: 0.5)
                              ),
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
                  )
                ],
              ),
            ),
          ])),
    ));
  }
}
