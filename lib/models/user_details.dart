import 'dart:convert';

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

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
    this.age,
    this.gender,
    this.measure,
    this.email,
    this.size,
    this.contact,
    this.photo,
    this.appUser,
    this.login,
    this.facebookUser,
    this.mobileUser,
    this.facebookLogin,
    this.mobileLogin,
  });

  String? key;
  String? name;
  String? description;
  bool? enabled;
  String? created;
  String? modified;
  String? firstName;
  String? lastName;
  Age? age;
  Gender? gender;
  Measure? measure;
  String? email;
  String? size;
  UserDetailsContact? contact;
  UserPhoto? photo;
  bool? appUser;
  String? login;
  bool? facebookUser;
  bool? mobileUser;
  bool? facebookLogin;
  bool? mobileLogin;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        key: json["key"],
        name: json["name"],
        description: json["description"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        // age: Age.fromJson(json["age"]),
        age: json["age"] == null ? null : Age.fromJson(json["age"]),
        // gender: Gender.fromJson(json["gender"]),
        gender: json["gender"] == null ? null : Gender.fromJson(json["gender"]),
        measure: json["measure"] == null ? Measure() : Measure.fromJson(json["measure"]),
        email: json["email"] != null ? json["email"] : null,
        size: json["size"],
        contact: UserDetailsContact.fromJson(json["contact"]),
        photo: json["photo"] == null ? null : UserPhoto.fromJson(json["photo"]),
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
        "age": age == null ? null : age!.toJson(),
        "gender": gender == null ? null : gender!.toJson(),
        "measure": measure == null ? null : measure!.toJson(),
        "email": email,
        "size": size,
        "contact": contact!.toJson(),
        "photo": photo == null ? null : photo!.toJson(),
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

  String? address = "";
  String? city = "";
  String? googleAddress = "";
  Phone? phone;
  int? pincode;
  String? state = "";

  factory UserDetailsContact.fromJson(Map<String, dynamic> json) => UserDetailsContact(
        address: json["address"] == null ? "" : json["address"],
        city: json["city"],
        googleAddress: json["googleAddress"] == null ? "" : json["googleAddress"],
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

  String? code;
  String? mobile;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        code: json["code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
      };
}

class UserPhoto {
  UserPhoto({
    this.name,
    this.originalName,
  });

  String? name;
  String? originalName;

  factory UserPhoto.fromJson(Map<String, dynamic> json) => UserPhoto(
        name: json["name"],
        originalName: json["originalName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "originalName": originalName,
      };
}

class Age {
  Age({required this.id, required this.name});

  int id;
  String name;

  factory Age.fromJson(Map<String, dynamic> json) => Age(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Gender {
  Gender({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Gender.fromJson(Map<String, dynamic> json) => Gender(
        id: json["id"],
        name : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name" : name,
      };
}

class Measure {
  Measure({this.shoulders, this.chest, this.waist, this.hips, this.height});

  num? shoulders;
  num? chest;
  num? waist;
  num? hips;
  num? height;

  factory Measure.fromJson(Map<String, dynamic> json) => Measure(
        shoulders: json["shoulders"] == null ? null : json["shoulders"],
        chest: json["chest"] == null ? null : json["chest"],
        waist: json["waist"] == null ? null : json["waist"],
        hips: json["hips"] == null ? null : json["hips"],
        height: json["height"] == null ? null : json["height"],
      );

  Map<String, dynamic> toJson() => {
        "shoulders": shoulders,
        "chest": chest,
        "waist": waist,
        "hips": hips,
        "height": height,
      };
}
