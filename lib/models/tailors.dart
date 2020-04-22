// To parse this JSON data, do
//
//     final tailors = tailorsFromJson(jsonString);

import 'dart:convert';

import 'package:compound/models/sellers.dart';

Tailors tailorsFromJson(String str) => Tailors.fromJson(json.decode(str));

String tailorsToJson(Tailors data) => json.encode(data.toJson());

class Tailors {
    int records;
    int startIndex;
    int limit;
    List<Tailor> items;

    Tailors({
        this.records,
        this.startIndex,
        this.limit,
        this.items,
    });

    factory Tailors.fromJson(Map<String, dynamic> json) => Tailors(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        items: List<Tailor>.from(json["tailors"].map((x) => Tailor.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "tailors": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Tailor {
    String key;
    String name;
    bool enabled;
    String created;
    String modified;
    Contact contact;

    Tailor({
        this.key,
        this.name,
        this.enabled,
        this.created,
        this.modified,
        this.contact,
    });

    factory Tailor.fromJson(Map<String, dynamic> json) => Tailor(
        key: json["key"],
        name: json["name"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        contact: Contact.fromJson(json["contact"]),
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "contact": contact.toJson(),
    };
}

class Contact {
    String address;
    String email;
    PrimaryNumber primaryNumber;
    GeoLocation geoLocation;

    Contact({
        this.address,
        this.email,
        this.primaryNumber,
        this.geoLocation,
    });

    factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        address: json["address"] == null ? null : json["address"],
        email: json["email"] == null ? null : json["email"],
        primaryNumber: PrimaryNumber.fromJson(json["primaryNumber"]),
        geoLocation: GeoLocation.fromJson(json["geoLocation"]),
    );

    Map<String, dynamic> toJson() => {
        "address": address == null ? null : address,
        "email": email == null ? null : email,
        "primaryNumber": primaryNumber.toJson(),
        "geoLocation": geoLocation.toJson(),
    };
}

// class GeoLocation {
//     double latitude;
//     double longitude;

//     GeoLocation({
//         this.latitude,
//         this.longitude,
//     });

//     factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
//         latitude: json["latitude"].toDouble(),
//         longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
//     );

//     Map<String, dynamic> toJson() => {
//         "latitude": latitude,
//         "longitude": longitude == null ? null : longitude,
//     };
// }

class PrimaryNumber {
    String code;
    String mobile;

    PrimaryNumber({
        this.code,
        this.mobile,
    });

    factory PrimaryNumber.fromJson(Map<String, dynamic> json) => PrimaryNumber(
        code: json["code"] == null ? null : json["code"],
        mobile: json["mobile"] == null ? null : json["mobile"],
    );

    Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "mobile": mobile == null ? null : mobile,
    };
}
