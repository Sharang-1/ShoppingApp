import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/appointments_controller.dart';
import '../../models/Appointments.dart';
import '../../services/dialog_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import '../widgets/grid_list_widget.dart';
import 'help_view.dart';
import 'seller_indi_view.dart';

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
  Widget build(BuildContext context) => GetBuilder<AppointmentsController>(
        init: AppointmentsController()..getAppointments(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            // centerTitle: true,
            title: Text(
              "My Appointments",
              style: TextStyle(
                fontFamily: headingFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          backgroundColor: newBackgroundColor,
          body: SafeArea(
            top: true,
            left: false,
            right: false,
            child: SmartRefresher(
              enablePullDown: true,
              footer: null,
              header: WaterDropHeader(
                waterDropColor: logoRed,
                refresh: Center(
                  child: CircularProgressIndicator(),
                ),
                complete: Container(),
              ),
              controller: refreshController,
              onRefresh: () async {
                await controller.refreshAppointments();
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
                          if (!controller.busy &&
                              (controller?.data?.appointments?.length ?? 0) !=
                                  0)
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () async => await showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(curve30))),
                                        clipBehavior: Clip.antiAlias,
                                        context: context,
                                        builder: (con) => HelpView(),
                                      ),
                                  child: Icon(Icons.help)),
                            ),
                        ],
                      ),
                      verticalSpace(20),
                      if (controller.busy) CircularProgressIndicator(),
                      if (!controller.busy &&
                          (controller?.data?.appointments?.length ?? 0) == 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: EmptyListWidget(),
                        ),
                      if (!controller.busy && controller.data != null)
                        ...controller.data.appointments.map(
                            (data) => productCard(context, data, controller)),
                    ]),
              )),
            ),
          ),
          // ),
          // )
        ),
      );

  _showDialog(
      context, AppointmentData data, AppointmentsController controller) {
    final msgTextController = TextEditingController();
    String _errorText = '';
    StateSetter _stateSetter;
    return DialogService.showCustomDialog(
      AlertDialog(
        title: Center(
          child: Text(
            'Cancel Appointment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: StatefulBuilder(builder: (context, stateSetter) {
          _stateSetter = stateSetter;
          return Row(
            children: <Widget>[
              Expanded(
                child: new TextField(
                  controller: msgTextController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Reason for Cancellation ?',
                    errorText: _errorText,
                  ),
                ),
              )
            ],
          );
        }),
        actions: <Widget>[
          TextButton(
              child: const Text('OK'),
              onPressed: () async {
                if (msgTextController.text.trim().length <= 10)
                  return _stateSetter(() {
                    _errorText = 'Enter atleast 10 character';
                  });
                await controller.cancelAppointment(
                    data.id, msgTextController.text);
                Navigator.of(context).pop();
                await controller.refreshAppointments();
                setState(() {
                  key = new UniqueKey();
                });
              }),
        ],
      ),
      useRootNavigator: false,
    );
  }

  Widget productCard(
      context, AppointmentData data, AppointmentsController controller) {
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
                child: Stack(
                  children: [
                    Column(
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
                              data.id,
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
                                          .format(data.timeSlotStart)
                                          .toString(),
                                      isBold: true,
                                      color: Colors.grey[600],
                                      fontSize: subHeadingSize,
                                    ),
                                    verticalSpaceTiny,
                                    CustomText(
                                      DateFormat("h:mma")
                                              .format(data.timeSlotStart)
                                              .toString() +
                                          " - " +
                                          DateFormat("h:mma")
                                              .format(data.timeSlotEnd)
                                              .toString(),
                                      isBold: true,
                                      color: Colors.grey[600],
                                      fontSize: subHeadingSize,
                                    ),
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: textIconOrange,
                                  borderRadius: BorderRadius.circular(curve30)),
                              child: CustomText(
                                (data.status is String)
                                    ? appointmentStatus[int.parse(data.status)]
                                    : appointmentStatus[data.status],
                                color: Colors.white,
                                fontSize: 12,
                                isBold: true,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    if ((data?.sellerMessage ?? '').isNotEmpty)
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Icon(Icons.notifications_active),
                          onTap: () async =>
                              await DialogService.showCustomDialog(AlertDialog(
                            title: Center(
                                child: Text(
                              "Message From Designer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            content: Text(data?.sellerMessage ?? ''),
                          )),
                        ),
                      ),
                  ],
                ))),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async => await MapUtils.openMap(
                      data?.seller?.contact?.geoLocation?.latitude ?? 0,
                      data?.seller?.contact?.geoLocation?.longitude ?? 0,
                    ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  primary: textIconOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
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
            ((data.status < 2 || data.status == "1" || data.status == "0")
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: backgroundWhiteCreamColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: logoRed, width: 2))),
                    onPressed: () {
                      _showDialog(context, data, controller);
                    },
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
