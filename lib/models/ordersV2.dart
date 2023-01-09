// To parse this JSON data, do
//
//     final ordersV2 = ordersV2FromJson(jsonString);

import 'dart:convert';

OrdersV2 ordersV2FromJson(String str) => OrdersV2.fromJson(json.decode(str));

String ordersV2ToJson(OrdersV2 data) => json.encode(data.toJson());

class OrdersV2 {
  OrdersV2({
    this.records,
    this.startIndex,
    this.limit,
    this.orders,
  });

  int? records;
  int? startIndex;
  int? limit;
  List<Order>? orders;

  factory OrdersV2.fromJson(Map<String, dynamic> json) => OrdersV2(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.key,
    this.enabled,
    this.created,
    this.modified,
    this.version,
    this.itemCost,
    this.sellerId,
    this.productId,
    this.shipment,
    this.variation,
    this.deliveryDate,
    this.queueId,
    this.singleItem,
    this.groupId,
    this.status,
    this.statusFlow,
    this.commonField,
  });

  String? key;
  bool? enabled;
  String? created;
  String? modified;
  String? version;
  ItemCost? itemCost;
  String? sellerId;
  String? productId;
  Shipment? shipment;
  Variation? variation;
  String? deliveryDate;
  String? queueId;
  bool? singleItem;
  String? groupId;
  Status? status;
  Status? statusFlow;
  CommonField? commonField;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        key: json["key"] == null ? null : json["key"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        version: json["version"] == null ? null : json["version"],
        itemCost: json["itemCost"] == null ? null : ItemCost.fromJson(json["itemCost"]),
        sellerId: json["sellerId"] == null ? null : json["sellerId"],
        productId: json["productId"] == null ? null : json["productId"],
        shipment: json["shipment"] == null ? null : Shipment.fromJson(json["shipment"]),
        variation: json["variation"] == null ? null : Variation.fromJson(json["variation"]),
        deliveryDate: json["deliveryDate"] == null ? null : json["deliveryDate"],
        queueId: json["queueId"] == null ? null : json["queueId"],
        singleItem: json["singleItem"] == null ? null : json["singleItem"],
        groupId: json["groupId"] == null ? null : json["groupId"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        statusFlow: json["statusFlow"] == null ? null : Status.fromJson(json["statusFlow"]),
        commonField: json["commonField"] == null ? null : CommonField.fromJson(json["commonField"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "enabled": enabled == null ? null : enabled,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "version": version == null ? null : version,
        "itemCost": itemCost == null ? null : itemCost?.toJson(),
        "sellerId": sellerId == null ? null : sellerId,
        "productId": productId == null ? null : productId,
        "shipment": shipment == null ? null : shipment?.toJson(),
        "variation": variation == null ? null : variation?.toJson(),
        "deliveryDate": deliveryDate == null ? null : deliveryDate,
        "queueId": queueId == null ? null : queueId,
        "singleItem": singleItem == null ? null : singleItem,
        "groupId": groupId == null ? null : groupId,
        "status": status == null ? null : status?.toJson(),
        "statusFlow": statusFlow == null ? null : statusFlow?.toJson(),
        "commonField": commonField == null ? null : commonField?.toJson(),
      };
}

class CommonField {
  CommonField({
    this.groupQueueId,
    this.payment,
    this.customerDetails,
    this.orderCost,
    this.groupOrderStatus,
  });

  String? groupQueueId;
  Payment? payment;
  CustomerDetails? customerDetails;
  OrderCost? orderCost;
  Status? groupOrderStatus;

  factory CommonField.fromJson(Map<String, dynamic> json) => CommonField(
        groupQueueId: json["groupQueueId"] == null ? null : json["groupQueueId"],
        payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        customerDetails: json["customerDetails"] == null
            ? null
            : CustomerDetails.fromJson(json["customerDetails"]),
        orderCost: json["orderCost"] == null ? null : OrderCost.fromJson(json["orderCost"]),
        groupOrderStatus:
            json["groupOrderStatus"] == null ? null : Status.fromJson(json["groupOrderStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "groupQueueId": groupQueueId == null ? null : groupQueueId,
        "payment": payment == null ? null : payment?.toJson(),
        "customerDetails": customerDetails == null ? null : customerDetails?.toJson(),
        "orderCost": orderCost == null ? null : orderCost?.toJson(),
        "groupOrderStatus": groupOrderStatus == null ? null : groupOrderStatus?.toJson(),
      };
}

class CustomerDetails {
  CustomerDetails({
    this.name,
    this.customerId,
    this.customerPhone,
    this.customerMeasure,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
  });

  String? name;
  String? customerId;
  Phone? customerPhone;
  CustomerMeasure? customerMeasure;
  Phone? phone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;

  factory CustomerDetails.fromJson(Map<String, dynamic> json) => CustomerDetails(
        name: json["name"],
        customerId: json["customerId"],
        customerPhone: Phone.fromJson(json["customerPhone"]),
        customerMeasure: CustomerMeasure.fromJson(json["customerMeasure"]),
        phone: Phone.fromJson(json["phone"]),
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "customerId": customerId,
        "customerPhone": customerPhone?.toJson(),
        "customerMeasure": customerMeasure?.toJson(),
        "phone": phone?.toJson(),
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
      };
}

class CustomerMeasure {
  CustomerMeasure({
    this.shoulders,
    this.chest,
    this.waist,
    this.hips,
    this.height,
    this.empty,
  });

  int? shoulders;
  int? chest;
  int? waist;
  int? hips;
  int? height;
  bool? empty;

  factory CustomerMeasure.fromJson(Map<String, dynamic> json) => CustomerMeasure(
        shoulders: json["shoulders"],
        chest: json["chest"],
        waist: json["waist"],
        hips: json["hips"],
        height: json["height"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "shoulders": shoulders,
        "chest": chest,
        "waist": waist,
        "hips": hips,
        "height": height,
        "empty": empty,
      };
}

class Phone {
  Phone({
    this.code,
    this.mobile,
    this.display,
  });

  String? code;
  String? mobile;
  String? display;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        code: json["code"],
        mobile: json["mobile"],
        display: json["display"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
        "display": display,
      };
}

class Status {
  Status({
    this.id,
    this.created,
    this.modified,
    this.ownerId,
    this.state,
    this.orderState,
    this.note,
    this.next,
  });

  int? id;
  String? created;
  String? modified;
  int? ownerId;
  String? state;
  String? orderState;
  String? note;
  Status? next;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"] == null ? null : json["id"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        state: json["state"] == null ? null : json["state"],
        orderState: json["orderState"] == null ? null : json["orderState"],
        note: json["note"] == null ? null : json["note"],
        next: json["next"] == null ? null : Status.fromJson(json["next"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "ownerId": ownerId == null ? null : ownerId,
        "state": state == null ? null : state,
        "orderState": orderState == null ? null : orderState,
        "note": note == null ? null : note,
        "next": next == null ? null : next?.toJson(),
      };
}

class OrderCost {
  OrderCost({
    this.convenienceCharges,
    this.cost,
    this.deliveryChargesList,
    this.codCharges,
    this.individualTotalOrderCost,
    this.note,
  });

  ProductDiscount? convenienceCharges;
  double? cost;
  List<DeliveryChargesList>? deliveryChargesList;
  CodCharges? codCharges;
  double? individualTotalOrderCost;
  String? note;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        convenienceCharges: json['convenienceCharges'] == null
            ? null
            : ProductDiscount.fromJson(json["convenienceCharges"]),
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
        deliveryChargesList: json["deliveryChargesList"] == null
            ? null
            : List<DeliveryChargesList>.from(
                json["deliveryChargesList"].map((x) => DeliveryChargesList.fromJson(x))),
        codCharges: json["codCharges"] == null ? null : CodCharges.fromJson(json["codCharges"]),
        individualTotalOrderCost: json["individualTotalOrderCost"] == null
            ? null
            : json["individualTotalOrderCost"].toDouble(),
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "convenienceCharges": convenienceCharges == null ? null : convenienceCharges?.toJson(),
        "cost": cost == null ? null : cost,
        "deliveryChargesList": deliveryChargesList == null
            ? null
            : List<dynamic>.from(deliveryChargesList!.map((x) => x.toJson())),
        "codCharges": codCharges == null ? null : codCharges?.toJson(),
        "individualTotalOrderCost":
            individualTotalOrderCost == null ? null : individualTotalOrderCost,
        "note": note == null ? null : note,
      };
}

class CodCharges {
  CodCharges({
    this.cost,
  });

  double? cost;

  factory CodCharges.fromJson(Map<String, dynamic> json) => CodCharges(
        cost: json["cost"] == null ? null : json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost == null ? null : cost,
      };
}

class ProductDiscount {
  ProductDiscount({
    this.rate,
    this.cost,
  });

  double? rate;
  double? cost;

  factory ProductDiscount.fromJson(Map<String, dynamic> json) => ProductDiscount(
        rate: json["rate"],
        cost: json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "cost": cost,
      };
}

class DeliveryChargesList {
  DeliveryChargesList({
    this.sellerId,
    this.cost,
  });

  String? sellerId;
  double? cost;

  factory DeliveryChargesList.fromJson(Map<String, dynamic> json) => DeliveryChargesList(
        sellerId: json["sellerId"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "sellerId": sellerId,
        "cost": cost,
      };
}

class Payment {
  Payment({
    this.option,
    this.online,
  });

  Option? option;
  bool? online;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        option: json["option"] == null ? null : Option.fromJson(json["option"]),
        online: json["online"] == null ? null : json["online"],
      );

  Map<String, dynamic> toJson() => {
        "option": option == null ? null : option?.toJson(),
        "online": online == null ? null : online,
      };
}

class Option {
  Option({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ItemCost {
  ItemCost({
    this.productPrice,
    this.quantity,
    this.productDiscount,
    this.gstCharges,
    this.cost,
    this.costForSeller,
    this.note,
  });

  double? productPrice;
  int? quantity;
  ProductDiscount? productDiscount;
  GstCharges? gstCharges;
  double? cost;
  double? costForSeller;
  String? note;

  factory ItemCost.fromJson(Map<String, dynamic> json) => ItemCost(
        productPrice: json["productPrice"] == null ? null : json["productPrice"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        productDiscount: json["productDiscount"] == null
            ? null
            : ProductDiscount.fromJson(json["productDiscount"]),
        gstCharges: json["gstCharges"] == null ? null : GstCharges.fromJson(json["gstCharges"]),
        cost: json["cost"] == null ? null : json["cost"],
        costForSeller: json["costForSeller"] == null ? null : json["costForSeller"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice == null ? null : productPrice,
        "quantity": quantity == null ? null : quantity,
        "productDiscount": productDiscount == null ? null : productDiscount?.toJson(),
        "gstCharges": gstCharges == null ? null : gstCharges?.toJson(),
        "cost": cost == null ? null : cost,
        "costForSeller": costForSeller == null ? null : costForSeller,
        "note": note == null ? null : note,
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

class Shipment {
  Shipment({
    this.days,
  });

  int? days;

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

  String? size;
  int? quantity;
  String? color;

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
