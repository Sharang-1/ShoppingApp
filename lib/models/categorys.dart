import 'dart:convert';

Categorys categorysFromJson(String str) => Categorys.fromJson(json.decode(str));

String categorysToJson(Categorys data) => json.encode(data.toJson());

class Categorys {
  int? records;
  int? startIndex;
  int? limit;
  List<Category>? items;

  Categorys({
    this.records,
    this.startIndex,
    this.limit,
    this.items,
  });

  factory Categorys.fromJson(Map<String, dynamic> json) => Categorys(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        items: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "categories": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Category {
  int? id;
  String? name;
  bool? enabled;
  int? order;
  String? filter;
  String? caption;
  bool? forApp;
  Banner? banner;
  ProductFor? productFor;

  Category({
    this.id,
    this.name,
    this.enabled,
    this.order,
    this.filter,
    this.caption,
    this.forApp,
    this.banner,
    this.productFor,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        enabled: json["enabled"],
        order: json["order"],
        filter: json["filter"],
        caption: json["caption"],
        forApp: json["forApp"],
        banner: json["banner"] == null ? null : Banner.fromJson(json["banner"]),
        productFor: json["productFor"] == null
            ? null
            : ProductFor.fromJson(json["productFor"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "enabled": enabled,
        "order": order,
        "filter": filter,
        "caption": caption,
        "forApp": forApp,
        "banner": banner == null ? null : banner?.toJson(),
        "productFor": productFor == null ? null : productFor?.toJson(),
      };
}

class Banner {
  String? name;
  String? originalName;

  Banner({
    this.name,
    this.originalName,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        name: json["name"],
        originalName: json["originalName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "originalName": originalName,
      };
}

class ProductFor {
  int? id;
  Name? name;

  ProductFor({
    this.id,
    this.name,
  });

  factory ProductFor.fromJson(Map<String, dynamic> json) => ProductFor(
        id: json["id"],
        name: nameValues.map![json["name"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
      };
}

enum Name { WOMEN }

final nameValues = EnumValues({"Women": Name.WOMEN});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap ?? {};
  }
}
