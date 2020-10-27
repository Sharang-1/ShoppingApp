import 'package:compound/models/Appointments.dart';
import 'package:compound/ui/shared/app_colors.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/models/grid_view_builder_filter_models/cartFilter.dart';
import 'package:compound/ui/widgets/custom_text.dart';
import 'package:compound/viewmodels/appointments_view_model.dart';
import 'package:compound/viewmodels/cart_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import '../shared/shared_styles.dart';

class myAppointments extends StatelessWidget {
  double headingFontSize = headingFontSizeStyle + 5;

  double headingSize = 20;

  double subHeadingSize = 18;

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
                child: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: screenPadding,
                      right: screenPadding,
                      top: 10,
                      bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        verticalSpace(20),
                        Text(
                          "My Appointments",
                          style: TextStyle(
                              fontFamily: headingFont,
                              fontWeight: FontWeight.w700,
                              fontSize: headingFontSize),
                        ),
                        verticalSpace(20),
                        if (model.busy) CircularProgressIndicator(),
                        if (!model.busy)
                          ...model.data.appointments
                              .map((data) => productCard(context, data, model)),
                      ]),
                )),
              ),
              // ),
              // )
            ));
  }

  _showDialog(context, AppointmentElement data, AppointmentsViewModel model) {
    final msgTextController = TextEditingController();
    return showDialog<String>(
      context: context,
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
                Navigator.pop(context);
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
                            appointmentStatus[data.appointment.status],
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            (data.appointment.status != 2
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
