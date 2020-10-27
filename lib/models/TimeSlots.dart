// To parse this JSON data, do
//
//     final timeSlots = timeSlotsFromJson(jsonString);

import 'dart:convert';

TimeSlots timeSlotsFromJson(String str) => TimeSlots.fromJson(json.decode(str));

String timeSlotsToJson(TimeSlots data) => json.encode(data.toJson());

class TimeSlots {
  TimeSlots({
    this.timeSlot,
  });

  List<TimeSlot> timeSlot;

  factory TimeSlots.fromJson(Map<String, dynamic> json) => TimeSlots(
        timeSlot: List<TimeSlot>.from(
            json["timeSlot"].map((x) => TimeSlot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timeSlot": List<dynamic>.from(timeSlot.map((x) => x.toJson())),
      };
}

class TimeSlot {
  TimeSlot({
    this.day,
    this.time,
  });

  String day;
  List<int> time;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        day: json["day"],
        time: List<int>.from(json["Time"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "Time": List<dynamic>.from(time.map((x) => x)),
      };
}
