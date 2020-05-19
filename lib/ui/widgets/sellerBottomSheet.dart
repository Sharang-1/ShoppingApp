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
    DateTime.now().add(Duration(days: 3)).day:
        DateFormat('EE').format(DateTime.now().add(Duration(days: 3)))
  };

  String selectedTime;
  String selectedWeekDay;

  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundWhiteCreamColor,
        child: Padding(
          padding: EdgeInsets.only(
              left: screenPadding, right: screenPadding, top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              verticalSpace(20),
              CustomText(
                "Ketan Works",
                isTitle: true,
                fontWeight: FontWeight.w700,
                fontSize: headingFontSizeStyle + 5,
              ),
              verticalSpaceMedium,
              Row(
                children: <Widget>[
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      border: Border.all(width: 0.6, color: Colors.grey),
                    ),
                    child: Wrap(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(width: 0.7, color: Colors.grey),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10))),
                            width: 50,
                            height: 50,
                            child: Column(
                              children: <Widget>[
                                Text(DateFormat('MMM').format(DateTime.now())),
                                Icon(Icons.calendar_today)
                              ],
                            )),
                        horizontalSpaceTiny_0,
                        Wrap(
                          direction: Axis.horizontal,
                          children: weekDayMap.keys
                              .map((index) => SizedBox(
                                  height: 50,
                                  child: ChoiceChip(
                                      backgroundColor:
                                          backgroundWhiteCreamColor,
                                      // selectedShadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          // borderRadius:
                                          //     BorderRadius.circular(15),
                                          side: BorderSide(
                                              color: selectedWeekDay ==
                                                      weekDayMap[index]
                                                  ? darkRedSmooth
                                                  : Colors.grey,
                                              width: 0.5,
                                              style: selectedWeekDay ==
                                                      weekDayMap[index]
                                                  ? BorderStyle.solid
                                                  : BorderStyle.none)),
                                      labelStyle: TextStyle(
                                          fontSize: subtitleFontSizeStyle - 4,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(index.toString()),
                                          Text(weekDayMap[index].toString()),
                                        ],
                                      ),
                                      selected:
                                          selectedWeekDay == weekDayMap[index],
                                      onSelected: (val) {
                                        setState(() {
                                          selectedWeekDay =
                                              val ? weekDayMap[index] : null;
                                          selectedIndex = index;
                                        });
                                      })))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText("Time",
                      isTitle: true,
                      fontWeight: FontWeight.w700,
                      fontSize: headingFontSizeStyle)),
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
                                        backgroundColor:
                                            backgroundWhiteCreamColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                              color: selectedTime ==
                                                      timeDetails[index]
                                                  ? darkRedSmooth
                                                  : Colors.grey,
                                              width: 0.5,
                                            )),
                                        labelStyle: TextStyle(
                                            fontSize: subtitleFontSizeStyle - 4,
                                            fontWeight: selectedTime ==
                                                    timeDetails[index]
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: selectedTime ==
                                                    timeDetails[index]
                                                ? darkRedSmooth
                                                : Colors.grey),
                                        selectedColor: Colors.white,
                                        label: Text(timeDetails[index]),
                                        selected:
                                            selectedTime == timeDetails[index],
                                        onSelected: (val) {
                                          setState(() {
                                            selectedTime =
                                                val ? timeDetails[index] : null;
                                            selectedIndex = index;
                                          });
                                          print(selectedTime +
                                              selectedIndex.toString());
                                        })))
                                .toList(),
                          )))
                ],
              ),
              verticalSpaceSmall,
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
                          color: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            // side: BorderSide(
                            //     color: Colors.black, width: 0.5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
        ));
  }
}
