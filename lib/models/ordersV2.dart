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
        key: json["key"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        version: json["version"],
        itemCost: ItemCost.fromJson(json["itemCost"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        shipment: Shipment.fromJson(json["shipment"]),
        variation: Variation.fromJson(json["variation"]),
        deliveryDate: json["deliveryDate"],
        queueId: json["queueId"],
        singleItem: json["singleItem"],
        groupId: json["groupId"],
        status: Status.fromJson(json["status"]),
        statusFlow: Status.fromJson(json["statusFlow"]),
        commonField: CommonField.fromJson(json["commonField"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "version": version,
        "itemCost": itemCost?.toJson(),
        "sellerId": sellerId,
        "productId": productId,
        "shipment": shipment?.toJson(),
        "variation": variation?.toJson(),
        "deliveryDate": deliveryDate,
        "queueId": queueId,
        "singleItem": singleItem,
        "groupId": groupId,
        "status": status?.toJson(),
        "statusFlow": statusFlow?.toJson(),
        "commonField": commonField?.toJson(),
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
        groupQueueId: json["groupQueueId"],
        payment: Payment.fromJson(json["payment"]),
        customerDetails: CustomerDetails.fromJson(json["customerDetails"]),
        orderCost: OrderCost.fromJson(json["orderCost"]),
        groupOrderStatus: Status.fromJson(json["groupOrderStatus"]),
      );

  Map<String, dynamic> toJson() => {
        "groupQueueId": groupQueueId,
        "payment": payment?.toJson(),
        "customerDetails": customerDetails?.toJson(),
        "orderCost": orderCost?.toJson(),
        "groupOrderStatus": groupOrderStatus?.toJson(),
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
  });

  int? id;
  String? created;
  String? modified;
  int? ownerId;
  String? state;
  String? orderState;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        created: json["created"],
        modified: json["modified"],
        ownerId: json["ownerId"],
        state: json["state"],
        orderState: json["orderState"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created,
        "modified": modified,
        "ownerId": ownerId,
        "state": state,
        "orderState": orderState,
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
        convenienceCharges: ProductDiscount.fromJson(json["convenienceCharges"]),
        cost: json["cost"].toDouble(),
        deliveryChargesList: List<DeliveryChargesList>.from(
            json["deliveryChargesList"].map((x) => DeliveryChargesList.fromJson(x))),
        codCharges: CodCharges.fromJson(json["codCharges"]),
        individualTotalOrderCost: json["individualTotalOrderCost"].toDouble(),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "convenienceCharges": convenienceCharges?.toJson(),
        "cost": cost,
        "deliveryChargesList": List<dynamic>.from(deliveryChargesList!.map((x) => x.toJson())),
        "codCharges": codCharges?.toJson(),
        "individualTotalOrderCost": individualTotalOrderCost,
        "note": note,
      };
}

class CodCharges {
  CodCharges({
    this.cost,
  });

  double? cost;

  factory CodCharges.fromJson(Map<String, dynamic> json) => CodCharges(
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
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
        option: Option.fromJson(json["option"]),
        online: json["online"],
      );

  Map<String, dynamic> toJson() => {
        "option": option?.toJson(),
        "online": online,
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
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        productDiscount: ProductDiscount.fromJson(json["productDiscount"]),
        gstCharges: GstCharges.fromJson(json["gstCharges"]),
        cost: json["cost"],
        costForSeller: json["costForSeller"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount?.toJson(),
        "gstCharges": gstCharges?.toJson(),
        "cost": cost,
        "costForSeller": costForSeller,
        "note": note,
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
        rate: json["rate"],
        cost: json["cost"],
        productPrice: json["productPrice"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "cost": cost,
        "productPrice": productPrice,
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
