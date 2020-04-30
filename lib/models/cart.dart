// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
    String key;
    String modified;
    Owner owner;
    List<Item> items;

    Cart({
        this.key,
        this.modified,
        this.owner,
        this.items,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        key: json["key"],
        modified: json["modified"],
        owner: Owner.fromJson(json["owner"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "modified": modified,
        "owner": owner.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    num productId;
    String size;
    num quantity;
    String inserted;
    Product product;

    Item({
        this.productId,
        this.size,
        this.quantity,
        this.inserted,
        this.product,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"],
        size: json["size"] == null ? null : json["size"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        inserted: json["inserted"],
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "size": size == null ? null : size,
        "quantity": quantity == null ? null : quantity,
        "inserted": inserted,
        "product": product.toJson(),
    };
}

class Product {
    String key;
    String name;
    String description;
    bool enabled;
    String created;
    String modified;
    Owner account;
    Owner owner;
    num price;
    Shipment shipment;
    bool available;
    Rating rating;
    ProductPhoto photo;
    num discount;
    bool productNew;
    Category whoMadeIt;
    List<Variation> variations;
    String typeOfWork;
    bool margin;
    Category productFor;
    Category category;
    Category pieces;
    Category sleeveLength;
    Category stitchingType;
    List<Category> workOn;
    String fabricDetails;
    Category topsLength;
    String style;
    String neck;
    bool hangings;
    num breath;
    num length;
    String dimensions;

    Product({
        this.key,
        this.name,
        this.description,
        this.enabled,
        this.created,
        this.modified,
        this.account,
        this.owner,
        this.price,
        this.shipment,
        this.available,
        this.rating,
        this.photo,
        this.discount,
        this.productNew,
        this.whoMadeIt,
        this.variations,
        this.typeOfWork,
        this.margin,
        this.productFor,
        this.category,
        this.pieces,
        this.sleeveLength,
        this.stitchingType,
        this.workOn,
        this.fabricDetails,
        this.topsLength,
        this.style,
        this.neck,
        this.hangings,
        this.breath,
        this.length,
        this.dimensions,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        key: json["key"],
        name: json["name"],
        description: json["description"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        account: Owner.fromJson(json["account"]),
        owner: Owner.fromJson(json["owner"]),
        price: json["price"],
        shipment: Shipment.fromJson(json["shipment"]),
        available: json["available"],
        rating: Rating.fromJson(json["rating"]),
        photo: json["photo"] == null ? null : ProductPhoto.fromJson(json["photo"]),
        discount: json["discount"],
        productNew: json["new"],
        whoMadeIt: json["whoMadeIt"] == null ? null : Category.fromJson(json["whoMadeIt"]),
        variations: json["variations"] == null ? null : List<Variation>.from(json["variations"].map((x) => Variation.fromJson(x))),
        typeOfWork: json["typeOfWork"] == null ? null : json["typeOfWork"],
        margin: json["margin"] == null ? null : json["margin"],
        productFor: json["productFor"] == null ? null : Category.fromJson(json["productFor"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        pieces: json["pieces"] == null ? null : Category.fromJson(json["pieces"]),
        sleeveLength: json["sleeveLength"] == null ? null : Category.fromJson(json["sleeveLength"]),
        stitchingType: json["stitchingType"] == null ? null : Category.fromJson(json["stitchingType"]),
        workOn: json["workOn"] == null ? null : List<Category>.from(json["workOn"].map((x) => Category.fromJson(x))),
        fabricDetails: json["fabricDetails"] == null ? null : json["fabricDetails"],
        topsLength: json["topsLength"] == null ? null : Category.fromJson(json["topsLength"]),
        style: json["style"] == null ? null : json["style"],
        neck: json["neck"] == null ? null : json["neck"],
        hangings: json["hangings"] == null ? null : json["hangings"],
        breath: json["breath"] == null ? null : json["breath"],
        length: json["length"] == null ? null : json["length"],
        dimensions: json["dimensions"] == null ? null : json["dimensions"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "description": description,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "account": account.toJson(),
        "owner": owner.toJson(),
        "price": price,
        "shipment": shipment.toJson(),
        "available": available,
        "rating": rating.toJson(),
        "photo": photo == null ? null : photo.toJson(),
        "discount": discount,
        "new": productNew,
        "whoMadeIt": whoMadeIt == null ? null : whoMadeIt.toJson(),
        "variations": variations == null ? null : List<dynamic>.from(variations.map((x) => x.toJson())),
        "typeOfWork": typeOfWork == null ? null : typeOfWork,
        "margin": margin == null ? null : margin,
        "productFor": productFor == null ? null : productFor.toJson(),
        "category": category == null ? null : category.toJson(),
        "pieces": pieces == null ? null : pieces.toJson(),
        "sleeveLength": sleeveLength == null ? null : sleeveLength.toJson(),
        "stitchingType": stitchingType == null ? null : stitchingType.toJson(),
        "workOn": workOn == null ? null : List<dynamic>.from(workOn.map((x) => x.toJson())),
        "fabricDetails": fabricDetails == null ? null : fabricDetails,
        "topsLength": topsLength == null ? null : topsLength.toJson(),
        "style": style == null ? null : style,
        "neck": neck == null ? null : neck,
        "hangings": hangings == null ? null : hangings,
        "breath": breath == null ? null : breath,
        "length": length == null ? null : length,
        "dimensions": dimensions == null ? null : dimensions,
    };
}

class Owner {
    String key;

    Owner({
        this.key,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
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

class Variation {
    String size;
    num quantity;
    String color;

    Variation({
        this.size,
        this.quantity,
        this.color,
    });

    factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        size: json["size"],
        quantity: json["quantity"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "size": size,
        "quantity": quantity,
        "color": color,
    };
}
