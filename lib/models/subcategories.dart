// To parse this JSON data, do
//
//     final subcategories = subcategoriesFromJson(jsonString);

import 'dart:convert';

Subcategories subcategoriesFromJson(String str) => Subcategories.fromJson(json.decode(str));

String subcategoriesToJson(Subcategories data) => json.encode(data.toJson());

class Subcategories {
    int records;
    int startIndex;
    int limit;
    List<Category> items;

    Subcategories({
        this.records,
        this.startIndex,
        this.limit,
        this.items,
    });

    factory Subcategories.fromJson(Map<String, dynamic> json) => Subcategories(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        items: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "categories": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Category {
    int id;
    String name;
    bool enabled;
    int order;
    String filter;
    String caption;
    bool forApp;
    Banner banner;
    ProductCategory productCategory;

    Category({
        this.id,
        this.name,
        this.enabled,
        this.order,
        this.filter,
        this.caption,
        this.forApp,
        this.banner,
        this.productCategory,
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
        productCategory: json["productCategory"] == null ? null : ProductCategory.fromJson(json["productCategory"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "enabled": enabled,
        "order": order,
        "filter": filter,
        "caption": caption,
        "forApp": forApp,
        "banner": banner == null ? null : banner.toJson(),
        "productCategory": productCategory == null ? null : productCategory.toJson(),
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

class ProductCategory {
    int id;
    String name;

    ProductCategory({
        this.id,
        this.name,
    });

    factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
