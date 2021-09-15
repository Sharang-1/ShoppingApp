import 'dart:convert';

SellerProfile sellerProfileFromMap(String str) =>
    SellerProfile.fromMap(json.decode(str));

String sellerProfileToMap(SellerProfile data) => json.encode(data.toMap());

class SellerProfile {
  SellerProfile({
    this.key,
    this.created,
    this.modified,
    this.photos,
    this.accountId,
  });

  String key;
  String created;
  String modified;
  List<Photo> photos;
  String accountId;

  factory SellerProfile.fromMap(Map<String, dynamic> json) => SellerProfile(
        key: json["key"],
        created: json["created"],
        modified: json["modified"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromMap(x))),
        accountId: json["accountId"],
      );

  Map<String, dynamic> toMap() => {
        "key": key,
        "created": created,
        "modified": modified,
        "photos": List<dynamic>.from(photos.map((x) => x.toMap())),
        "accountId": accountId,
      };
}

class Photo {
  Photo({
    this.name,
    this.originalName,
  });

  String name;
  String originalName;

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        name: json["name"],
        originalName: json["originalName"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "originalName": originalName,
      };
}
