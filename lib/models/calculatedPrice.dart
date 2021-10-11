import 'dart:convert';

CalculatedPrice calculatedPriceFromJson(String str) =>
    CalculatedPrice.fromJson(json.decode(str));

String calculatedPriceToJson(CalculatedPrice data) =>
    json.encode(data.toJson());

class CalculatedPrice {
  CalculatedPrice({
    this.productPrice,
    this.quantity,
    this.convenienceCharges,
    this.cost,
    this.deliveryCharges,
    this.gstCharges,
    this.note,
    this.productDiscount,
  });

  num productPrice;
  num quantity;
  CostAndRate productDiscount;
  CostAndRate convenienceCharges;
  CostAndRate gstCharges;
  Delivery deliveryCharges;
  num cost;
  String note;

  factory CalculatedPrice.fromJson(Map<String, dynamic> json) =>
      CalculatedPrice(
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        productDiscount: json['productDiscount'] == null
            ? null
            : CostAndRate.fromJson(json['productDiscount']),
        convenienceCharges: json['convenienceCharges'] == null
            ? null
            : CostAndRate.fromJson(json['convenienceCharges']),
        gstCharges: json['gstCharges'] == null
            ? null
            : CostAndRate.fromJson(json['gstCharges']),
        deliveryCharges: json['deliveryCharges'] == null
            ? null
            : Delivery.fromJson(json['deliveryCharges']),
        cost: json['cost'],
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount,
        "convenienceCharges": convenienceCharges,
        "gstCharges": gstCharges,
        "deliveryCharges": deliveryCharges,
        "cost": cost,
        "note": note,
      };
}

class CostAndRate {
  final num cost;
  final num rate;

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

class Delivery {
  final num cost;
  final String note;

  Delivery({
    this.cost,
    this.note,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        cost: json["cost"],
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        "cost": cost.toString(),
        "note": note,
      };
}
