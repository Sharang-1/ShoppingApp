import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/Appointments.dart';
import '../../viewmodels/appointments_view_model.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/GridListWidget.dart';
import '../widgets/custom_text.dart';
import 'help_view.dart';

// ignore: camel_case_types
class myAppointments extends StatefulWidget {
  @override
  _myAppointmentsState createState() => _myAppointmentsState();
}

// ignore: camel_case_types
class _myAppointmentsState extends State<myAppointments> {
  final double headingFontSize = headingFontSizeStyle + 5;
  final double headingSize = 20;
  final double subHeadingSize = 18;
  final refreshController = RefreshController(initialRefresh: false);
  UniqueKey key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AppointmentsViewModel>.withConsumer(
        viewModel: AppointmentsViewModel(),
        onModelReady: (model) => model.getAppointments(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backgroundWhiteCreamColor,
                centerTitle: true,
                title: SvgPicture.asset(
                  "assets/svg/logo.svg",
                  color: logoRed,
                  height: 35,
                  width: 35,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
              backgroundColor: backgroundWhiteCreamColor,
              body: SafeArea(
                top: true,
                left: false,
                right: false,
                child: SmartRefresher(
                  enablePullDown: true,
                  footer: null,
                  header: WaterDropHeader(
                    waterDropColor: logoRed,
                    refresh: Container(),
                    complete: Container(),
                  ),
                  controller: refreshController,
                  onRefresh: () async {
                    setState(() {
                      key = new UniqueKey();
                    });

                    await Future.delayed(Duration(milliseconds: 100));

                    refreshController.refreshCompleted(resetFooterState: true);
                  },
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: screenPadding,
                        right: screenPadding,
                        top: 10,
                        bottom: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          verticalSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "My Appointments",
                                  style: TextStyle(
                                      fontFamily: headingFont,
                                      fontWeight: FontWeight.w700,
                                      fontSize: headingFontSize),
                                ),
                              ),
                              if(!model.busy && (model?.data?.appointments?.length ?? 0) != 0)
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                    onTap: () async =>
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          curve30))),
                                          clipBehavior: Clip.antiAlias,
                                          context: context,
                                          builder: (con) => HelpView(),
                                        ),
                                    child: Icon(Icons.help)),
                              ),
                            ],
                          ),
                          verticalSpace(20),
                          if (model.busy) CircularProgressIndicator(),
                          if (!model.busy &&
                              (model?.data?.appointments?.length ?? 0) == 0)
                            Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: EmptyListWidget(),
                            ),
                          if (!model.busy && model.data != null)
                            ...model.data.appointments.map(
                                (data) => productCard(context, data, model)),
                        ]),
                  )),
                ),
              ),
              // ),
              // )
            ));
  }

  _showDialog(context, AppointmentElement data, AppointmentsViewModel model) {
    final msgTextController = TextEditingController();
    return showDialog<String>(
      context: context,
      useRootNavigator: false,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: msgTextController,
                autofocus: true,
                decoration:
                    new InputDecoration(hintText: 'Reason for Cancellation ?'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                model.cancelAppointment(
                    data.appointment.id, msgTextController.text);
                Navigator.of(context).pop();
                model.getAppointments();
              }),
        ],
      ),
    );
  }

  Widget productCard(
      context, AppointmentElement data, AppointmentsViewModel model) {
    const appointmentStatus = [
      "Pending",
      "Confirmed",
      "Cancelled",
      "Completed",
      "Missed"
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(curve15),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 5,
            child: Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    verticalSpaceTiny,
                    CustomText(
                      data.seller.name,
                      dotsAfterOverFlow: true,
                      isTitle: true,
                      isBold: true,
                      fontSize: headingSize,
                    ),
                    verticalSpaceTiny,
                    Row(
                      children: <Widget>[
                        CustomText(
                          "BOOKING ID",
                          isBold: true,
                          color: logoRed,
                          fontSize: subHeadingSize - 2,
                        ),
                        horizontalSpaceSmall,
                        Expanded(
                            child: CustomText(
                          data.appointment.id,
                          dotsAfterOverFlow: true,
                          isBold: true,
                          color: logoRed,
                          fontSize: subHeadingSize - 2,
                        ))
                      ],
                    ),
                    verticalSpaceMedium,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomText(
                                  new DateFormat.yMMMEd()
                                      .format(data.appointment.timeSlotStart)
                                      .toString(),
                                  isBold: true,
                                  color: Colors.grey[600],
                                  fontSize: subHeadingSize,
                                ),
                                verticalSpaceTiny,
                                CustomText(
                                  DateFormat("h:mma")
                                          .format(
                                              data.appointment.timeSlotStart)
                                          .toString() +
                                      " - " +
                                      DateFormat("h:mma")
                                          .format(data.appointment.timeSlotEnd)
                                          .toString(),
                                  isBold: true,
                                  color: Colors.grey[600],
                                  fontSize: subHeadingSize,
                                ),
                              ]),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: textIconOrange,
                              borderRadius: BorderRadius.circular(curve30)),
                          child: CustomText(
                            (data.appointment.status is String)
                                ? appointmentStatus[
                                    int.parse(data.appointment.status)]
                                : appointmentStatus[data.appointment.status],
                            color: Colors.white,
                            fontSize: 12,
                            isBold: true,
                          ),
                        )
                      ],
                    )
                  ],
                ))),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
                elevation: 5,
                onPressed: () {},
                color: textIconOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  // side: BorderSide(
                  //     color: Colors.black, width: 0.5)
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(children: <Widget>[
                    Icon(
                      Icons.directions,
                      color: Colors.white,
                    ),
                    horizontalSpaceTiny,
                    Text(
                      "Directions",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ]),
                )),
            ((data.appointment.status < 2 ||
                    data.appointment.status == "1" ||
                    data.appointment.status == "0")
                ? RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      _showDialog(context, data, model);
                    },
                    color: backgroundWhiteCreamColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: logoRed, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CustomText(
                        "Cancel",
                        fontSize: 16,
                        isBold: true,
                        color: logoRed,
                      ),
                    ))
                : SizedBox.shrink())
          ],
        ),
        verticalSpaceMedium,
      ],
    );
  }
}
