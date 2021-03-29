import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import '../constants/route_names.dart';
import '../locator.dart';
import '../models/Appointments.dart';
import '../models/TimeSlots.dart';
import '../services/address_service.dart';
import '../services/api/api_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import 'base_model.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
// import 'package:intl/intl.dart';

class AppointmentsViewModel extends BaseModel {
  final APIService _apiService = locator<APIService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AddressService _addressService = locator<AddressService>();

  Appointments _data;
  Appointments get data => _data;

  TimeSlots _timeSlotsData;
  TimeSlots get timeSlotsData => _timeSlotsData;

  String selectedWeekDay;
  int seltectedTime;

  Future getAppointments() async {
    setBusy(true);
    Appointments result = await _apiService.getUserAppointments();
    if (result != null) {
      Fimber.d("Appointments : " + result.appointments.toString());
      result.appointments.sort((a, b) =>
          -1 *
          a.appointment.timeSlotStart.compareTo(b.appointment.timeSlotStart));
      _data = result;
    }
    setBusy(false);
  }

  Future cancelAppointment(String id, String msg) async {
    var res = await _apiService.cancelAppointment(id, msg);
    if (res != null) {
      var errorMsg = json.decode(res).message;
      Fimber.e(errorMsg);
    }
  }

  Future getAvaliableTimeSlots(String sellerId, BuildContext context) async {
    setBusy(true);

    var adds = await _addressService.getAddresses();
    if (adds == null || adds.length == 0) {
      var res = await _dialogService.showConfirmationDialog(
          title: "Hey there!",
          description: "Please add your address before booking an application");
      if (res.confirmed) {
        await _navigationService.navigateTo(ProfileViewRoute);
        return;
      }

      // ,
      // snackPosition: SnackPosition.BOTTOM,
      // isDismissible: true,
      // snackStyle: SnackStyle.FLOATING,
      // margin: EdgeInsets.only(
      //   bottom: 20,
      //   left: 10,
      //   right: 10,
      // ),
      Navigator.of(context).pop();
    }

    TimeSlots result = await _apiService.getAvaliableTimeSlots(sellerId);
    if (result != null) {
      Fimber.d(result.toString());
      const weekDayMap = {
        "monday": "Mon",
        "tuesday": "Tue",
        "wednesday": "Wed",
        "thursday": "Thu",
        "friday": "Fri",
        "saturday": "Sat",
        "sunday": "Sun"
      };
      result.timeSlot.forEach((t) => t.day = weekDayMap[t.day]);
      selectedWeekDay = result.timeSlot.first.day;
      seltectedTime = result.timeSlot.first.time.first;
      _timeSlotsData = result;
      setBusy(false);
    } else {
      Navigator.of(context).pop();
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

  //method, which is called after appointment is booked
  Future appointmentBooked() async {
    Future.delayed(Duration(milliseconds: 2000), () async {
      _navigationService.navigateReplaceTo(MyAppointmentViewRoute);
    });
  }
}
