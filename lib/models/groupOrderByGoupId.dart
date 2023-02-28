// To parse this JSON data, do
//
//     final groupOrderByGroupId = groupOrderByGroupIdFromJson(jsonString);

import 'dart:convert';

GroupOrderByGroupId groupOrderByGroupIdFromJson(String str) =>
    GroupOrderByGroupId.fromJson(json.decode(str));

String groupOrderByGroupIdToJson(GroupOrderByGroupId data) =>
    json.encode(data.toJson());

class GroupOrderByGroupId {
  GroupOrderByGroupId({
    this.records,
    this.startIndex,
    this.limit,
    // this.orders,
    this.commonField,
    this.statusFlow,
    this.productId,
  });

  int? records;
  int? startIndex;
  int? limit;
  // List<Order>? orders;
  CommonField? commonField;
  Status? statusFlow;
  String? productId;

  factory GroupOrderByGroupId.fromJson(Map<String, dynamic> json) =>
      GroupOrderByGroupId(
        commonField: json["commonField"] == null
            ? null
            : CommonField.fromJson(json["commonField"]),
        records: json["records"] == null ? null : json["records"],
        startIndex: json["startIndex"] == null ? null : json["startIndex"],
        limit: json["limit"] == null ? null : json["limit"],
        statusFlow: json["statusFlow"] == null
            ? null
            : Status.fromJson(json["statusFlow"]),
        productId: json["product"] == null ? null : json["product"],
        // orders: json["orders"] == null
        //     ? null
        //     : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": records == null ? null : records,
        "startIndex": startIndex == null ? null : startIndex,
        "limit": limit == null ? null : limit,
        // "orders": orders == null
        //     ? null
        //     : List<dynamic>.from(orders!.map((x) => x.toJson())),
        "commonField": commonField == null ? null : commonField!.toJson(),
        "statusFlow": statusFlow == null ? null : statusFlow!.toJson(),
        "product": productId == null ? null : productId!,
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
  Status? statusFlow;
  Status? status;
  CommonField? commonField;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        key: json["key"] == null ? null : json["key"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        version: json["version"] == null ? null : json["version"],
        itemCost: json["itemCost"] == null
            ? null
            : ItemCost.fromJson(json["itemCost"]),
        sellerId: json["sellerId"] == null ? null : json["sellerId"],
        productId: json["productId"] == null ? null : json["productId"],
        shipment: json["shipment"] == null
            ? null
            : Shipment.fromJson(json["shipment"]),
        variation: json["variation"] == null
            ? null
            : Variation.fromJson(json["variation"]),
        deliveryDate:
            json["deliveryDate"] == null ? null : json["deliveryDate"],
        queueId: json["queueId"] == null ? null : json["queueId"],
        singleItem: json["singleItem"] == null ? null : json["singleItem"],
        groupId: json["groupId"] == null ? null : json["groupId"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        statusFlow: json["statusFlow"] == null
            ? null
            : Status.fromJson(json["statusFlow"]),
        commonField: json["commonField"] == null
            ? null
            : CommonField.fromJson(json["commonField"]),
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
        groupQueueId:
            json["groupQueueId"] == null ? null : json["groupQueueId"],
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        customerDetails: json["customerDetails"] == null
            ? null
            : CustomerDetails.fromJson(json["customerDetails"]),
        orderCost: json["orderCost"] == null
            ? null
            : OrderCost.fromJson(json["orderCost"]),
        groupOrderStatus: json["groupOrderStatus"] == null
            ? null
            : Status.fromJson(json["groupOrderStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "groupQueueId": groupQueueId == null ? null : groupQueueId,
        "payment": payment == null ? null : payment?.toJson(),
        "customerDetails":
            customerDetails == null ? null : customerDetails?.toJson(),
        "orderCost": orderCost == null ? null : orderCost?.toJson(),
        "groupOrderStatus":
            groupOrderStatus == null ? null : groupOrderStatus?.toJson(),
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
  int? pincode;

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        name: json["name"] == null ? null : json["name"],
        customerId: json["customerId"] == null ? null : json["customerId"],
        customerPhone: json["customerPhone"] == null
            ? null
            : Phone.fromJson(json["customerPhone"]),
        customerMeasure: json["customerMeasure"] == null
            ? null
            : CustomerMeasure.fromJson(json["customerMeasure"]),
        phone: json["phone"] == null ? null : Phone.fromJson(json["phone"]),
        address: json["address"] == null ? null : json["address"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
        pincode: json["pincode"] == null ? null : json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "customerId": customerId == null ? null : customerId,
        "customerPhone": customerPhone == null ? null : customerPhone?.toJson(),
        "customerMeasure":
            customerMeasure == null ? null : customerMeasure?.toJson(),
        "phone": phone == null ? null : phone?.toJson(),
        "address": address == null ? null : address,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
        "pincode": pincode == null ? null : pincode,
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

  factory CustomerMeasure.fromJson(Map<String, dynamic> json) =>
      CustomerMeasure(
        shoulders: json["shoulders"] == null ? null : json["shoulders"],
        chest: json["chest"] == null ? null : json["chest"],
        waist: json["waist"] == null ? null : json["waist"],
        hips: json["hips"] == null ? null : json["hips"],
        height: json["height"] == null ? null : json["height"],
        empty: json["empty"] == null ? null : json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "shoulders": shoulders == null ? null : shoulders,
        "chest": chest == null ? null : chest,
        "waist": waist == null ? null : waist,
        "hips": hips == null ? null : hips,
        "height": height == null ? null : height,
        "empty": empty == null ? null : empty,
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
        code: json["code"] == null ? null : json["code"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        display: json["display"] == null ? null : json["display"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "mobile": mobile == null ? null : mobile,
        "display": display == null ? null : display,
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
  });

  int? id;
  String? created;
  String? modified;
  int? ownerId;
  String? state;
  String? orderState;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"] == null ? null : json["id"],
        created: json["created"] == null ? null : json["created"],
        modified: json["modified"] == null ? null : json["modified"],
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        state: json["state"] == null ? null : json["state"],
        orderState: json["orderState"] == null ? null : json["orderState"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "created": created == null ? null : created,
        "modified": modified == null ? null : modified,
        "ownerId": ownerId == null ? null : ownerId,
        "state": state == null ? null : state,
        "orderState": orderState == null ? null : orderState,
      };
}

class OrderCost {
  OrderCost({
    this.convenienceCharges,
    this.cost,
    this.deliveryChargesList,
    this.individualTotalOrderCost,
    this.note,
  });

  ConvenienceCharges? convenienceCharges;
  double? cost;
  List<DeliveryChargesList>? deliveryChargesList;
  double? individualTotalOrderCost;
  String? note;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        convenienceCharges: json["convenienceCharges"] == null
            ? null
            : ConvenienceCharges.fromJson(json["convenienceCharges"]),
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
        deliveryChargesList: json["deliveryChargesList"] == null
            ? null
            : List<DeliveryChargesList>.from(json["deliveryChargesList"]
                .map((x) => DeliveryChargesList.fromJson(x))),
        individualTotalOrderCost: json["individualTotalOrderCost"] == null
            ? null
            : json["individualTotalOrderCost"],
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "convenienceCharges":
            convenienceCharges == null ? null : convenienceCharges?.toJson(),
        "cost": cost == null ? null : cost,
        "deliveryChargesList": deliveryChargesList == null
            ? null
            : List<dynamic>.from(deliveryChargesList!.map((x) => x.toJson())),
        "individualTotalOrderCost":
            individualTotalOrderCost == null ? null : individualTotalOrderCost,
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

  factory ConvenienceCharges.fromJson(Map<String, dynamic> json) =>
      ConvenienceCharges(
        rate: json["rate"] == null ? null : json["rate"],
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate == null ? null : rate,
        "cost": cost == null ? null : cost,
      };
}

class DeliveryChargesList {
  DeliveryChargesList({
    this.sellerId,
    this.cost,
  });

  String? sellerId;
  double? cost;

  factory DeliveryChargesList.fromJson(Map<String, dynamic> json) =>
      DeliveryChargesList(
        sellerId: json["sellerId"] == null ? null : json["sellerId"],
        cost: json["cost"] == null ? null : json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "sellerId": sellerId == null ? null : sellerId,
        "cost": cost == null ? null : cost,
      };
}

class Payment {
  Payment({
    this.option,
    this.receiptId,
    this.orderId,
    this.status,
    this.online,
  });

  Option? option;
  String? receiptId;
  String? orderId;
  String? status;
  bool? online;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        option: json["option"] == null ? null : Option.fromJson(json["option"]),
        receiptId: json["receiptId"] == null ? null : json["receiptId"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        status: json["status"] == null ? null : json["status"],
        online: json["online"] == null ? null : json["online"],
      );

  Map<String, dynamic> toJson() => {
        "option": option == null ? null : option?.toJson(),
        "receiptId": receiptId == null ? null : receiptId,
        "orderId": orderId == null ? null : orderId,
        "status": status == null ? null : status,
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
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };
}

class ItemCost {
  ItemCost({
    this.productPrice,
    this.quantity,
    this.gstCharges,
    this.cost,
    this.costForSeller,
    this.note,
  });

  int? quantity;
  double? productPrice;
  GstCharges? gstCharges;
  double? cost;
  double? costForSeller;
  String? note;

  factory ItemCost.fromJson(Map<String, dynamic> json) => ItemCost(
        productPrice: json["productPrice"] == null
            ? null
            : json["productPrice"].toDouble(),
        quantity: json["quantity"] == null ? null : json["quantity"],
        gstCharges: json["gstCharges"] == null
            ? null
            : GstCharges.fromJson(json["gstCharges"]),
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
        costForSeller: json["costForSeller"] == null
            ? null
            : json["costForSeller"].toDouble(),
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice == null ? null : productPrice,
        "quantity": quantity == null ? null : quantity,
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
        rate: json["rate"] == null ? null : json["rate"],
        cost: json["cost"] == null ? null : json["cost"],
        productPrice:
            json["productPrice"] == null ? null : json["productPrice"],
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
