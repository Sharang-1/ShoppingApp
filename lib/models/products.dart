import 'dart:convert';

import 'coupon.dart';
import 'sellers.dart';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  num? records;
  num? startIndex;
  num? limit;
  List<Product>? items;

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
        "products": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Product {
  String? key;
  String? name;
  String? description;
  bool? enabled;
  String? created;
  String? modified;
  Account? account;
  Account? owner;
  num? price;
  BlousePadding? whoMadeIt;
  Shipment? shipment;
  bool? available;
  List<Variation>? variations;
  bool? explore;
  String? typeOfWork;
  String? fabricDetails;
  String? art;
  String? bottomStyle;
  String? closureType;
  String? fittingType;
  String? riseStyle;
  String? weaveType;
  bool? margin;
  BlousePadding? productFor;
  BlousePadding? category;
  BlousePadding? lengthOfKurta;
  bool? hangings;
  num? breadth;
  num? length;
  num? heelHeight;
  String? style;
  String? dimensions;
  Rating? rating;
  ProductPhoto? photo;
  num? discount;
  bool? productNew;
  String? neckCut;
  String? backCut;
  BlousePadding? blousePadding;
  BlousePadding? sleeveLength;
  BlousePadding? stitchingType;
  List<BlousePadding>? workOn;
  BlousePadding? topsLength;
  BlousePadding? pieces;
  BlousePadding? whatDoesItHave;
  String? neck;
  num? waist;
  num? flair;
  bool? canCan;
  BlousePadding? made;
  String? occasionToWearIn;
  String? typeOfSaree;
  String? washing;
  num? oldPrice;
  Seller? seller;
  Cost? cost;
  num? pricePerMeter;
  List<Coupon>? coupons;
  Video? video;
  List<dynamic>? demographics;

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
    this.explore,
    this.typeOfWork,
    this.fabricDetails,
    this.art,
    this.bottomStyle,
    this.closureType,
    this.fittingType,
    this.riseStyle,
    this.weaveType,
    this.margin,
    this.productFor,
    this.category,
    this.hangings,
    this.breadth,
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
    this.heelHeight,
    this.lengthOfKurta,
    this.occasionToWearIn,
    this.washing,
    this.pricePerMeter,
    this.whatDoesItHave,
    this.coupons,
    this.video,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      key: json["key"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] == null ? "" : json["description"],
      enabled: json["enabled"] ?? false,
      created: json["created"],
      modified: json["modified"],
      account: json["account"] == null
          ? null
          : Account.fromJson(json["account"]),
      owner: json["owner"] == null
          ? null
          : Account.fromJson(json["owner"]),
      price: json["price"] ?? 0,
      whoMadeIt: json["whoMadeIt"] == null
          ? null
          : BlousePadding.fromJson(json["whoMadeIt"]),
      shipment:
          json["shipment"] == null ? null : Shipment.fromJson(json["shipment"]),
      available: json["available"] ?? false,
      variations: json["variations"] == null
          ? []
          : List<Variation>.from(
              json["variations"].map((x) => Variation.fromJson(x))),
      explore: json["explore"] ?? false,
      typeOfWork: json["typeOfWork"] == null ? "" : json["typeOfWork"],
      fabricDetails: json["fabricDetails"] == null ? "" : json["fabricDetails"],
      art: json["art"] == null ? "" : json["art"],
      bottomStyle: json["bottomStyle"] == null ? "" : json["bottomStyle"],
      closureType: json["closureType"] == null ? "" : json["closureType"],
      fittingType: json["fittingType"] == null ? "" : json["fittingType"],
      riseStyle: json["riseStyle"] == null ? "" : json["riseStyle"],
      weaveType: json["weaveType"] == null ? "" : json["weaveType"],
      margin: json["margin"] == null ? false : json["margin"],
      productFor: json["productFor"] == null
          ? null
          : BlousePadding.fromJson(json["productFor"]),
      category: json["category"] == null
          ? null
          : BlousePadding.fromJson(json["category"]),
      whatDoesItHave: json["whatDoesItHave"] == null
          ? null
          : BlousePadding.fromJson(json["whatDoesItHave"]),
      hangings: json["hangings"] == null ? false : json["hangings"],
      breadth: json["breadth"] == null ? 0 : json["breadth"],
      heelHeight: json["heelHeight"] == null ? 0 : json["heelHeight"],
      lengthOfKurta: json["lengthOfKurta"] == null
          ? null
          : BlousePadding.fromJson(json["lengthOfKurta"]),
      occasionToWearIn:
          json["occasionToWearIn"] == null ? "" : json["occasionToWearIn"],
      washing: json["washing"] == null ? "" : json["washing"],
      length: json["length"] == null ? 0 : json["length"],
      style: json["style"] == null ? "" : json["style"],
      dimensions: json["dimensions"] == null ? "" : json["dimensions"],
      rating: Rating.fromJson(json["rating"]),
      photo:
          json["photo"] == null ? null : ProductPhoto.fromJson(json["photo"]),
      video: json["video"] == null ? null : Video.fromJson(json["video"]),
      discount: json["discount"] == null ? 0 : json["discount"],
      productNew: json["new"] ?? false,
      neckCut: json["neckCut"] == null ? "" : json["neckCut"],
      backCut: json["backCut"] == null ? "" : json["backCut"],
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
          ? []
          : List<BlousePadding>.from(
              json["workOn"].map((x) => BlousePadding.fromJson(x))),
      topsLength: json["topsLength"] == null
          ? null
          : BlousePadding.fromJson(json["topsLength"]),
      pieces: json["pieces"] == null
          ? null
          : BlousePadding.fromJson(json["pieces"]),
      neck: json["neck"] == null ? "" : json["neck"],
      waist: json["waist"] == null ? 0 : json["waist"],
      flair: json["flair"] == null ? 0 : json["flair"],
      canCan: json["canCan"] == null ? false : json["canCan"],
      made: json["made"] == null ? null : BlousePadding.fromJson(json["made"]),
      typeOfSaree: json["typeOfSaree"] == null ? "" : json["typeOfSaree"],
      oldPrice: json["oldPrice"] == null ? 0 : json["oldPrice"],
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      cost: json["cost"] == null ? null : Cost.fromJson(json["cost"]),
      pricePerMeter: json["pricePerMeter"] == null ? 0 : json["pricePerMeter"],
      coupons: json["promocodes"] == null
          ? []
          : List<Coupon>.from(
              json["promocodes"].map((x) => Coupon.fromJson(x)),
            ));

  Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "description": description == null ? null : description,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "account": account?.toJson(),
        "owner": owner?.toJson(),
        "price": price,
        "whoMadeIt": whoMadeIt == null ? null : whoMadeIt?.toJson(),
        "shipment": shipment?.toJson(),
        "available": available,
        "variations": variations == null
            ? null
            : List<dynamic>.from(variations!.map((x) => x.toJson())),
        "explore": explore,
        "typeOfWork": typeOfWork == null ? null : typeOfWork,
        "fabricDetails": fabricDetails == null ? null : fabricDetails,
        "art": art == null ? null : art,
        "bottomStyle": bottomStyle == null ? null : bottomStyle,
        "closureType": closureType == null ? null : closureType,
        "fittingType": fittingType == null ? null : fittingType,
        "riseStyle": riseStyle == null ? null : riseStyle,
        "weaveType": weaveType == null ? null : weaveType,
        "margin": margin == null ? null : margin,
        "productFor": productFor == null ? null : productFor?.toJson(),
        "category": category == null ? null : category?.toJson(),
        "whatDoesItHave":
            whatDoesItHave == null ? null : whatDoesItHave?.toJson(),
        "hangings": hangings == null ? null : hangings,
        "breadth": breadth == null ? null : breadth,
        "length": length == null ? null : length,
        "heelHeight": heelHeight == null ? null : heelHeight,
        "lengthOfKurta": lengthOfKurta == null ? null : lengthOfKurta?.toJson(),
        "occasionToWearIn": occasionToWearIn == null ? null : occasionToWearIn,
        "washing": washing == null ? null : washing,
        "style": style == null ? null : style,
        "dimensions": dimensions == null ? null : dimensions,
        "rating": rating?.toJson(),
        "photo": photo == null ? null : photo?.toJson(),
        "video": video == null ? null : video?.toJson(),
        "discount": discount == null ? null : discount,
        "new": productNew,
        "neckCut": neckCut == null ? null : neckCut,
        "backCut": backCut == null ? null : backCut,
        "blousePadding": blousePadding == null ? null : blousePadding?.toJson(),
        "sleeveLength": sleeveLength == null ? null : sleeveLength?.toJson(),
        "stitchingType": stitchingType == null ? null : stitchingType?.toJson(),
        "workOn": workOn == null
            ? null
            : List<dynamic>.from(workOn!.map((x) => x.toJson())),
        "topsLength": topsLength == null ? null : topsLength?.toJson(),
        "pieces": pieces == null ? null : pieces?.toJson(),
        "neck": neck == null ? null : neck,
        "waist": waist == null ? null : waist,
        "flair": flair == null ? null : flair,
        "canCan": canCan == null ? null : canCan,
        "made": made == null ? null : made?.toJson(),
        "typeOfSaree": typeOfSaree == null ? null : typeOfSaree,
        "oldPrice": oldPrice == null ? null : oldPrice,
        "seller": seller == null ? null : seller?.toJson(),
        "cost": cost == null ? null : cost?.toJson(),
        "coupons": coupons == null
            ? null
            : List<Coupon>.from(coupons!.map((x) => x.toJson())),
      };
}

class Account {
  String? key;

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
  num? id;
  String? name;

  BlousePadding({
    this.id,
    this.name,
  });

  factory BlousePadding.fromJson(Map<String, dynamic> json) => BlousePadding(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ProductPhoto {
  List<PhotoElement>? photos;
  String? accountId;
  String? productId;

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
        "photos": List<dynamic>.from(photos!.map((x) => x.toJson())),
        "accountId": accountId,
        "productId": productId,
      };
}

class PhotoElement {
  String? name;
  String? originalName;

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
  num? rate;

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
  num? days;

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
  String? size;
  num? quantity;
  String? color;

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
  final CostAndRate? productDiscount;
  final CostAndRate? convenienceCharges;
  final CostAndRate? gstCharges;
  final String? note;

  Cost({
    required this.cost,
    this.convenienceCharges,
    required this.costToCustomer,
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
  final num? cost;
  final num? rate;

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

class Video {
  final List<VideoElement> videos;

  const Video({required this.videos});

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videos: json["videos"] == null
            ? []
            : List<VideoElement>.from(
                json["videos"]?.map((x) => VideoElement.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
      };
}

class VideoElement {
  final String? name;
  final String? originalName;

  const VideoElement({this.name, this.originalName});

  factory VideoElement.fromJson(Map<String, dynamic> json) => VideoElement(
        name: json["name"],
        originalName: json["originalName"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "originalName": originalName,
      };
}
