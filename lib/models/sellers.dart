// To parse this JSON data, do
//
//     final sellers = sellersFromJson(jsonString);

import 'dart:convert';

import 'package:compound/models/products.dart';
import 'package:compound/models/sellerProfile.dart';

Sellers sellersFromJson(String str) => Sellers.fromJson(json.decode(str));

String sellersToJson(Sellers data) => json.encode(data.toJson());

class Sellers {
  Sellers({
    this.records,
    this.startIndex,
    this.limit,
    this.items,
  });

  num records;
  num startIndex;
  num limit;
  List<Seller> items;

  factory Sellers.fromJson(Map<String, dynamic> json) => Sellers(
        records: json["records"] == null ? null : json["records"],
        startIndex: json["startIndex"] == null ? null : json["startIndex"],
        limit: json["limit"] == null ? null : json["limit"],
        items: List<Seller>.from(
            (json["sellers"] == null ? [] : json["sellers"])
                .map((x) => Seller.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "sellers": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Seller {
  Seller({
    this.documentId,
    this.key,
    this.accountType,
    this.photo,
    this.created,
    this.name,
    this.bio,
    this.known,
    this.designs,
    this.works,
    this.operations,
    this.contact,
    this.timing,
    this.establishmentTypeId,
    this.subscriptionTypeId,
    this.subscriptionType,
    this.establishmentType,
    this.ratingAverage,
  });

  String documentId;
  String key;
  RatingAverage ratingAverage;
  AccountType accountType;
  Photo photo;
  String created;
  String name;
  String bio;
  String known;
  String designs;
  String works;
  String operations;
  Contact contact;
  Timing timing;
  num establishmentTypeId;
  num subscriptionTypeId;
  Type subscriptionType;
  Type establishmentType;
  List<Product> products;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        documentId: json["documentId"],
        key: json["key"],
        accountType: accountTypeValues.map[json["accountType"]],
        photo: json["photo"] == null ? null : Photo.fromMap(json["photo"]),
        created: json["created"],
        name: json["name"],
        bio: json["bio"] == null ? null : json["bio"],
        known: json["known"] == null ? null : json["known"],
        designs: json["designs"] == null ? null : json["designs"],
        works: json["works"] == null ? null : json["works"],
        operations: json["operations"] == null ? null : json["operations"],
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
        timing: Timing.fromJson(json["timing"]),
        establishmentTypeId: json["establishmentTypeId"],
        subscriptionTypeId: json["subscriptionTypeId"],
        subscriptionType: Type.fromJson(json["subscriptionType"]),
        establishmentType: Type.fromJson(json["establishmentType"]),
        ratingAverage: json["ratingAverage"] == null
            ? null
            : RatingAverage.fromJson(json["ratingAverage"]),
      );

  Map<String, dynamic> toJson() => {
        "documentId": documentId,
        "key": key,
        "accountType": accountTypeValues.reverse[accountType],
        "photo": photo.toMap(),
        "created": created,
        "name": name,
        "bio": bio == null ? null : bio,
        "known": known == null ? null : known,
        "designs": designs == null ? null : designs,
        "works": works == null ? null : works,
        "operations": operations == null ? null : operations,
        "contact": contact?.toJson(),
        "timing": timing.toJson(),
        "establishmentTypeId": establishmentTypeId,
        "subscriptionTypeId": subscriptionTypeId,
        "subscriptionType": subscriptionType.toJson(),
        "ratingAverage": ratingAverage.toJson(),
        "establishmentType": establishmentType.toJson(),
      };
}

enum AccountType { SELLER }

final accountTypeValues = EnumValues({"SELLER": AccountType.SELLER});

class Contact {
  Contact({
    this.geoLocation,
    this.primaryNumber,
    this.secondaryNumber,
    this.email,
    this.address,
    this.city,
    this.pincode,
    this.state,
  });

  GeoLocation geoLocation;
  AryNumber primaryNumber;
  AryNumber secondaryNumber;
  String email;
  String address, city, state, pincode;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        geoLocation: json["geoLocation"] == null
            ? null
            : GeoLocation.fromJson(json["geoLocation"]),
        primaryNumber: AryNumber.fromJson(json["primaryNumber"]),
        secondaryNumber: json["secondaryNumber"] == null
            ? null
            : AryNumber.fromJson(json["secondaryNumber"]),
        email: json["email"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "geoLocation": geoLocation?.toJson(),
        "primaryNumber": primaryNumber?.toJson(),
        "secondaryNumber": secondaryNumber?.toJson(),
        "email": email,
        "address": address,
        "city": city,
        "state": state,
        "pincode": num?.parse(pincode),
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
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
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

  factory AryNumber.fromJson(Map<String, dynamic> json) => AryNumber(
        code: json["code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
      };
}

class Type {
  Type({
    this.id,
    this.name,
  });

  num id;
  String name;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
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

  Day sunday;
  Day monday;
  Day tuesday;
  Day wednesday;
  Day thursday;
  Day friday;
  Day saturday;

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        sunday: Day.fromJson(json["sunday"]),
        monday: Day.fromJson(json["monday"]),
        tuesday: Day.fromJson(json["tuesday"]),
        wednesday: Day.fromJson(json["wednesday"]),
        thursday: Day.fromJson(json["thursday"]),
        friday: Day.fromJson(json["friday"]),
        saturday: Day.fromJson(json["saturday"]),
      );

  Map<String, dynamic> toJson() => {
        "sunday": sunday.toJson(),
        "monday": monday.toJson(),
        "tuesday": tuesday.toJson(),
        "wednesday": wednesday.toJson(),
        "thursday": thursday.toJson(),
        "friday": friday.toJson(),
        "saturday": saturday.toJson(),
      };
}

class Day {
  Day({
    this.open,
    this.start,
    this.end,
  });

  bool open;
  num start;
  num end;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        open: json["open"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "start": start,
        "end": end,
      };
}

class RatingAverage {
  RatingAverage({
    this.rating,
    this.total,
    this.person,
  });

  int rating;
  int total;
  int person;

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

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

// // To parse this JSON data, do
// //
// //     final sellers = sellersFromJson(jsonString);

// import 'dart:convert';

// Sellers sellersFromJson(String str) => Sellers.fromJson(json.decode(str));

// String sellersToJson(Sellers data) => json.encode(data.toJson());

// class Sellers {
//   num records;
//   num startIndex;
//   num limit;
//   List<Seller> items;

//   Sellers({
//     this.records,
//     this.startIndex,
//     this.limit,
//     this.items,
//   });

//   factory Sellers.fromJson(Map<String, dynamic> json) => Sellers(
//         records: json["records"],
//         startIndex: json["startIndex"],
//         limit: json["limit"],
//         items:
//             List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "records": records,
//         "startIndex": startIndex,
//         "limit": limit,
//         "sellers": List<dynamic>.from(items.map((x) => x.toJson())),
//       };
// }

// class Seller {
//   String documentId;
//   String key;
//   String name;
//   String bio;
//   String works;

//   String operations;
//   Contact contact;
//   String created;
//   String accountType;
//   String known;
//   String designs;
//   Seller(
//       {this.documentId,
//       this.key,
//       this.name,
//       this.bio,
//       this.works,
//       this.operations,
//       this.contact,
//       this.created,
//       this.accountType,
//       this.designs,
//       this.known});

//   factory Seller.fromJson(Map<String, dynamic> json) => Seller(
//       documentId: json["documentId"],
//       key: json["key"],
//       name: json["name"],
//       bio: json["bio"],
//       works: json["works"] == null ? null : json["works"],
//       operations: json["operations"] == null ? null : json["operations"],
//       contact: Contact.fromJson(json["contact"]),
//       created: json["created"],
//       accountType: json["accountType"],
//       designs: json["designs"],
//       known: json["known"]);

//   Map<String, dynamic> toJson() => {
//         "documentId": documentId,
//         "key": key,
//         "name": name,
//         "bio": bio,
//         "works": works == null ? null : works,
//         "operations": operations == null ? null : operations,
//         "contact": contact.toJson(),
//         "created": created,
//         "accountType": accountType,
//         "designs": designs,
//         "known": known
//       };
// }

// class Contact {
//   GeoLocation geoLocation;
//   PrimaryNumber primaryNumber;

//   Contact({
//     this.geoLocation,
//     this.primaryNumber,
//   });

//   factory Contact.fromJson(Map<String, dynamic> json) => Contact(
//         geoLocation: json["geoLocation"] != null
//             ? GeoLocation.fromJson(json["geoLocation"])
//             : null,
//         primaryNumber: json["primaryNumber"] != null
//             ? PrimaryNumber.fromJson(json["primaryNumber"])
//             : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "geoLocation": geoLocation.toJson(),
//         "primaryNumber": primaryNumber.toJson(),
//       };
// }

// class GeoLocation {
//   double latitude;
//   double longitude;

//   GeoLocation({
//     this.latitude,
//     this.longitude,
//   });

//   factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
//         latitude: json["latitude"] != null ? json["latitude"].toDouble() : null,
//         longitude:
//             json["longitude"] != null ? json["longitude"].toDouble() : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "latitude": latitude,
//         "longitude": longitude,
//       };
// }

// class PrimaryNumber {
//   String code;
//   String mobile;

//   PrimaryNumber({
//     this.code,
//     this.mobile,
//   });

//   factory PrimaryNumber.fromJson(Map<String, dynamic> json) => PrimaryNumber(
//         code: json["code"],
//         mobile: json["mobile"],
//       );

//   Map<String, dynamic> toJson() => {
//         "code": code,
//         "mobile": mobile,
//       };
// }
