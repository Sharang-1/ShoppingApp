import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

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
  Payment payment;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        key: json["key"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        customerId: json["customerId"],
        billingAddress: json["billingAddress"],
        billingPhone: BillingPhone.fromJson(json["billingPhone"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        shipment: Shipment.fromJson(json["shipment"]),
        variation: Variation.fromJson(json["variation"]),
        orderCost: OrderCost.fromJson(json["orderCost"]),
        status: Status.fromJson(json["status"]),
        deliveryDate: json["deliveryDate"],
        payment: Payment.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "customerId": customerId,
        "billingAddress": billingAddress,
        "billingPhone": billingPhone.toJson(),
        "sellerId": sellerId,
        "productId": productId,
        "shipment": shipment.toJson(),
        "variation": variation.toJson(),
        "orderCost": orderCost.toJson(),
        "status": status.toJson(),
        "deliveryDate": deliveryDate,
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
    this.costToSeller,
  });

  String productId;
  num productPrice;
  num quantity;
  num shippingCharge;
  num cost;
  num costToSeller;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        productId: json["productId"],
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        shippingCharge: json["shippingCharge"],
        cost: json["cost"],
        costToSeller: json["costToSeller"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productPrice": productPrice,
        "quantity": quantity,
        "shippingCharge": shippingCharge,
        "cost": cost,
        "costToSeller": costToSeller,
      };
}

class Payment {
  Payment({
    this.option,
    this.receiptId,
    this.orderId,
    this.orderStatus,
  });

  Option option;
  String receiptId;
  String orderId;
  String orderStatus;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        option: json["option"] != null ? Option.fromJson(json["option"]) : null,
        receiptId: json["receiptId"],
        orderId: json["orderId"],
        orderStatus: json["orderStatus"],
      );

  Map<String, dynamic> toJson() => {
        "option": option?.toJson(),
        "receiptId": receiptId,
        "orderId": orderId,
        "orderStatus": orderStatus,
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

class Status {
  Status({
    this.id,
    this.state,
  });

  num id;
  String state;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
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
