import 'dart:convert';

Order2 orderFromJson(String str) => Order2.fromJson(json.decode(str));

String orderToJson(Order2 data) => json.encode(data.toJson());

// String orderv2ToJson(Orderv2 data) => json.encode(data.toJson());

class Order2 {
  Payment? payment;
  CustomerDetails? customerDetails;
  List<Orderv2>? orderv2;
  Order2({
    this.payment,
    this.customerDetails,
    this.orderv2,
  });

  factory Order2.fromJson(Map<String, dynamic> json) => Order2(
        payment: Payment.fromJson(json["payment"]),
        customerDetails: CustomerDetails.fromJson(json["customerDetail"]),
        orderv2: List<Orderv2>.from(json["orders"].map((x) => Orderv2.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment": payment?.toJson(),
        "customerDetails": customerDetails?.toJson(),
        "orders": List<Orderv2>.from(orderv2!.map((x) => x.toJson())),
      };
}

class CustomerDetails {
  // String? name;
  // String? customerId;
  CustomerPhone? customerPhone;
  // CustomerMeasure? customerMeasure;
  String? address;
  String? city;
  String? state;
  String? country;
  int? pincode;
  String? email;

  CustomerDetails({
    this.address,
    this.city,
    this.country,
    // this.customerId,
    // this.customerMeasure,
    this.customerPhone,
    this.email,
    // this.name,
    this.pincode,
    this.state,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) => CustomerDetails(
        // name: json["name"],
        // customerId: json["customerId"],
        address: json["address"],
        city: json["city"],
        country: json["country"],
        state: json["state"],
        pincode: json["pincode"],
        email: json["email"],
        // customerMeasure: CustomerMeasure.fromJson(json["customerMeasure"]),
        customerPhone: CustomerPhone.fromJson(json["customerPhone"]),
      );
  Map<String, dynamic> toJson() => {
        // "name": name,
        // "customerMeasure": customerMeasure?.toJson(),
        "customerPhone": customerPhone?.toJson(),
        "address": address,
        "city": city,
        "country": country,
        "state": state,
        "pincode": pincode,
        "email": email,
        // "customerId": customerId,
      };
}

class CustomerMeasure {
  int? shoulders;
  int? chest;
  int? waist;
  int? hips;
  int? height;
  bool? empty;

  CustomerMeasure({
    this.chest,
    this.empty,
    this.height,
    this.hips,
    this.shoulders,
    this.waist,
  });

  factory CustomerMeasure.fromJson(Map<String, dynamic> json) => CustomerMeasure(
        chest: json["chest"],
        height: json["height"],
        hips: json["hips"],
        shoulders: json["shoulder"],
        waist: json["waist"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "chest": chest,
        "height": height,
        "waist": waist,
        "shoulders": shoulders,
        "hips": hips,
        "empty": empty,
      };
}

class CustomerPhone {
  CustomerPhone({
    this.code,
    this.mobile,
  });

  String? code;
  String? mobile;

  factory CustomerPhone.fromJson(Map<String, dynamic> json) => CustomerPhone(
        code: json["code"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "mobile": mobile,
      };
}

class Payment {
  Payment({
    this.option,
    this.receiptId,
    this.orderId,
    this.orderStatus,
  });

  Option? option;
  String? receiptId;
  String? orderId;
  String? orderStatus;

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

  num? id;
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

class Orderv2 {
  Orderv2({
    this.key,
    this.id,
    this.uuid,
    this.name,
    this.description,
    this.enabled,
    this.created,
    this.modified,
    this.orderCost,
    this.sellerId,
    this.productId,
    this.quantity,
    this.shipment,
    this.variation,
    this.promotionId,
    this.promocode,
    this.deliveryDate,
    this.groupId,
    this.orderQueue,
    this.payment,
    this.customerDetails,
    this.customization,
    this.status,
    this.allowedStates,
  });

  String? key;
  String? id;
  String? uuid;
  String? name;
  String? description;
  bool? enabled;
  DateTime? created;
  DateTime? modified;
  OrderCost? orderCost;
  String? sellerId;
  String? productId;
  int? quantity;
  Shipment? shipment;
  Variation? variation;
  String? promotionId;
  String? promocode;
  DateTime? deliveryDate;
  String? groupId;
  OrderQueue? orderQueue;
  Payment? payment;
  CustomerDetails? customerDetails;
  OrderCustomization? customization;
  Status? status;
  List<String>? allowedStates;

  factory Orderv2.fromJson(Map<String, dynamic> json) => Orderv2(
        key: json["key"],
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        description: json["description"],
        enabled: json["enabled"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        orderCost: OrderCost.fromJson(json["orderCost"]),
        sellerId: json["sellerId"],
        productId: json["productId"],
        quantity: json["quantity"],
        shipment: Shipment.fromJson(json["shipment"]),
        variation: Variation.fromJson(json["variation"]),
        promotionId: json["promotionId"],
        promocode: json["promocode"],
        deliveryDate: DateTime.parse(json["deliveryDate"]),
        groupId: json["groupId"],
        orderQueue: OrderQueue.fromJson(json["orderQueue"]),
        payment: Payment.fromJson(json["payment"]),
        customerDetails: CustomerDetails.fromJson(json["customerDetails"]),
        customization: OrderCustomization.fromJson(json["customization"]),
        status: Status.fromJson(json["status"]),
        allowedStates: List<String>.from(json["allowedStates"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "id": id,
        "uuid": uuid,
        "name": name,
        "description": description,
        "enabled": enabled,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "orderCost": orderCost?.toJson(),
        "sellerId": sellerId,
        "productId": productId,
        "quantity": quantity,
        "shipment": shipment?.toJson(),
        "variation": variation?.toJson(),
        "promotionId": promotionId,
        "promocode": promocode,
        "deliveryDate": deliveryDate?.toIso8601String(),
        "groupId": groupId,
        "orderQueue": orderQueue?.toJson(),
        "payment": payment?.toJson(),
        "customerDetails": customerDetails?.toJson(),
        "customization": customization?.toJson(),
        "status": status?.toJson(),
        "allowedStates": List<dynamic>.from(allowedStates!.map((x) => x)),
      };
}

class OrderCustomization {
  OrderCustomization({
    this.label,
  });

  String? label;

  factory OrderCustomization.fromJson(Map<String, dynamic> json) => OrderCustomization(
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
      };
}

class OrderCost {
  OrderCost({
    this.productPrice,
    this.quantity,
    this.productDiscount,
    this.convenienceCharges,
    this.promocodeDiscount,
    this.promotionDiscount,
    this.gstCharges,
    this.deliveryCharges,
    this.cost,
    this.costForSeller,
    this.note,
  });

  int? productPrice;
  int? quantity;
  ConvenienceCharges? productDiscount;
  ConvenienceCharges? convenienceCharges;
  PromocodeDiscount? promocodeDiscount;
  PromotionDiscount? promotionDiscount;
  ConvenienceCharges? gstCharges;
  DeliveryCharges? deliveryCharges;
  int? cost;
  int? costForSeller;
  String? note;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        productDiscount: ConvenienceCharges.fromJson(json["productDiscount"]),
        convenienceCharges: ConvenienceCharges.fromJson(json["convenienceCharges"]),
        promocodeDiscount: PromocodeDiscount.fromJson(json["promocodeDiscount"]),
        promotionDiscount: PromotionDiscount.fromJson(json["promotionDiscount"]),
        gstCharges: ConvenienceCharges.fromJson(json["gstCharges"]),
        deliveryCharges: DeliveryCharges.fromJson(json["deliveryCharges"]),
        cost: json["cost"],
        costForSeller: json["costForSeller"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount?.toJson(),
        "convenienceCharges": convenienceCharges?.toJson(),
        "promocodeDiscount": promocodeDiscount?.toJson(),
        "promotionDiscount": promotionDiscount?.toJson(),
        "gstCharges": gstCharges?.toJson(),
        "deliveryCharges": deliveryCharges?.toJson(),
        "cost": cost,
        "costForSeller": costForSeller,
        "note": note,
      };
}

class ConvenienceCharges {
  ConvenienceCharges({
    this.cost,
    this.rate,
  });

  int? cost;
  int? rate;

  factory ConvenienceCharges.fromJson(Map<String, dynamic> json) => ConvenienceCharges(
        cost: json["cost"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "rate": rate,
      };
}

class DeliveryCharges {
  DeliveryCharges({
    this.key,
    this.id,
    this.uuid,
    this.name,
    this.description,
    this.enabled,
    this.created,
    this.modified,
    this.cost,
    this.note,
  });

  int? id;
  int? cost;
  String? key;
  String? uuid;
  String? name;
  String? description;
  String? note;
  DateTime? created;
  DateTime? modified;
  bool? enabled;

  factory DeliveryCharges.fromJson(Map<String, dynamic> json) => DeliveryCharges(
        key: json["key"],
        id: json["id"],
        uuid: json["uuid"],
        name: json["name"],
        description: json["description"],
        enabled: json["enabled"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        cost: json["cost"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "id": id,
        "uuid": uuid,
        "name": name,
        "description": description,
        "enabled": enabled,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "cost": cost,
        "note": note,
      };
}

class PromocodeDiscount {
  PromocodeDiscount({
    this.promocodeId,
    this.promocode,
    this.cost,
  });

  String? promocodeId;
  String? promocode;
  int? cost;

  factory PromocodeDiscount.fromJson(Map<String, dynamic> json) => PromocodeDiscount(
        promocodeId: json["promocodeId"],
        promocode: json["promocode"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "promocodeId": promocodeId,
        "promocode": promocode,
        "cost": cost,
      };
}

class PromotionDiscount {
  PromotionDiscount({
    this.promotionId,
    this.rate,
    this.cost,
  });

  String? promotionId;
  int? rate;
  int? cost;

  factory PromotionDiscount.fromJson(Map<String, dynamic> json) => PromotionDiscount(
        promotionId: json["promotionId"],
        rate: json["rate"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "rate": rate,
        "cost": cost,
      };
}

class OrderQueue {
  OrderQueue({
    this.groupQueueId,
    this.queueId,
    this.clientQueueId,
  });

  String? groupQueueId;
  String? queueId;
  String? clientQueueId;

  factory OrderQueue.fromJson(Map<String, dynamic> json) => OrderQueue(
        groupQueueId: json["groupQueueId"],
        queueId: json["queueId"],
        clientQueueId: json["clientQueueId"],
      );

  Map<String, dynamic> toJson() => {
        "groupQueueId": groupQueueId,
        "queueId": queueId,
        "clientQueueId": clientQueueId,
      };
}

class Timing {
  Timing({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  Day? sunday;
  Day? monday;
  Day? tuesday;
  Day? wednesday;
  Day? thursday;
  Day? friday;
  Day? saturday;

  factory Timing.fromJson(Map<String, dynamic> json) => Timing(
        sunday: Day.fromJson(json["sunday"]),
        monday: Day.fromJson(json["monday"]),
        tuesday: Day.fromJson(json["tuesday"]),
        wednesday: Day.fromJson(json["wednesday"]),
        thursday: Day.fromJson(json["thursday"]),
        friday: Day.fromJson(json["friday"]),
        saturday: Day.fromJson(json["saturday"]),
      );

  Map<String, dynamic> toJson() => {
        "sunday": sunday,
        "monday": monday,
        "tuesday": tuesday,
        "wednesday": wednesday,
        "thursday": thursday,
        "friday": friday,
        "saturday": saturday,
      };
}

class Day {
  Day({
    this.open,
    this.start,
    this.end,
  });

  bool? open;
  int? start;
  int? end;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        open: json["open"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "start": start,
        "end": end,
      };
}

class ProductCustomization {
  ProductCustomization({
    this.supported,
    this.maxSize,
  });

  bool? supported;
  int? maxSize;

  factory ProductCustomization.fromJson(Map<String, dynamic> json) => ProductCustomization(
        supported: json["supported"],
        maxSize: json["maxSize"],
      );

  Map<String, dynamic> toJson() => {
        "supported": supported,
        "maxSize": maxSize,
      };
}

class RatingAverage {
  RatingAverage({
    this.rating,
    this.total,
    this.person,
  });

  int? rating;
  int? total;
  int? person;

  factory RatingAverage.fromJson(Map<String, dynamic> json) => RatingAverage(
        rating: json["rating"],
        total: json["total"],
        person: json["person"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "total": total,
        "person": person,
      };
}

class Shipment {
  Shipment({
    this.name,
    this.fare,
    this.days,
  });

  String? name;
  int? fare;
  int? days;

  factory Shipment.fromJson(Map<String, dynamic> json) => Shipment(
        name: json["name"],
        fare: json["fare"],
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "fare": fare,
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

class Status {
  Status({
    this.id,
    this.note,
    this.created,
    this.modified,
    this.ownerId,
    this.next,
    this.returnPayment,
    this.orderState,
  });

  int? id;
  String? note;
  DateTime? created;
  DateTime? modified;
  int? ownerId;
  String? next;
  Payment? returnPayment;
  String? orderState;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        note: json["note"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        ownerId: json["ownerId"],
        next: json["next"],
        returnPayment: Payment.fromJson(json["returnPayment"]),
        orderState: json["orderState"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
        "ownerId": ownerId,
        "next": next,
        "returnPayment": returnPayment?.toJson(),
        "orderState": orderState,
      };
}
