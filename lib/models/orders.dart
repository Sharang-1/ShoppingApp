// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

import 'package:compound/models/calculatedPrice.dart' show Delivery;
import 'package:compound/models/products.dart';

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
    this.billingCity,
    this.billingState,
    this.billingPincode,
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
  String billingCity;
  String billingState;
  num billingPincode;
  BillingPhone billingPhone;
  String sellerId;
  String productId;
  Shipment shipment;
  Variation variation;
  OrderCost orderCost;
  Status status;
  String deliveryDate;
  Product product;
  Payment payment;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        key: json["key"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        customerId: json["customerId"],
        billingAddress:
            json["billingAddress"] == null ? null : json["billingAddress"],
        billingCity: json["billingCity"] == null ? null : json["billingCity"],
        billingState:
            json["billingState"] == null ? null : json["billingState"],
        billingPincode:
            json["billingPincode"] == null ? null : json["billingPincode"],
        billingPhone: json["billingPhone"] == null
            ? null
            : BillingPhone.fromJson(json["billingPhone"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        shipment: json["shipment"] == null
            ? null
            : Shipment.fromJson(json["shipment"]),
        variation: json["variation"] == null
            ? null
            : Variation.fromJson(json["variation"]),
        orderCost: json["orderCost"] == null
            ? null
            : OrderCost.fromJson(json["orderCost"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        deliveryDate: json["deliveryDate"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
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
        "shipment": shipment == null ? null : shipment.toJson(),
        "variation": variation == null ? null : variation.toJson(),
        "orderCost": orderCost == null ? null : orderCost.toJson(),
        "status": status == null ? null : status.toJson(),
        "deliveryDate": deliveryDate,
        "product": product == null ? null : product.toJson(),
        "payment": payment == null ? null : payment.toJson(),
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
  OrderCost(
      {this.productPrice,
      this.quantity,
      this.productDiscount,
      this.promocodeDiscount,
      this.convenienceCharges,
      this.gstCharges,
      this.deliveryCharges,
      this.cost,
      this.note});

  num productPrice;
  num quantity;
  CostAndRate productDiscount;
  CostAndRate promocodeDiscount;
  CostAndRate convenienceCharges;
  CostAndRate gstCharges;
  Delivery deliveryCharges;
  num cost;
  String note;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
      productPrice: json["productPrice"],
      quantity: json["quantity"],
      productDiscount: json['productDiscount'] == null
          ? null
          : CostAndRate.fromJson(json['productDiscount']),
      promocodeDiscount: json['promocodeDiscount'] == null
          ? null
          : CostAndRate.fromJson(json['promocodeDiscount']),
      convenienceCharges: json['convenienceCharges'] == null
          ? null
          : CostAndRate.fromJson(json['convenienceCharges']),
      gstCharges: json['gstCharges'] == null
          ? null
          : CostAndRate.fromJson(json['gstCharges']),
      deliveryCharges: json['deliveryCharges'] == null
          ? null
          : Delivery.fromJson(json['deliveryCharges']),
      cost: json["cost"] == null ? null : json["cost"],
      note: json['note'],
    );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount == null ? null : productDiscount.toJson(),
        "promocodeDiscount": promocodeDiscount == null ? null : promocodeDiscount.toJson(),
        "convenienceCharges": convenienceCharges == null ? null :  convenienceCharges.toJson(),
        "gstCharges": gstCharges == null ? null :  gstCharges.toJson(),
        "deliveryCharges": deliveryCharges == null ? null :  deliveryCharges.toJson(),
        "cost": cost,
        "note": note,
      };
}

class Payment {
  Payment({
    this.option,
  });

  Option option;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        option: json["option"] != null ? Option.fromJson(json["option"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "option": option?.toJson(),
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
