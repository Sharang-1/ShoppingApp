// To parse this JSON data, do
//
//     final appointments = appointmentsFromJson(jsonString);

import 'dart:convert';

Appointments appointmentsFromJson(String str) =>
    Appointments.fromJson(json.decode(str));

String appointmentsToJson(Appointments data) => json.encode(data.toJson());

class Appointments {
  Appointments({
    this.offset,
    this.limit,
    this.records,
    this.appointments,
  });

  int offset;
  int limit;
  int records;
  List<AppointmentData> appointments;

  factory Appointments.fromJson(Map<String, dynamic> json) {
    List<AppointmentData> appointmentElements;
    int records = json["records"];

    appointmentElements = List<AppointmentData>.generate(records, (index) {
      return AppointmentData.fromJson(json["appointments"][index]);
    });

    return Appointments(
      offset: json["offset"],
      limit: json["limit"],
      records: json["records"],
      appointments: appointmentElements,
    );
  }

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "limit": limit,
        "records": records,
        "appointments": List<dynamic>.from(appointments.map((x) => x.toJson())),
      };
}

class AppointmentData {
  AppointmentData({
    this.id,
    this.userId,
    this.timeSlotStart,
    this.timeSlotEnd,
    this.status,
    this.customerMessage,
    this.sellerMessage,
    this.seller,
  });

  String id;
  String userId;
  DateTime timeSlotStart;
  DateTime timeSlotEnd;
  dynamic status;
  String customerMessage;
  String sellerMessage;
  SellerData seller;

  factory AppointmentData.fromJson(Map<String, dynamic> json) =>
      AppointmentData(
        id: json["id"],
        userId: json["userId"],
        timeSlotStart: DateTime.parse(json["timeSlotStart"]),
        timeSlotEnd: DateTime.parse(json["timeSlotEnd"]),
        status: json["status"],
        customerMessage:
            json["customerMessage"] == null ? null : json["customerMessage"],
        sellerMessage: json["sellerMessage"],
        seller: SellerData.fromJson(json["seller"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "timeSlotStart": timeSlotStart.toIso8601String(),
        "timeSlotEnd": timeSlotEnd.toIso8601String(),
        "status": status,
        "customerMessage": customerMessage == null ? null : customerMessage,
        "sellerMessage": sellerMessage,
        "seller": seller?.toJson(),
      };
}

class SellerData {
  SellerData({
    this.id,
    this.name,
    this.contact,
  });

  String id;
  String name;
  Contact contact;

  factory SellerData.fromJson(Map<String, dynamic> json) => SellerData(
        id: json["id"],
        name: json["name"],
        contact: Contact.fromJson(json["contact"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contact": contact.toJson(),
      };
}

class Contact {
  Contact({
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.email,
    this.primaryNumber,
    this.secondaryNumber,
    this.geoLocation,
  });

  String address;
  String city;
  String state;
  int pincode;
  String email;
  AryNumber primaryNumber;
  AryNumber secondaryNumber;
  GeoLocation geoLocation;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        address: json["address"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        email: json["email"],
        primaryNumber: AryNumber.fromJson(json["primaryNumber"]),
        secondaryNumber: AryNumber.fromJson(json["secondaryNumber"]),
        geoLocation: GeoLocation.fromJson(json["geoLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "state": state,
        "pincode": pincode,
        "email": email,
        "primaryNumber": primaryNumber.toJson(),
        "secondaryNumber": secondaryNumber.toJson(),
        "geoLocation": geoLocation.toJson(),
      };
}

class GeoLocation {
  GeoLocation({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class AryNumber {
  AryNumber({
    this.code,
    this.mobile,
  });

  String code;
  String mobile;

  factory AryNumber.fromJson(Map<String, dynamic> json) => (json == null)
      ? null
      : AryNumber(
          code: json["code"],
          mobile: json["mobile"],
        );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
      };
}
