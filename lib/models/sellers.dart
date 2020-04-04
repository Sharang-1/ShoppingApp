// To parse this JSON data, do
//
//     final sellers = sellersFromJson(jsonString);

import 'dart:convert';

Sellers sellersFromJson(String str) => Sellers.fromJson(json.decode(str));

String sellersToJson(Sellers data) => json.encode(data.toJson());

class Sellers {
    int records;
    int startIndex;
    int limit;
    List<Seller> items;

    Sellers({
        this.records,
        this.startIndex,
        this.limit,
        this.items,
    });

    factory Sellers.fromJson(Map<String, dynamic> json) => Sellers(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        items: List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "sellers": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Seller {
    String documentId;
    String key;
    String name;
    String bio;
    String works;
    String operations;
    Contact contact;
    String created;
    String accountType;

    Seller({
        this.documentId,
        this.key,
        this.name,
        this.bio,
        this.works,
        this.operations,
        this.contact,
        this.created,
        this.accountType,
    });

    factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        documentId: json["documentId"],
        key: json["key"],
        name: json["name"],
        bio: json["bio"] == null ? null : json["bio"],
        works: json["works"] == null ? null : json["works"],
        operations: json["operations"] == null ? null : json["operations"],
        contact: Contact.fromJson(json["contact"]),
        created: json["created"],
        accountType: json["accountType"],
    );

    Map<String, dynamic> toJson() => {
        "documentId": documentId,
        "key": key,
        "name": name,
        "bio": bio == null ? null : bio,
        "works": works == null ? null : works,
        "operations": operations == null ? null : operations,
        "contact": contact.toJson(),
        "created": created,
        "accountType": accountType,
    };
}

class Contact {
    GeoLocation geoLocation;
    PrimaryNumber primaryNumber;

    Contact({
        this.geoLocation,
        this.primaryNumber,
    });

    factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        geoLocation: json["geoLocation"] == null ? null : GeoLocation.fromJson(json["geoLocation"]),
        primaryNumber: PrimaryNumber.fromJson(json["primaryNumber"]),
    );

    Map<String, dynamic> toJson() => {
        "geoLocation": geoLocation == null ? null : geoLocation.toJson(),
        "primaryNumber": primaryNumber.toJson(),
    };
}

class GeoLocation {
    double latitude;
    double longitude;

    GeoLocation({
        this.latitude,
        this.longitude,
    });

    factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class PrimaryNumber {
    String code;
    String mobile;

    PrimaryNumber({
        this.code,
        this.mobile,
    });

    factory PrimaryNumber.fromJson(Map<String, dynamic> json) => PrimaryNumber(
        code: json["code"],
        mobile: json["mobile"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
    };
}
