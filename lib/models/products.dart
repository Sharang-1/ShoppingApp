// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
    num records;
    num startIndex;
    num limit;
    List<Product> items;

    Products({
        this.records,
        this.startIndex,
        this.limit,
        this.items,
    });

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        items: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "products": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Product {
    String key;
    String name;
    String description;
    bool enabled;
    String created;
    String modified;
    Account account;
    Account owner;
    String pieces;
    String fabric;
    String work;
    String color;
    String stitchingType;
    num price;
    List<Category> categories;
    List<Category> subCategories;
    List<Size> sizes;
    Shipment shipment;
    bool available;
    Rating rating;
    num discount;
    bool productNew;
    ProductPhoto photo;
    num oldPrice;

    Product({
        this.key,
        this.name,
        this.description,
        this.enabled,
        this.created,
        this.modified,
        this.account,
        this.owner,
        this.pieces,
        this.fabric,
        this.work,
        this.color,
        this.stitchingType,
        this.price,
        this.categories,
        this.subCategories,
        this.sizes,
        this.shipment,
        this.available,
        this.rating,
        this.discount,
        this.productNew,
        this.photo,
        this.oldPrice,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        key: json["key"],
        name: json["name"],
        description: json["description"] == null ? null : json["description"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        account: Account.fromJson(json["account"]),
        owner: Account.fromJson(json["owner"]),
        pieces: json["pieces"] == null ? null : json["pieces"],
        fabric: json["fabric"] == null ? null : json["fabric"],
        work: json["work"] == null ? null : json["work"],
        color: json["color"] == null ? null : json["color"],
        stitchingType: json["stitchingType"] == null ? null : json["stitchingType"],
        price: json["price"],
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        subCategories: List<Category>.from(json["subCategories"].map((x) => Category.fromJson(x))),
        sizes: List<Size>.from(json["sizes"].map((x) => Size.fromJson(x))),
        shipment: Shipment.fromJson(json["shipment"]),
        available: json["available"],
        rating: Rating.fromJson(json["rating"]),
        discount: json["discount"] == null ? null : json["discount"],
        productNew: json["new"],
        photo: json["photo"] == null ? null : ProductPhoto.fromJson(json["photo"]),
        oldPrice: json["oldPrice"] == null ? null : json["oldPrice"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "description": description == null ? null : description,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "account": account.toJson(),
        "owner": owner.toJson(),
        "pieces": pieces == null ? null : pieces,
        "fabric": fabric == null ? null : fabric,
        "work": work == null ? null : work,
        "color": color == null ? null : color,
        "stitchingType": stitchingType == null ? null : stitchingType,
        "price": price,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "subCategories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
        "sizes": List<dynamic>.from(sizes.map((x) => x.toJson())),
        "shipment": shipment.toJson(),
        "available": available,
        "rating": rating.toJson(),
        "discount": discount == null ? null : discount,
        "new": productNew,
        "photo": photo == null ? null : photo.toJson(),
        "oldPrice": oldPrice == null ? null : oldPrice,
    };
}

class Account {
    String key;

    Account({
        this.key,
    });

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        key: json["key"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
    };
}

class Category {
    num id;

    Category({
        this.id,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}

class ProductPhoto {
    List<PhotoElement> photos;
    String accountId;
    String productId;

    ProductPhoto({
        this.photos,
        this.accountId,
        this.productId,
    });

    factory ProductPhoto.fromJson(Map<String, dynamic> json) => ProductPhoto(
        photos: List<PhotoElement>.from(json["photos"].map((x) => PhotoElement.fromJson(x))),
        accountId: json["accountId"],
        productId: json["productId"],
    );

    Map<String, dynamic> toJson() => {
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "accountId": accountId,
        "productId": productId,
    };
}

class PhotoElement {
    String name;
    String originalName;

    PhotoElement({
        this.name,
        this.originalName,
    });

    factory PhotoElement.fromJson(Map<String, dynamic> json) => PhotoElement(
        name: json["name"],
        originalName: json["originalName"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "originalName": originalName,
    };
}

class Rating {
    num rate;

    Rating({
        this.rate,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"],
    );

    Map<String, dynamic> toJson() => {
        "rate": rate,
    };
}

class Shipment {
    num days;

    Shipment({
        this.days,
    });

    factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        days: json["days"],
    );

    Map<String, dynamic> toJson() => {
        "days": days,
    };
}

class Size {
    String size;
    num priceDifference;
    num quantity;

    Size({
        this.size,
        this.priceDifference,
        this.quantity,
    });

    factory Size.fromJson(Map<String, dynamic> json) => Size(
        size: json["size"],
        priceDifference: json["priceDifference"],
        quantity: json["quantity"] == null ? null : json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "size": size,
        "priceDifference": priceDifference,
        "quantity": quantity == null ? null : quantity,
    };
}
