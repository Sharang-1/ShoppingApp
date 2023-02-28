import 'package:compound/utils/lang/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controllers/appointments_controller.dart';
import '../../models/Appointments.dart';
import '../../services/dialog_service.dart';
import '../../services/navigation_service.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';
import '../widgets/custom_text.dart';
import '../widgets/grid_list_widget.dart';
import '../widgets/shimmer/shimmer_widget.dart';
import 'help_view.dart';
import 'seller_indi_view.dart';

class MyAppointments extends StatefulWidget {
  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  final refreshController = RefreshController(initialRefresh: false);
  UniqueKey key = UniqueKey();

  @override
  Widget build(BuildContext context) => GetBuilder<AppointmentsController>(
        init: AppointmentsController()..getAppointments(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              MY_APPOINTMENTS.tr,
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
            actions: [
              IconButton(
                  onPressed: () async => await showModalBottomSheet(
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(curve30))),
                        clipBehavior: Clip.antiAlias,
                        context: context,
                        builder: (con) => HelpView(),
                      ),
                  icon: Icon(Icons.help)),
            ],
          ),
          backgroundColor: newBackgroundColor2,
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
                  child: Center(
                    child: Image.asset(
                      "assets/images/loading_img.gif",
                      height: 25,
                      width: 25,
                    ),
                  ),
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
                padding: EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      verticalSpace(8),
                      if (controller.busy) ShimmerWidget(),
                      // Image.asset(
                      //   "assets/images/loading_img.gif",
                      //   height: 50,
                      //   width: 50,
                      // ),
                      if (!controller.busy &&
                          (controller.data.appointments.length) == 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: EmptyListWidget(),
                        ),
                      // ignore: unnecessary_null_comparison
                      if (!controller.busy && controller.data != null)
                        ...controller.data.appointments.map(
                            (data) => productCard(context, data!, controller)),
                    ]),
              )),
            ),
          ),
        ),
      );

  _showDialog(
      context, AppointmentData data, AppointmentsController controller) {
    final msgTextController = TextEditingController();
    String _errorText = '';
    late StateSetter _stateSetter;
    return DialogService.showCustomDialog(
      AlertDialog(
        title: Center(
          child: Text(
            CANCEL_APPOINTMENT.tr,
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
                    hintText: CANCELLATION_REASON.tr,
                    errorText: _errorText,
                  ),
                ),
              )
            ],
          );
        }),
        actions: <Widget>[
          TextButton(
              child: Text(OK.tr),
              onPressed: () async {
                if (msgTextController.text.trim().length <= 10)
                  return _stateSetter(() {
                    _errorText = 'Enter atleast 10 character';
                  });
                await controller.cancelAppointment(
                    data.id!, msgTextController.text);
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
              borderRadius: BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 5,
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(12),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        verticalSpaceTiny,
                        CustomText(
                          data.seller?.name ?? '',
                          dotsAfterOverFlow: true,
                          isTitle: true,
                          fontWeight: FontWeight.w600,
                          fontSize: headingFontSizeStyle,
                        ),
                        verticalSpaceTiny,
                        Row(
                          children: <Widget>[
                            CustomText(
                              "BOOKING ID",
                              isBold: true,
                              color: logoRed,
                              fontSize: headingFontSizeStyle - 2,
                            ),
                            horizontalSpaceSmall,
                            Expanded(
                                child: CustomText(
                              data.id ?? "",
                              dotsAfterOverFlow: true,
                              isBold: true,
                              color: logoRed,
                              fontSize: subtitleFontSize,
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
                                          .format(data.timeSlotStart!)
                                          .toString(),
                                      isBold: true,
                                      color: Colors.grey[600]!,
                                      fontSize: subtitleFontSize,
                                    ),
                                    verticalSpaceTiny,
                                    CustomText(
                                      DateFormat("h:mma")
                                              .format(data.timeSlotStart!)
                                              .toString() +
                                          " - " +
                                          DateFormat("h:mma")
                                              .format(data.timeSlotEnd!)
                                              .toString(),
                                      isBold: true,
                                      color: Colors.grey[600]!,
                                      fontSize: subtitleFontSize,
                                    ),
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  color: textIconOrange,
                                  borderRadius: BorderRadius.circular(5)),
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
                    if ((data.sellerMessage ?? '').isNotEmpty)
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Icon(Icons.message),
                          onTap: () async =>
                              await DialogService.showCustomDialog(AlertDialog(
                            title: Center(
                                child: Text(
                              "Message From Creator",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: headingFontSizeStyle,
                              ),
                            )),
                            content: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey[200]!,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(data.sellerMessage ?? ''),
                            ),
                            actions: [
                              TextButton(
                                child: Text(OK.tr),
                                onPressed: () => NavigationService.back(),
                              )
                            ],
                          )),
                        ),
                      ),
                  ],
                ))),
        verticalSpaceSmall,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                  onPressed: () async => await MapUtils.openMap(
                        data.seller?.contact?.geoLocation?.latitude ?? 0,
                        data.seller?.contact?.geoLocation?.longitude ?? 0,
                      ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: textIconOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.directions,
                            color: Colors.white,
                          ),
                          horizontalSpaceTiny,
                          Text(
                            DESIGNER_SCREEN_DIRECTION.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  )),
            ),
            ((data.status < 2 || data.status == "1" || data.status == "0")
                ? Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: backgroundWhiteCreamColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: logoRed, width: 2))),
                        onPressed: () {
                          _showDialog(context, data, controller);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: CustomText(
                            CANCEL.tr,
                            fontSize: 16,
                            isBold: true,
                            color: logoRed,
                          ),
                        )),
                  )
                : SizedBox.shrink())
          ],
        ),
        verticalSpaceMedium,
      ],
    );
  }
}
