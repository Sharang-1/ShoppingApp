// To parse this JSON data, do
//
//     final sellers = sellersFromJson(jsonString);

import 'dart:convert';

import 'package:compound/models/products.dart';

Sellers sellersFromJson(String str) => Sellers.fromJson(json.decode(str));

String sellersToJson(Sellers data) => json.encode(data.toJson());

class Sellers {
  Sellers({
    this.records,
    this.startIndex,
    this.limit,
    this.items,
  });

  int? records;
  int? startIndex;
  int? limit;
  List<Seller>? items;

  factory Sellers.fromJson(Map<String, dynamic> json) => Sellers(
        records: json["records"] == null ? null : json["records"],
        startIndex: json["startIndex"] == null ? null : json["startIndex"],
        limit: json["limit"] == null ? null : json["limit"],
        items: json["sellers"] == null
            ? null
            : List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": records == null ? null : records,
        "startIndex": startIndex == null ? null : startIndex,
        "limit": limit == null ? null : limit,
        "sellers": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Seller {
  Seller(
      {this.documentId,
      this.key,
      this.accountType,
      this.name,
      this.created,
      this.modified,
      this.approved,
      this.enabled,
      this.intro,
      this.establishmentTypeId,
      this.subscriptionTypeId,
      this.photo,
      this.contact,
      this.owner,
      this.replacementPolicy,
      this.returnPolicy,
      this.subscriptionType,
      this.establishmentType,
      this.bio,
      this.known,
      this.designs,
      this.works,
      this.operations,
      this.timing,
      this.ratingAverage,
      this.designation,
      this.education,
      this.communityTypes});

  String? documentId;
  String? key;
  AccountType? accountType;
  String? name;
  String? created;
  String? modified;
  bool? approved;
  bool? enabled;
  String? intro;
  int? establishmentTypeId;
  int? subscriptionTypeId;
  Photo? photo;
  Contact? contact;
  Owner? owner;
  Policy? replacementPolicy;
  Policy? returnPolicy;
  Type? subscriptionType;
  Type? establishmentType;
  Type? communityTypes;
  String? bio;
  String? designation;
  String? education;
  String? known;
  String? designs;
  String? works;
  String? operations;
  Timing? timing;
  List<Product>? products;
  RatingAverage? ratingAverage;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        documentId: json["documentId"] == null ? null : json["documentId"],
        key: json["key"] == null ? null : json["key"],
        accountType: json["accountType"] == null
            ? null
            : accountTypeValues.map![json["accountType"]],
        name: json["name"] == null ? null : json["name"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        approved: json["approved"] == null ? null : json["approved"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        intro: json["intro"] == null ? null : json["intro"],
        designation: json["designation"] == null ? null : json["designation"],
        education: json["education"] == null ? null : json["education"],
        establishmentTypeId: json["establishmentTypeId"] == null
            ? null
            : json["establishmentTypeId"],
        subscriptionTypeId: json["subscriptionTypeId"] == null
            ? null
            : json["subscriptionTypeId"],
        photo: json["photo"] == null ? null : Photo.fromJson(json["photo"]),
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        replacementPolicy: json["replacementPolicy"] == null
            ? null
            : Policy.fromJson(json["replacementPolicy"]),
        returnPolicy: json["returnPolicy"] == null
            ? null
            : Policy.fromJson(json["returnPolicy"]),
        subscriptionType: json["subscriptionType"] == null
            ? null
            : Type.fromJson(json["subscriptionType"]),
        establishmentType: json["establishmentType"] == null
            ? null
            : Type.fromJson(json["establishmentType"]),
        bio: json["bio"] == null ? null : json["bio"],
        known: json["known"] == null ? null : json["known"],
        designs: json["designs"] == null ? null : json["designs"],
        works: json["works"] == null ? null : json["works"],
        operations: json["operations"] == null ? null : json["operations"],
        timing: json["timing"] == null ? null : Timing.fromJson(json["timing"]),
        ratingAverage: json["ratingAverage"] == null
            ? null
            : RatingAverage.fromJson(json["ratingAverage"]),
        communityTypes: json["communityTypes"] == null
            ? null
            : Type.fromJson(json["communityTypes"][0]),
      );

  Map<String, dynamic> toJson() => {
        "documentId": documentId == null ? null : documentId,
        "key": key == null ? null : key,
        "accountType":
            accountType == null ? null : accountTypeValues.reverse[accountType],
        "name": name == null ? null : name,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "approved": approved == null ? null : approved,
        "enabled": enabled == null ? null : enabled,
        "intro": intro == null ? null : intro,
        "designation": designation == null ? null : designation,
        "education": education == null ? null : education,
        "establishmentTypeId":
            establishmentTypeId == null ? null : establishmentTypeId,
        "subscriptionTypeId":
            subscriptionTypeId == null ? null : subscriptionTypeId,
        "photo": photo == null ? null : photo?.toJson(),
        "contact": contact == null ? null : contact?.toJson(),
        "owner": owner == null ? null : owner?.toJson(),
        "replacementPolicy":
            replacementPolicy == null ? null : replacementPolicy?.toJson(),
        "returnPolicy": returnPolicy == null ? null : returnPolicy?.toJson(),
        "subscriptionType":
            subscriptionType == null ? null : subscriptionType?.toJson(),
        "establishmentType":
            establishmentType == null ? null : establishmentType?.toJson(),
        "bio": bio == null ? null : bio,
        "known": known == null ? null : known,
        "designs": designs == null ? null : designs,
        "works": works == null ? null : works,
        "ratingAverage": ratingAverage == null ? null : ratingAverage?.toJson(),
        "operations": operations == null ? null : operations,
        "timing": timing == null ? null : timing?.toJson(),
        "communityTypes":
            communityTypes == null ? null : communityTypes?.toJson(),
      };
}

enum AccountType { SELLER }

final accountTypeValues = EnumValues({"SELLER": AccountType.SELLER});

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

  String? address;
  String? city;
  String? state;
  int? pincode;
  String? email;
  PrimaryNumber? primaryNumber;
  PrimaryNumber? secondaryNumber;
  GeoLocation? geoLocation;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        address: json["address"] == null ? null : json["address"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        email: json["email"] == null ? null : json["email"],
        primaryNumber: json["primaryNumber"] == null
            ? null
            : PrimaryNumber.fromJson(json["primaryNumber"]),
        secondaryNumber: json["secondaryNumber"] == null
            ? null
            : PrimaryNumber.fromJson(json["secondaryNumber"]),
        geoLocation: json["geoLocation"] == null
            ? null
            : GeoLocation.fromJson(json["geoLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address == null ? null : address,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "pincode": pincode == null ? null : pincode,
        "email": email == null ? null : email,
        "primaryNumber": primaryNumber == null ? null : primaryNumber?.toJson(),
        "secondaryNumber":
            secondaryNumber == null ? null : secondaryNumber?.toJson(),
        "geoLocation": geoLocation == null ? null : geoLocation?.toJson(),
      };
}

class GeoLocation {
  GeoLocation({
    this.latitude,
    this.longitude,
  });

  double? latitude;
  double? longitude;

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
      };
}

class PrimaryNumber {
  PrimaryNumber({
    this.code,
    this.mobile,
    this.display,
  });

  String? code;
  String? mobile;
  String? display;

  factory PrimaryNumber.fromJson(Map<String, dynamic> json) => PrimaryNumber(
        code: json["code"] == null ? null : json["code"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        display: json["display"] == null ? null : json["display"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "mobile": mobile == null ? null : mobile,
        "display": display == null ? null : display,
      };
}

class Type {
  Type({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class Owner {
  Owner({
    this.key,
    this.name,
  });

  String? key;
  String? name;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        key: json["key"] == null ? null : json["key"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "name": name == null ? null : name,
      };
}

class Photo {
  Photo({
    this.name,
    this.originalName,
    this.created,
  });

  String? name;
  String? originalName;
  String? created;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        name: json["name"] == null ? null : json["name"],
        originalName:
            json["originalName"] == null ? null : json["originalName"],
        created: json["created"] == null ? null : json["created"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "originalName": originalName == null ? null : originalName,
        "created": created == null ? null : created,
      };
}

class RatingAverage {
  RatingAverage({
    this.rating,
    this.total,
    this.person,
  });

  int? rating;
  int? total;
  int? person;

  factory RatingAverage.fromJson(Map<String, dynamic> json) => RatingAverage(
        rating: json["rating"],
        total: json["total"],
        person: json["person"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "total": total,
        "person": person,
      };
}

class Policy {
  Policy({
    this.supported,
    this.days,
    this.note,
    this.modified,
    this.created,
  });

  bool? supported;
  int? days;
  String? note;
  String? modified;
  String? created;

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        supported: json["supported"] == null ? null : json["supported"],
        days: json["days"] == null ? null : json["days"],
        note: json["note"] == null ? null : json["note"],
        modified: json["modified"] == null ? null : json["modified"],
        created: json["created"] == null ? null : json["created"],
      );

  Map<String, dynamic> toJson() => {
        "supported": supported == null ? null : supported,
        "days": days == null ? null : days,
        "note": note == null ? null : note,
        "modified": modified == null ? null : modified,
        "created": created == null ? null : created,
      };
}

class Timing {
  Timing({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  Day? sunday;
  Day? monday;
  Day? tuesday;
  Day? wednesday;
  Day? thursday;
  Day? friday;
  Day? saturday;

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        sunday: json["sunday"] == null ? null : Day.fromJson(json["sunday"]),
        monday: json["monday"] == null ? null : Day.fromJson(json["monday"]),
        tuesday: json["tuesday"] == null ? null : Day.fromJson(json["tuesday"]),
        wednesday:
            json["wednesday"] == null ? null : Day.fromJson(json["wednesday"]),
        thursday:
            json["thursday"] == null ? null : Day.fromJson(json["thursday"]),
        friday: json["friday"] == null ? null : Day.fromJson(json["friday"]),
        saturday:
            json["saturday"] == null ? null : Day.fromJson(json["saturday"]),
      );

  Map<String, dynamic> toJson() => {
        "sunday": sunday == null ? null : sunday?.toJson(),
        "monday": monday == null ? null : monday?.toJson(),
        "tuesday": tuesday == null ? null : tuesday?.toJson(),
        "wednesday": wednesday == null ? null : wednesday?.toJson(),
        "thursday": thursday == null ? null : thursday?.toJson(),
        "friday": friday == null ? null : friday?.toJson(),
        "saturday": saturday == null ? null : saturday?.toJson(),
      };
}

class Day {
  Day({
    this.open,
    this.start,
    this.end,
  });

  bool? open;
  int? start;
  int? end;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        open: json["open"] == null ? null : json["open"],
        start: json["start"] == null ? null : json["start"],
        end: json["end"] == null ? null : json["end"],
      );

  Map<String, dynamic> toJson() => {
        "open": open == null ? null : open,
        "start": start == null ? null : start,
        "end": end == null ? null : end,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
