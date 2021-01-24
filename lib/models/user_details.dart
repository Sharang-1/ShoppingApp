// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    this.key,
    this.name,
    this.description,
    this.enabled,
    this.created,
    this.modified,
    this.firstName,
    this.lastName,
    this.contact,
    this.appUser,
    this.login,
    this.facebookUser,
    this.mobileUser,
    this.facebookLogin,
    this.mobileLogin,
  });

  String key;
  String name;
  String description;
  bool enabled;
  String created;
  String modified;
  String firstName;
  String lastName;
  UserDetailsContact contact;
  bool appUser;
  String login;
  bool facebookUser;
  bool mobileUser;
  bool facebookLogin;
  bool mobileLogin;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        key: json["key"],
        name: json["name"],
        description: json["description"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        contact: UserDetailsContact.fromJson(json["contact"]),
        appUser: json["appUser"],
        login: json["login"],
        facebookUser: json["facebookUser"],
        mobileUser: json["mobileUser"],
        facebookLogin: json["facebookLogin"],
        mobileLogin: json["mobileLogin"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "description": description,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "firstName": firstName,
        "lastName": lastName,
        "contact": contact.toJson(),
        "appUser": appUser,
        "login": login,
        "facebookUser": facebookUser,
        "mobileUser": mobileUser,
        "facebookLogin": facebookLogin,
        "mobileLogin": mobileLogin,
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

  String address = "";
  String city = "";
  String googleAddress = "";
  Phone phone;
  int pincode;
  String state = "";

  factory UserDetailsContact.fromJson(Map<String, dynamic> json) =>
      UserDetailsContact(
        address: json["address"] == null ? "" : json["address"],
        city: json["city"],
        googleAddress:
            json["googleAddress"] == null ? "" : json["googleAddress"],
        phone: json["phone"] != null ? Phone.fromJson(json["phone"]) : null,
        pincode: json["pincode"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "googleAddress": googleAddress,
        "phone": phone?.toJson() ?? null,
        "pincode": pincode,
        "state": state,
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
