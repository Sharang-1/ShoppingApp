import 'dart:convert';

import 'package:compound/constants/route_names.dart';
import 'package:compound/locator.dart';
import 'package:compound/models/Appointments.dart';
import 'package:compound/models/TimeSlots.dart';
import 'package:compound/models/post.dart';
import 'package:compound/models/products.dart';
import 'package:compound/services/api/api_service.dart';
import 'package:compound/services/dialog_service.dart';
import 'package:compound/services/navigation_service.dart';
import 'package:compound/viewmodels/base_model.dart';
import 'package:fimber/fimber.dart';
import 'package:intl/intl.dart';

class AppointmentsViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Appointments _data;
  Appointments get data => _data;

  TimeSlots _timeSlotsData;
  TimeSlots get timeSlotsData => _timeSlotsData;

  String selectedWeekDay;
  int seltectedTime;

  Future getAppointments() async {
    setBusy(true);
    Appointments result = await _apiService.getUserAppointments();
    setBusy(false);
    if (result != null) {
      Fimber.d(result.appointments.toString());
      result.appointments.sort((a, b) =>
          -1 *
          a.appointment.timeSlotStart.compareTo(b.appointment.timeSlotStart));
      _data = result;
    }
  }

  Future cancelAppointment(String id, String msg) async {
    var res = await _apiService.cancelAppointment(id, msg);
    if (res != null) {
      var errorMsg = json.decode(res).message;
    }
  }

  Future getAvaliableTimeSlots(String sellerId) async {
    setBusy(true);
    TimeSlots result = await _apiService.getAvaliableTimeSlots(sellerId);
    setBusy(false);
    if (result != null) {
      Fimber.d(result.toString());
      const weekDayMap = {
        "monday": "Mon",
        "tuesday": "Tue",
        "wednesday": "Wed",
        "thursday": "Thu",
        "friday": "Fri",
        "Saturday": "Sat",
        "Sunday": "Sun"
      };
      result.timeSlot.forEach((t) => t.day = weekDayMap[t.day]);
      selectedWeekDay = result.timeSlot.first.day;
      seltectedTime = result.timeSlot.first.time.first;
      _timeSlotsData = result;
    }
  }

  Future bookAppointment(String sellerId, String msg) async {
    const weekDayMap = {
      "Mon": 1,
      "Tue": 2,
      "Wed": 3,
      "Thu": 4,
      "Fri": 5,
      "Sat": 6,
      "Sun": 7,
    };
    DateTime now = new DateTime.now()
        .toUtc(); //.add(Duration(days: weekDayMap[selectedWeekDay]));

    var dayDiff = weekDayMap[selectedWeekDay] - now.weekday;
    if (dayDiff < 0) {
      dayDiff += 7;
    }

    DateTime timeSlotStart =
        new DateTime(now.year, now.month, now.day + dayDiff, seltectedTime);
    DateTime timeSlotEnd =
        new DateTime(now.year, now.month, now.day + dayDiff, seltectedTime + 1);

    var res = await _apiService.bookAppointment(sellerId,
        timeSlotStart.toIso8601String(), timeSlotEnd.toIso8601String(), msg);

    if (res == null) {
      _navigationService.navigateReplaceTo(AppointmentBookedScreenRoute);
    } else {
      await _dialogService.showDialog(
        title: 'Error',
        description: res,
      );
    }
  }
}
