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
        this.payment,
        this.customerPhone,
        this.billingEmail,
        this.promotionId,
        this.promocode,
        this.promocodeId,
    });

    String key;
    bool enabled;
    String created;
    String modified;
    String customerId;
    String billingAddress;
    Phone billingPhone;
    String sellerId;
    String productId;
    Shipment shipment;
    Variation variation;
    OrderCost orderCost;
    Status status;
    String deliveryDate;
    Payment payment;
    Phone customerPhone;
    String billingEmail;
    String promotionId;
    String promocode;
    String promocodeId;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        key: json["key"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        customerId: json["customerId"],
        billingAddress: json["billingAddress"],
        billingPhone: Phone.fromJson(json["billingPhone"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        shipment: Shipment.fromJson(json["shipment"]),
        variation: Variation.fromJson(json["variation"]),
        orderCost: OrderCost.fromJson(json["orderCost"]),
        status: Status.fromJson(json["status"]),
        deliveryDate: json["deliveryDate"],
        payment: Payment.fromJson(json["payment"]),
        customerPhone: json["customerPhone"] == null ? null : Phone.fromJson(json["customerPhone"]),
        billingEmail: json["billingEmail"] == null ? null : json["billingEmail"],
        promotionId: json["promotionId"] == null ? null : json["promotionId"],
        promocode: json["promocode"] == null ? null : json["promocode"],
        promocodeId: json["promocodeId"] == null ? null : json["promocodeId"],
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
        "customerPhone": customerPhone == null ? null : customerPhone.toJson(),
        "billingEmail": billingEmail == null ? null : billingEmail,
        "promotionId": promotionId == null ? null : promotionId,
        "promocode": promocode == null ? null : promocode,
        "promocodeId": promocodeId == null ? null : promocodeId,
    };
}

class Phone {
    Phone({
        this.code,
        this.mobile,
    });

    String code;
    String mobile;

    factory Phone.fromJson(Map<String, dynamic> json) => Phone(
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
        this.promocodeId,
        this.promocode,
        this.promocodeDiscount,
        this.promocodeDiscountCost,
        this.promotionId,
        this.promotionDiscount,
        this.promotionDiscountCost,
    });

    String productId;
    num productPrice;
    num quantity;
    num shippingCharge;
    double cost;
    String promocodeId;
    String promocode;
    num promocodeDiscount;
    num promocodeDiscountCost;
    String promotionId;
    num promotionDiscount;
    double promotionDiscountCost;

    factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        productId: json["productId"],
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        shippingCharge: json["shippingCharge"],
        cost: json["cost"].toDouble(),
        promocodeId: json["promocodeId"] == null ? null : json["promocodeId"],
        promocode: json["promocode"] == null ? null : json["promocode"],
        promocodeDiscount: json["promocodeDiscount"] == null ? null : json["promocodeDiscount"],
        promocodeDiscountCost: json["promocodeDiscountCost"] == null ? null : json["promocodeDiscountCost"],
        promotionId: json["promotionId"] == null ? null : json["promotionId"],
        promotionDiscount: json["promotionDiscount"] == null ? null : json["promotionDiscount"],
        promotionDiscountCost: json["promotionDiscountCost"] == null ? null : json["promotionDiscountCost"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "productPrice": productPrice,
        "quantity": quantity,
        "shippingCharge": shippingCharge,
        "cost": cost,
        "promocodeId": promocodeId == null ? null : promocodeId,
        "promocode": promocode == null ? null : promocode,
        "promocodeDiscount": promocodeDiscount == null ? null : promocodeDiscount,
        "promocodeDiscountCost": promocodeDiscountCost == null ? null : promocodeDiscountCost,
        "promotionId": promotionId == null ? null : promotionId,
        "promotionDiscount": promotionDiscount == null ? null : promotionDiscount,
        "promotionDiscountCost": promotionDiscountCost == null ? null : promotionDiscountCost,
    };
}

class Payment {
    Payment({
        this.option,
        this.id,
    });

    Option option;
    num id;

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        option: Option.fromJson(json["option"]),
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "option": option.toJson(),
        "id": id == null ? null : id,
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
