// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

import 'package:compound/models/sellers.dart';

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
        items: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
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
  num price;
  BlousePadding whoMadeIt;
  Shipment shipment;
  bool available;
  List<Variation> variations;
  String typeOfWork;
  String fabricDetails;
  bool margin;
  BlousePadding productFor;
  BlousePadding category;
  bool hangings;
  num breath;
  num length;
  String style;
  String dimensions;
  Rating rating;
  ProductPhoto photo;
  num discount;
  bool productNew;
  String neckCut;
  String backCut;
  BlousePadding blousePadding;
  BlousePadding sleeveLength;
  BlousePadding stitchingType;
  List<BlousePadding> workOn;
  BlousePadding topsLength;
  BlousePadding pieces;
  String neck;
  num waist;
  num flair;
  bool canCan;
  BlousePadding made;
  String typeOfSaree;
  num oldPrice;
  Seller seller;
  Cost cost;

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
    this.whoMadeIt,
    this.shipment,
    this.available,
    this.variations,
    this.typeOfWork,
    this.fabricDetails,
    this.margin,
    this.productFor,
    this.category,
    this.hangings,
    this.breath,
    this.length,
    this.style,
    this.dimensions,
    this.rating,
    this.photo,
    this.discount,
    this.productNew,
    this.neckCut,
    this.backCut,
    this.blousePadding,
    this.sleeveLength,
    this.stitchingType,
    this.workOn,
    this.topsLength,
    this.pieces,
    this.neck,
    this.waist,
    this.flair,
    this.canCan,
    this.made,
    this.typeOfSaree,
    this.oldPrice,
    this.seller,
    this.cost,
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
        price: json["price"],
        whoMadeIt: json["whoMadeIt"] == null
            ? null
            : BlousePadding.fromJson(json["whoMadeIt"]),
        shipment: Shipment.fromJson(json["shipment"]),
        available: json["available"],
        variations: json["variations"] == null
            ? null
            : List<Variation>.from(
                json["variations"].map((x) => Variation.fromJson(x))),
        typeOfWork: json["typeOfWork"] == null ? null : json["typeOfWork"],
        fabricDetails:
            json["fabricDetails"] == null ? null : json["fabricDetails"],
        margin: json["margin"] == null ? null : json["margin"],
        productFor: json["productFor"] == null
            ? null
            : BlousePadding.fromJson(json["productFor"]),
        category: json["category"] == null
            ? null
            : BlousePadding.fromJson(json["category"]),
        hangings: json["hangings"] == null ? null : json["hangings"],
        breath: json["breath"] == null ? null : json["breath"],
        length: json["length"] == null ? null : json["length"],
        style: json["style"] == null ? null : json["style"],
        dimensions: json["dimensions"] == null ? null : json["dimensions"],
        rating: Rating.fromJson(json["rating"]),
        photo:
            json["photo"] == null ? null : ProductPhoto.fromJson(json["photo"]),
        discount: json["discount"] == null ? null : json["discount"],
        productNew: json["new"],
        neckCut: json["neckCut"] == null ? null : json["neckCut"],
        backCut: json["backCut"] == null ? null : json["backCut"],
        blousePadding: json["blousePadding"] == null
            ? null
            : BlousePadding.fromJson(json["blousePadding"]),
        sleeveLength: json["sleeveLength"] == null
            ? null
            : BlousePadding.fromJson(json["sleeveLength"]),
        stitchingType: json["stitchingType"] == null
            ? null
            : BlousePadding.fromJson(json["stitchingType"]),
        workOn: json["workOn"] == null
            ? null
            : List<BlousePadding>.from(
                json["workOn"].map((x) => BlousePadding.fromJson(x))),
        topsLength: json["topsLength"] == null
            ? null
            : BlousePadding.fromJson(json["topsLength"]),
        pieces: json["pieces"] == null
            ? null
            : BlousePadding.fromJson(json["pieces"]),
        neck: json["neck"] == null ? null : json["neck"],
        waist: json["waist"] == null ? null : json["waist"],
        flair: json["flair"] == null ? null : json["flair"],
        canCan: json["canCan"] == null ? null : json["canCan"],
        made:
            json["made"] == null ? null : BlousePadding.fromJson(json["made"]),
        typeOfSaree: json["typeOfSaree"] == null ? null : json["typeOfSaree"],
        oldPrice: json["oldPrice"] == null ? null : json["oldPrice"],
        seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
        cost: json["cost"] == null ? null : Cost.fromJson(json["cost"]),
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
        "price": price,
        "whoMadeIt": whoMadeIt == null ? null : whoMadeIt.toJson(),
        "shipment": shipment.toJson(),
        "available": available,
        "variations": variations == null
            ? null
            : List<dynamic>.from(variations.map((x) => x.toJson())),
        "typeOfWork": typeOfWork == null ? null : typeOfWork,
        "fabricDetails": fabricDetails == null ? null : fabricDetails,
        "margin": margin == null ? null : margin,
        "productFor": productFor == null ? null : productFor.toJson(),
        "category": category == null ? null : category.toJson(),
        "hangings": hangings == null ? null : hangings,
        "breath": breath == null ? null : breath,
        "length": length == null ? null : length,
        "style": style == null ? null : style,
        "dimensions": dimensions == null ? null : dimensions,
        "rating": rating.toJson(),
        "photo": photo == null ? null : photo.toJson(),
        "discount": discount == null ? null : discount,
        "new": productNew,
        "neckCut": neckCut == null ? null : neckCut,
        "backCut": backCut == null ? null : backCut,
        "blousePadding": blousePadding == null ? null : blousePadding.toJson(),
        "sleeveLength": sleeveLength == null ? null : sleeveLength.toJson(),
        "stitchingType": stitchingType == null ? null : stitchingType.toJson(),
        "workOn": workOn == null
            ? null
            : List<dynamic>.from(workOn.map((x) => x.toJson())),
        "topsLength": topsLength == null ? null : topsLength.toJson(),
        "pieces": pieces == null ? null : pieces.toJson(),
        "neck": neck == null ? null : neck,
        "waist": waist == null ? null : waist,
        "flair": flair == null ? null : flair,
        "canCan": canCan == null ? null : canCan,
        "made": made == null ? null : made.toJson(),
        "typeOfSaree": typeOfSaree == null ? null : typeOfSaree,
        "oldPrice": oldPrice == null ? null : oldPrice,
        "seller": seller == null ? null : seller.toJson(),
        "cost": cost == null ? null : cost.toJson(),
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

class BlousePadding {
  num id;

  BlousePadding({
    this.id,
  });

  factory BlousePadding.fromJson(Map<String, dynamic> json) => BlousePadding(
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
        photos: List<PhotoElement>.from(
            json["photos"].map((x) => PhotoElement.fromJson(x))),
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

class Cost {
  final num cost;
  final num costToCustomer;
  final CostAndRate productDiscount;
  final CostAndRate convenienceCharges;
  final CostAndRate gstCharges;
  final String note;

  Cost({
    this.cost,
    this.convenienceCharges,
    this.costToCustomer,
    this.gstCharges,
    this.note,
    this.productDiscount,
  });

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        cost: json["cost"],
        costToCustomer: json["costToCustomer"],
        productDiscount: json["productDiscount"] == null
            ? null
            : CostAndRate.fromJson(json["productDiscount"]),
        convenienceCharges: json["convenienceCharges"] == null
            ? null
            : CostAndRate.fromJson(json["convenienceCharges"]),
        gstCharges: json["gstCharges"] == null
            ? null
            : CostAndRate.fromJson(json["gstCharges"]),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "costToCustomer": costToCustomer,
        "productDiscount": productDiscount?.toJson(),
        "convenienceCharges": convenienceCharges?.toJson(),
        "gstCharges": gstCharges?.toJson(),
        "note": note,
      };
}

class CostAndRate {
  final num cost;
  final num rate;

  CostAndRate({this.cost, this.rate});

  factory CostAndRate.fromJson(Map<String, dynamic> json) => CostAndRate(
        cost: json["cost"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "rate": rate,
      };
}
