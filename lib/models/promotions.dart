// To parse this JSON data, do
//
//     final promotions = promotionsFromJson(jsonString);

import 'dart:convert';

Promotions promotionsFromJson(String str) => Promotions.fromJson(json.decode(str));

String promotionsToJson(Promotions data) => json.encode(data.toJson());

class Promotions {
    int records;
    int startIndex;
    int limit;
    List<Promotion> promotions;

    Promotions({
        this.records,
        this.startIndex,
        this.limit,
        this.promotions,
    });

    factory Promotions.fromJson(Map<String, dynamic> json) => Promotions(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        promotions: List<Promotion>.from(json["promotions"].map((x) => Promotion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "promotions": List<dynamic>.from(promotions.map((x) => x.toJson())),
    };
}

class Promotion {
    String key;
    String name;
    bool enabled;
    String created;
    String modified;
    String startDate;
    String endDate;
    int discount;
    bool exclusive;
    String position;
    Banner banner;
    List<int> products;
    String filter;
    int time;

    Promotion({
        this.key,
        this.name,
        this.enabled,
        this.created,
        this.modified,
        this.startDate,
        this.endDate,
        this.discount,
        this.exclusive,
        this.position,
        this.banner,
        this.products,
        this.filter,
        this.time,
    });

    factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        key: json["key"],
        name: json["name"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        discount: json["discount"] == null ? null : json["discount"],
        exclusive: json["exclusive"] == null ? null : json["exclusive"],
        position: json["position"] == null ? null : json["position"],
        banner: json["banner"] == null ? null : Banner.fromJson(json["banner"]),
        products: json["products"] == null ? null : List<int>.from(json["products"].map((x) => x)),
        filter: json["filter"] == null ? null : json["filter"],
        time: json["time"] == null ? null : json["time"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "startDate": startDate,
        "endDate": endDate,
        "discount": discount == null ? null : discount,
        "exclusive": exclusive == null ? null : exclusive,
        "position": position == null ? null : position,
        "banner": banner == null ? null : banner.toJson(),
        "products": products == null ? null : List<dynamic>.from(products.map((x) => x)),
        "filter": filter == null ? null : filter,
        "time": time == null ? null : time,
    };
}

class Banner {
    String name;
    String originalName;

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
