// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    this.account,
    this.appUser,
    this.contact,
    this.created,
    this.description,
    this.deviceTokens,
    this.email,
    this.enabled,
    this.facebookLogin,
    this.facebookUser,
    this.firstName,
    this.id,
    this.key,
    this.lastName,
    this.login,
    this.mobileLogin,
    this.mobileUser,
    this.modified,
    this.name,
    this.password,
    this.uuid,
  });

  Account account;
  bool appUser;
  UserDetailsContact contact;
  DateTime created;
  String description;
  List<String> deviceTokens;
  String email;
  bool enabled;
  bool facebookLogin;
  bool facebookUser;
  String firstName;
  int id;
  String key;
  String lastName;
  DateTime login;
  bool mobileLogin;
  bool mobileUser;
  DateTime modified;
  String name;
  String password;
  String uuid;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        account: Account.fromJson(json["account"]),
        appUser: json["appUser"],
        contact: UserDetailsContact.fromJson(json["contact"]),
        created: DateTime.parse(json["created"]),
        description: json["description"],
        deviceTokens: List<String>.from(json["deviceTokens"].map((x) => x)),
        email: json["email"],
        enabled: json["enabled"],
        facebookLogin: json["facebookLogin"],
        facebookUser: json["facebookUser"],
        firstName: json["firstName"],
        id: json["id"],
        key: json["key"],
        lastName: json["lastName"],
        login: DateTime.parse(json["login"]),
        mobileLogin: json["mobileLogin"],
        mobileUser: json["mobileUser"],
        modified: DateTime.parse(json["modified"]),
        name: json["name"],
        password: json["password"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "account": account.toJson(),
        "appUser": appUser,
        "contact": contact.toJson(),
        "created": created.toIso8601String(),
        "description": description,
        "deviceTokens": List<dynamic>.from(deviceTokens.map((x) => x)),
        "email": email,
        "enabled": enabled,
        "facebookLogin": facebookLogin,
        "facebookUser": facebookUser,
        "firstName": firstName,
        "id": id,
        "key": key,
        "lastName": lastName,
        "login": login.toIso8601String(),
        "mobileLogin": mobileLogin,
        "mobileUser": mobileUser,
        "modified": modified.toIso8601String(),
        "name": name,
        "password": password,
        "uuid": uuid,
      };
}

class Account {
  Account({
    this.accountType,
    this.approved,
    this.bio,
    this.categories,
    this.contact,
    this.created,
    this.description,
    this.designs,
    this.enabled,
    this.establishmentType,
    this.establishmentTypeId,
    this.id,
    this.key,
    this.known,
    this.modified,
    this.name,
    this.operations,
    this.photo,
    this.rating,
    this.subscriptionType,
    this.subscriptionTypeId,
    this.timing,
    this.uuid,
    this.works,
  });

  String accountType;
  bool approved;
  String bio;
  List<Category> categories;
  AccountContact contact;
  DateTime created;
  String description;
  String designs;
  bool enabled;
  EstablishmentType establishmentType;
  int establishmentTypeId;
  int id;
  String key;
  String known;
  DateTime modified;
  String name;
  String operations;
  Photo photo;
  Rating rating;
  EstablishmentType subscriptionType;
  int subscriptionTypeId;
  Timing timing;
  String uuid;
  String works;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        accountType: json["accountType"],
        approved: json["approved"],
        bio: json["bio"],
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        contact: AccountContact.fromJson(json["contact"]),
        created: DateTime.parse(json["created"]),
        description: json["description"],
        designs: json["designs"],
        enabled: json["enabled"],
        establishmentType:
            EstablishmentType.fromJson(json["establishmentType"]),
        establishmentTypeId: json["establishmentTypeId"],
        id: json["id"],
        key: json["key"],
        known: json["known"],
        modified: DateTime.parse(json["modified"]),
        name: json["name"],
        operations: json["operations"],
        photo: Photo.fromJson(json["photo"]),
        rating: Rating.fromJson(json["rating"]),
        subscriptionType: EstablishmentType.fromJson(json["subscriptionType"]),
        subscriptionTypeId: json["subscriptionTypeId"],
        timing: Timing.fromJson(json["timing"]),
        uuid: json["uuid"],
        works: json["works"],
      );

  Map<String, dynamic> toJson() => {
        "accountType": accountType,
        "approved": approved,
        "bio": bio,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "contact": contact.toJson(),
        "created": created.toIso8601String(),
        "description": description,
        "designs": designs,
        "enabled": enabled,
        "establishmentType": establishmentType.toJson(),
        "establishmentTypeId": establishmentTypeId,
        "id": id,
        "key": key,
        "known": known,
        "modified": modified.toIso8601String(),
        "name": name,
        "operations": operations,
        "photo": photo.toJson(),
        "rating": rating.toJson(),
        "subscriptionType": subscriptionType.toJson(),
        "subscriptionTypeId": subscriptionTypeId,
        "timing": timing.toJson(),
        "uuid": uuid,
        "works": works,
      };
}

class Category {
  Category({
    this.banner,
    this.caption,
    this.enabled,
    this.filter,
    this.forApp,
    this.id,
    this.name,
    this.order,
    this.productFor,
  });

  Photo banner;
  String caption;
  bool enabled;
  String filter;
  bool forApp;
  int id;
  String name;
  int order;
  EstablishmentType productFor;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        banner: Photo.fromJson(json["banner"]),
        caption: json["caption"],
        enabled: json["enabled"],
        filter: json["filter"],
        forApp: json["forApp"],
        id: json["id"],
        name: json["name"],
        order: json["order"],
        productFor: EstablishmentType.fromJson(json["productFor"]),
      );

  Map<String, dynamic> toJson() => {
        "banner": banner.toJson(),
        "caption": caption,
        "enabled": enabled,
        "filter": filter,
        "forApp": forApp,
        "id": id,
        "name": name,
        "order": order,
        "productFor": productFor.toJson(),
      };
}

class Photo {
  Photo({
    this.name,
    this.originalName,
    this.path,
  });

  String name;
  String originalName;
  String path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        name: json["name"],
        originalName: json["originalName"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "originalName": originalName,
        "path": path,
      };
}

class EstablishmentType {
  EstablishmentType({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory EstablishmentType.fromJson(Map<String, dynamic> json) =>
      EstablishmentType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class AccountContact {
  AccountContact({
    this.address,
    this.city,
    this.email,
    this.geoLocation,
    this.pincode,
    this.primaryNumber,
    this.residentialAddress,
    this.secondaryNumber,
    this.state,
  });

  String address;
  String city;
  String email;
  GeoLocation geoLocation;
  int pincode;
  Phone primaryNumber;
  String residentialAddress;
  Phone secondaryNumber;
  String state;

  factory AccountContact.fromJson(Map<String, dynamic> json) => AccountContact(
        address: json["address"],
        city: json["city"],
        email: json["email"],
        geoLocation: GeoLocation.fromJson(json["geoLocation"]),
        pincode: json["pincode"],
        primaryNumber: Phone.fromJson(json["primaryNumber"]),
        residentialAddress: json["residentialAddress"],
        secondaryNumber: Phone.fromJson(json["secondaryNumber"]),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "email": email,
        "geoLocation": geoLocation.toJson(),
        "pincode": pincode,
        "primaryNumber": primaryNumber.toJson(),
        "residentialAddress": residentialAddress,
        "secondaryNumber": secondaryNumber.toJson(),
        "state": state,
      };
}

class GeoLocation {
  GeoLocation({
    this.latitude,
    this.longitude,
  });

  int latitude;
  int longitude;

  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Phone {
  Phone({
    this.code,
    this.mobile,
  });

  String code;
  String mobile;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        code: json["code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
      };
}

class Rating {
  Rating({
    this.rate,
  });

  int rate;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
      };
}

class Timing {
  Timing({
    this.friday,
    this.monday,
    this.saturday,
    this.sunday,
    this.thursday,
    this.tuesday,
    this.wednesday,
  });

  Day friday;
  Day monday;
  Day saturday;
  Day sunday;
  Day thursday;
  Day tuesday;
  Day wednesday;

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        friday: Day.fromJson(json["friday"]),
        monday: Day.fromJson(json["monday"]),
        saturday: Day.fromJson(json["saturday"]),
        sunday: Day.fromJson(json["sunday"]),
        thursday: Day.fromJson(json["thursday"]),
        tuesday: Day.fromJson(json["tuesday"]),
        wednesday: Day.fromJson(json["wednesday"]),
      );

  Map<String, dynamic> toJson() => {
        "friday": friday.toJson(),
        "monday": monday.toJson(),
        "saturday": saturday.toJson(),
        "sunday": sunday.toJson(),
        "thursday": thursday.toJson(),
        "tuesday": tuesday.toJson(),
        "wednesday": wednesday.toJson(),
      };
}

class Day {
  Day({
    this.end,
    this.open,
    this.start,
  });

  int end;
  bool open;
  int start;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        end: json["end"],
        open: json["open"],
        start: json["start"],
      );

  Map<String, dynamic> toJson() => {
        "end": end,
        "open": open,
        "start": start,
      };
}

class UserDetailsContact {
  UserDetailsContact({
    this.address,
    this.city,
    this.googleAddress,
    this.phone,
    this.pincode,
    this.state,
  });

  String address;
  String city;
  String googleAddress;
  Phone phone;
  int pincode;
  String state;

  factory UserDetailsContact.fromJson(Map<String, dynamic> json) =>
      UserDetailsContact(
        address: json["address"],
        city: json["city"],
        googleAddress: json["googleAddress"],
        phone: Phone.fromJson(json["phone"]),
        pincode: json["pincode"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "googleAddress": googleAddress,
        "phone": phone.toJson(),
        "pincode": pincode,
        "state": state,
      };
}
