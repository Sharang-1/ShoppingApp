// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

Orders ordersFromJson(String str) => Orders.fromJson(json.decode(str));

String ordersToJson(Orders data) => json.encode(data.toJson());

class Orders {
  Orders({
    this.records,
    this.startIndex,
    this.limit,
    this.orders,
  });

  num records;
  num startIndex;
  num limit;
  List<Order> orders;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.key,
    this.enabled,
    this.created,
    this.modified,
    this.customerId,
    this.billingAddress,
    this.billingPhone,
    this.sellerId,
    this.productId,
    this.shipment,
    this.variation,
    this.orderCost,
    this.status,
    this.deliveryDate,
    this.product,
    this.payment,
  });

  String key;
  bool enabled;
  String created;
  String modified;
  String customerId;
  String billingAddress;
  BillingPhone billingPhone;
  String sellerId;
  String productId;
  Shipment shipment;
  Variation variation;
  OrderCost orderCost;
  Status status;
  String deliveryDate;
  _Product product;
  Payment payment;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        key: json["key"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        customerId: json["customerId"],
        billingAddress:
            json["billingAddress"] == null ? null : json["billingAddress"],
        billingPhone: json["billingPhone"] == null
            ? null
            : BillingPhone.fromJson(json["billingPhone"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        shipment: Shipment.fromJson(json["shipment"]),
        variation: Variation.fromJson(json["variation"]),
        orderCost: OrderCost.fromJson(json["orderCost"]),
        status: Status.fromJson(json["status"]),
        deliveryDate: json["deliveryDate"],
        product: _Product.fromJson(json["product"]),
        payment: Payment.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "customerId": customerId,
        "billingAddress": billingAddress == null ? null : billingAddress,
        "billingPhone": billingPhone == null ? null : billingPhone.toJson(),
        "sellerId": sellerId,
        "productId": productId,
        "shipment": shipment.toJson(),
        "variation": variation.toJson(),
        "orderCost": orderCost.toJson(),
        "status": status.toJson(),
        "deliveryDate": deliveryDate,
        "product": product.toJson(),
        "payment": payment.toJson(),
      };
}

class BillingPhone {
  BillingPhone({
    this.code,
    this.mobile,
  });

  String code;
  String mobile;

  factory BillingPhone.fromJson(Map<String, dynamic> json) => BillingPhone(
        code: json["code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
      };
}

class OrderCost {
  OrderCost({
    this.productId,
    this.productPrice,
    this.quantity,
    this.shippingCharge,
    this.cost,
  });

  String productId;
  num productPrice;
  num quantity;
  num shippingCharge;
  num cost;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        productId: json["productId"],
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        shippingCharge: json["shippingCharge"],
        cost: json["cost"] == null ? null : json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productPrice": productPrice,
        "quantity": quantity,
        "shippingCharge": shippingCharge,
        "cost": cost == null ? null : cost,
      };
}

class Payment {
  Payment({
    this.option,
  });

  Option option;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        option: Option.fromJson(json["option"]),
      );

  Map<String, dynamic> toJson() => {
        "option": option.toJson(),
      };
}

class Option {
  Option({
    this.id,
    this.name,
  });

  num id;
  String name;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class _Product {
  _Product({
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
    this.waist,
    this.length,
    this.flair,
    this.blousePadding,
    this.pieces,
    this.rating,
    this.photo,
    this.discount,
    this.productNew,
  });

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
  num waist;
  num length;
  num flair;
  BlousePadding blousePadding;
  BlousePadding pieces;
  Rating rating;
  ProductPhoto photo;
  num discount;
  bool productNew;

  factory _Product.fromJson(Map<String, dynamic> json) => _Product(
        key: json["key"],
        name: json["name"],
        description: json["description"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        account: Account.fromJson(json["account"]),
        owner: Account.fromJson(json["owner"]),
        price: json["price"],
        whoMadeIt: BlousePadding.fromJson(json["whoMadeIt"]),
        shipment: Shipment.fromJson(json["shipment"]),
        available: json["available"],
        variations: List<Variation>.from(
            json["variations"].map((x) => Variation.fromJson(x))),
        typeOfWork: json["typeOfWork"],
        fabricDetails: json["fabricDetails"],
        margin: json["margin"],
        productFor: BlousePadding.fromJson(json["productFor"]),
        category: BlousePadding.fromJson(json["category"]),
        waist: json["waist"],
        length: json["length"],
        flair: json["flair"],
        blousePadding: BlousePadding.fromJson(json["blousePadding"]),
        pieces: BlousePadding.fromJson(json["pieces"]),
        rating: Rating.fromJson(json["rating"]),
        photo: ProductPhoto.fromJson(json["photo"]),
        discount: json["discount"],
        productNew: json["new"],
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
        "whoMadeIt": whoMadeIt.toJson(),
        "shipment": shipment.toJson(),
        "available": available,
        "variations": List<dynamic>.from(variations.map((x) => x.toJson())),
        "typeOfWork": typeOfWork,
        "fabricDetails": fabricDetails,
        "margin": margin,
        "productFor": productFor.toJson(),
        "category": category.toJson(),
        "waist": waist,
        "length": length,
        "flair": flair,
        "blousePadding": blousePadding.toJson(),
        "pieces": pieces.toJson(),
        "rating": rating.toJson(),
        "photo": photo.toJson(),
        "discount": discount,
        "new": productNew,
      };
}

class Account {
  Account({
    this.key,
  });

  String key;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
      };
}

class BlousePadding {
  BlousePadding({
    this.id,
  });

  num id;

  factory BlousePadding.fromJson(Map<String, dynamic> json) => BlousePadding(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class ProductPhoto {
  ProductPhoto({
    this.photos,
    this.accountId,
    this.productId,
  });

  List<PhotoElement> photos;
  String accountId;
  String productId;

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
  PhotoElement({
    this.name,
    this.originalName,
  });

  String name;
  String originalName;

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
  Rating({
    this.rate,
  });

  num rate;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
      };
}

class Shipment {
  Shipment({
    this.days,
  });

  num days;

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "days": days,
      };
}

class Variation {
  Variation({
    this.size,
    this.quantity,
    this.color,
  });

  String size;
  num quantity;
  String color;

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

class Status {
  Status({
    this.id,
    this.state,
    this.note,
  });

  num id;
  String state;
  String note;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        state: json["state"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
        "note": note == null ? null : note,
      };
}
