// To parse this JSON data, do
//
//     final newSellers = newSellersFromJson(jsonString);

import 'dart:convert';

import 'newSellers.dart';

NewProducts newSellersFromJson(String str) => NewProducts.fromJson(json.decode(str));

String newSellersToJson(NewProducts data) => json.encode(data.toJson());

class NewProducts {
  NewProducts({
    this.key,
    this.name,
    this.description,
    this.enabled,
    this.created,
    this.modified,
    this.account,
    this.owner,
    this.available,
    this.explore,
    this.margin,
    this.canCan,
    this.hangings,
    this.price,
    this.breadth,
    this.discount,
    this.flair,
    this.heelHeight,
    this.length,
    this.pricePerMeter,
    this.waist,
    this.fabricDetails,
    this.typeOfWork,
    this.art,
    this.backCut,
    this.bottomStyle,
    this.closureType,
    this.dimensions,
    this.fittingType,
    this.neck,
    this.neckCut,
    this.occasionToWearIn,
    this.riseStyle,
    this.typeOfSaree,
    this.washing,
    this.weaveType,
    this.variations,
    this.made,
    this.shipment,
    this.productFor,
    this.masterCategory,
    this.category,
    this.blousePadding,
    this.lengthOfKurta,
    this.pieces,
    this.sleeveLength,
    this.stitchingType,
    this.topsLength,
    this.whatDoesItHave,
    this.whoMadeIt,
    this.demographics,
    this.photo,
    this.video,
    this.rating,
    this.customization,
    this.newSeller,
    this.cost,
    this.newSellersNew,
  });

  String? key;
  String? name;
  String? description;
  bool? enabled;
  String? created;
  String? modified;
  Account? account;
  Account? owner;
  bool? available;
  bool? explore;
  bool? margin;
  bool? canCan;
  bool? hangings;
  int? price;
  int? breadth;
  int? discount;
  int? flair;
  int? heelHeight;
  int? length;
  int? pricePerMeter;
  int? waist;
  String? fabricDetails;
  String? typeOfWork;
  String? art;
  String? backCut;
  String? bottomStyle;
  String? closureType;
  String? dimensions;
  String? fittingType;
  String? neck;
  String? neckCut;
  String? occasionToWearIn;
  String? riseStyle;
  String? typeOfSaree;
  String? washing;
  String? weaveType;
  List<Variation>? variations;
  BlousePadding? made;
  Shipment? shipment;
  Category? productFor;
  Category? masterCategory;
  Category? category;
  BlousePadding? blousePadding;
  BlousePadding? lengthOfKurta;
  BlousePadding? pieces;
  BlousePadding? sleeveLength;
  BlousePadding? stitchingType;
  BlousePadding? topsLength;
  BlousePadding? whatDoesItHave;
  BlousePadding? whoMadeIt;
  List<dynamic>? demographics;
  NewProductsPhoto? photo;
  Video? video;
  Rating? rating;
  Customization? customization;
  NewSeller? newSeller;
  Cost? cost;
  bool? newSellersNew;

  factory NewProducts.fromJson(Map<String, dynamic> json) => NewProducts(
        key: json["key"] == null ? null : json["key"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        account: json["account"] == null ? null : Account.fromJson(json["account"]),
        owner: json["owner"] == null ? null : Account.fromJson(json["owner"]),
        available: json["available"] == null ? null : json["available"],
        explore: json["explore"] == null ? null : json["explore"],
        margin: json["margin"] == null ? null : json["margin"],
        canCan: json["canCan"] == null ? null : json["canCan"],
        hangings: json["hangings"] == null ? null : json["hangings"],
        price: json["price"] == null ? null : json["price"],
        breadth: json["breadth"] == null ? null : json["breadth"],
        discount: json["discount"] == null ? null : json["discount"],
        flair: json["flair"] == null ? null : json["flair"],
        heelHeight: json["heelHeight"] == null ? null : json["heelHeight"],
        length: json["length"] == null ? null : json["length"],
        pricePerMeter: json["pricePerMeter"] == null ? null : json["pricePerMeter"],
        waist: json["waist"] == null ? null : json["waist"],
        fabricDetails: json["fabricDetails"] == null ? null : json["fabricDetails"],
        typeOfWork: json["typeOfWork"] == null ? null : json["typeOfWork"],
        art: json["art"] == null ? null : json["art"],
        backCut: json["backCut"] == null ? null : json["backCut"],
        bottomStyle: json["bottomStyle"] == null ? null : json["bottomStyle"],
        closureType: json["closureType"] == null ? null : json["closureType"],
        dimensions: json["dimensions"] == null ? null : json["dimensions"],
        fittingType: json["fittingType"] == null ? null : json["fittingType"],
        neck: json["neck"] == null ? null : json["neck"],
        neckCut: json["neckCut"] == null ? null : json["neckCut"],
        occasionToWearIn: json["occasionToWearIn"] == null ? null : json["occasionToWearIn"],
        riseStyle: json["riseStyle"] == null ? null : json["riseStyle"],
        typeOfSaree: json["typeOfSaree"] == null ? null : json["typeOfSaree"],
        washing: json["washing"] == null ? null : json["washing"],
        weaveType: json["weaveType"] == null ? null : json["weaveType"],
        variations: json["variations"] == null
            ? null
            : List<Variation>.from(json["variations"]!.map((x) => Variation.fromJson(x))),
        made: json["made"] == null ? null : BlousePadding.fromJson(json["made"]),
        shipment: json["shipment"] == null ? null : Shipment.fromJson(json["shipment"]),
        productFor: json["productFor"] == null ? null : Category.fromJson(json["productFor"]),
        masterCategory:
            json["masterCategory"] == null ? null : Category.fromJson(json["masterCategory"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        blousePadding:
            json["blousePadding"] == null ? null : BlousePadding.fromJson(json["blousePadding"]),
        lengthOfKurta:
            json["lengthOfKurta"] == null ? null : BlousePadding.fromJson(json["lengthOfKurta"]),
        pieces: json["pieces"] == null ? null : BlousePadding.fromJson(json["pieces"]),
        sleeveLength:
            json["sleeveLength"] == null ? null : BlousePadding.fromJson(json["sleeveLength"]),
        stitchingType:
            json["stitchingType"] == null ? null : BlousePadding.fromJson(json["stitchingType"]),
        topsLength: json["topsLength"] == null ? null : BlousePadding.fromJson(json["topsLength"]),
        whatDoesItHave:
            json["whatDoesItHave"] == null ? null : BlousePadding.fromJson(json["whatDoesItHave"]),
        whoMadeIt: json["whoMadeIt"] == null ? null : BlousePadding.fromJson(json["whoMadeIt"]),
        demographics: json["demographics"] == null
            ? null
            : List<dynamic>.from(json["demographics"]!.map((x) => x)),
        photo: json["photo"] == null ? null : NewProductsPhoto.fromJson(json["photo"]),
        video: json["video"] == null ? null : Video.fromJson(json["video"]),
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
        customization:
            json["customization"] == null ? null : Customization.fromJson(json["customization"]),
        newSeller: json["newSeller"] == null ? null : NewSeller.fromJson(json["newSeller"]),
        cost: json["cost"] == null ? null : Cost.fromJson(json["cost"]),
        newSellersNew: json["new"] == null ? null : json["new"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "enabled": enabled == null ? null : enabled,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "account": account == null ? null : account?.toJson(),
        "owner": owner == null ? null : owner?.toJson(),
        "available": available == null ? null : available,
        "explore": explore == null ? null : explore,
        "margin": margin == null ? null : margin,
        "canCan": canCan == null ? null : canCan,
        "hangings": hangings == null ? null : hangings,
        "price": price == null ? null : price,
        "breadth": breadth == null ? null : breadth,
        "discount": discount == null ? null : discount,
        "flair": flair == null ? null : flair,
        "heelHeight": heelHeight == null ? null : heelHeight,
        "length": length == null ? null : length,
        "pricePerMeter": pricePerMeter == null ? null : pricePerMeter,
        "waist": waist == null ? null : waist,
        "fabricDetails": fabricDetails == null ? null : fabricDetails,
        "typeOfWork": typeOfWork == null ? null : typeOfWork,
        "art": art == null ? null : art,
        "backCut": backCut == null ? null : backCut,
        "bottomStyle": bottomStyle == null ? null : bottomStyle,
        "closureType": closureType == null ? null : closureType,
        "dimensions": dimensions == null ? null : dimensions,
        "fittingType": fittingType == null ? null : fittingType,
        "neck": neck == null ? null : neck,
        "neckCut": neckCut == null ? null : neckCut,
        "occasionToWearIn": occasionToWearIn == null ? null : occasionToWearIn,
        "riseStyle": riseStyle == null ? null : riseStyle,
        "typeOfSaree": typeOfSaree == null ? null : typeOfSaree,
        "washing": washing == null ? null : washing,
        "weaveType": weaveType == null ? null : weaveType,
        "variations":
            variations == null ? null : List<dynamic>.from(variations!.map((x) => x.toJson())),
        "made": made == null ? null : made?.toJson(),
        "shipment": shipment == null ? null : shipment?.toJson(),
        "productFor": productFor == null ? null : productFor?.toJson(),
        "masterCategory": masterCategory == null ? null : masterCategory?.toJson(),
        "category": category == null ? null : category?.toJson(),
        "blousePadding": blousePadding == null ? null : blousePadding?.toJson(),
        "lengthOfKurta": lengthOfKurta == null ? null : lengthOfKurta?.toJson(),
        "pieces": pieces == null ? null : pieces?.toJson(),
        "sleeveLength": sleeveLength == null ? null : sleeveLength?.toJson(),
        "stitchingType": stitchingType == null ? null : stitchingType?.toJson(),
        "topsLength": topsLength == null ? null : topsLength?.toJson(),
        "whatDoesItHave": whatDoesItHave == null ? null : whatDoesItHave?.toJson(),
        "whoMadeIt": whoMadeIt == null ? null : whoMadeIt?.toJson(),
        "demographics":
            demographics == null ? null : List<dynamic>.from(demographics!.map((x) => x)),
        "photo": photo == null ? null : photo?.toJson(),
        "video": video == null ? null : video?.toJson(),
        "rating": rating == null ? null : rating?.toJson(),
        "customization": customization == null ? null : customization?.toJson(),
        "newSeller": newSeller == null ? null : newSeller?.toJson(),
        "cost": cost == null ? null : cost?.toJson(),
        "new": newSellersNew == null ? null : newSellersNew,
      };
}

class Account {
  Account({
    this.key,
  });

  String? key;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        key: json["key"] == null ? null : json["key"],
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
      };
}

class BlousePadding {
  BlousePadding({
    this.id,
  });

  int? id;

  factory BlousePadding.fromJson(Map<String, dynamic> json) => BlousePadding(
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
      };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class Cost {
  Cost({
    this.cost,
    this.costToCustomer,
    this.convenienceCharges,
    this.gstCharges,
    this.note,
  });

  double? cost;
  double? costToCustomer;
  ConvenienceCharges? convenienceCharges;
  GstCharges? gstCharges;
  String? note;

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
        costToCustomer: json["costToCustomer"] == null ? null : json["costToCustomer"].toDouble(),
        convenienceCharges: json["convenienceCharges"] == null
            ? null
            : ConvenienceCharges.fromJson(json["convenienceCharges"]),
        gstCharges: json["gstCharges"] == null ? null : GstCharges.fromJson(json["gstCharges"]),
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost == null ? null : cost,
        "costToCustomer": costToCustomer == null ? null : costToCustomer,
        "convenienceCharges": convenienceCharges == null ? null : convenienceCharges?.toJson(),
        "gstCharges": gstCharges == null ? null : gstCharges?.toJson(),
        "note": note == null ? null : note,
      };
}

class ConvenienceCharges {
  ConvenienceCharges({
    this.rate,
    this.cost,
  });

  double? rate;
  double? cost;

  factory ConvenienceCharges.fromJson(Map<String, dynamic> json) => ConvenienceCharges(
        rate: json["rate"] == null ? null : json["rate"].toDouble(),
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate == null ? null : rate,
        "cost": cost == null ? null : cost,
      };
}

class GstCharges {
  GstCharges({
    this.rate,
    this.cost,
    this.productPrice,
  });

  double? rate;
  double? cost;
  double? productPrice;

  factory GstCharges.fromJson(Map<String, dynamic> json) => GstCharges(
        rate: json["rate"] == null ? null : json["rate"].toDouble(),
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
        productPrice: json["productPrice"] == null ? null : json["productPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate == null ? null : rate,
        "cost": cost == null ? null : cost,
        "productPrice": productPrice == null ? null : productPrice,
      };
}

class Customization {
  Customization();

  factory Customization.fromJson(Map<String, dynamic> json) => Customization();

  Map<String, dynamic> toJson() => {};
}




class Policy {
  Policy({
    this.supported,
    this.days,
    this.note,
  });

  bool? supported;
  int? days;
  String? note;

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        supported: json["supported"] == null ? null : json["supported"],
        days: json["days"] == null ? null : json["days"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "supported": supported == null ? null : supported,
        "days": days == null ? null : days,
        "note": note == null ? null : note,
      };
}

class NewProductsPhoto {
  NewProductsPhoto({
    this.photos,
  });

  List<PhotoElement>? photos;

  factory NewProductsPhoto.fromJson(Map<String, dynamic> json) => NewProductsPhoto(
        photos: json["photos"] == null
            ? null
            : List<PhotoElement>.from(json["photos"].map((x) => PhotoElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "photos": photos == null ? null : List<dynamic>.from(photos!.map((x) => x.toJson())),
      };
}

class PhotoElement {
  PhotoElement({
    this.name,
    this.originalName,
    this.created,
  });

  String? name;
  String? originalName;
  String? created;

  factory PhotoElement.fromJson(Map<String, dynamic> json) => PhotoElement(
        name: json["name"] == null ? null : json["name"],
        originalName: json["originalName"] == null ? null : json["originalName"],
        created: json["created"] == null ? null : json["created"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "originalName": originalName == null ? null : originalName,
        "created": created == null ? null : created,
      };
}

class Rating {
  Rating({
    this.rate,
  });

  int? rate;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"] == null ? null : json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate == null ? null : rate,
      };
}

class Shipment {
  Shipment({
    this.days,
  });

  int? days;

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        days: json["days"] == null ? null : json["days"],
      );

  Map<String, dynamic> toJson() => {
        "days": days == null ? null : days,
      };
}

class Variation {
  Variation({
    this.size,
    this.quantity,
    this.color,
  });

  String? size;
  int? quantity;
  String? color;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        size: json["size"] == null ? null : json["size"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toJson() => {
        "size": size == null ? null : size,
        "quantity": quantity == null ? null : quantity,
        "color": color == null ? null : color,
      };
}

class Video {
  Video({
    this.videos,
  });

  List<PhotoElement>? videos;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        videos: json["videos"] == null
            ? null
            : List<PhotoElement>.from(json["videos"].map((x) => PhotoElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "videos": videos == null ? null : List<dynamic>.from(videos!.map((x) => x.toJson())),
      };
}
