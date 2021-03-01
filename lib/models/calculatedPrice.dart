// To parse this JSON data, do
//
//     final calculatedPrice = calculatedPriceFromJson(jsonString);

import 'dart:convert';

CalculatedPrice calculatedPriceFromJson(String str) => CalculatedPrice.fromJson(json.decode(str));

String calculatedPriceToJson(CalculatedPrice data) => json.encode(data.toJson());

class CalculatedPrice {
    CalculatedPrice({
        // this.productId,
        this.productPrice,
        this.quantity,
        this.convenienceCharges,
        this.cost,
        this.costToSeller,
        this.deliveryCharges,
        this.gstCharges,
        this.note,
        this.productDiscount,
    });

    // String productId;
    num productPrice;
    num quantity;
    num costToSeller;
    CostAndRate productDiscount;
    CostAndRate convenienceCharges;
    CostAndRate gstCharges;
    Delivery deliveryCharges;
    num cost;
    String note;

    factory CalculatedPrice.fromJson(Map<String, dynamic> json) => CalculatedPrice(
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        productDiscount: json['productDiscount'] == null ? null : CostAndRate.fromJson(json['productDiscount']),
        convenienceCharges: json['convenienceCharges'] == null ? null : CostAndRate.fromJson(json['convenienceCharges']),
        gstCharges: json['gstCharges'] == null ? null : CostAndRate.fromJson(json['gstCharges']),
        deliveryCharges: json['deliveryCharges'] == null ? null : Delivery.fromJson(json['deliveryCharges']),
        cost: json['cost'],
        costToSeller:json["costForSeller"],
        note: json['note']
    );

    Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount,
        "convenienceCharges": convenienceCharges,
        "gstCharges": gstCharges,
        "deliveryCharges": deliveryCharges,
        "cost": cost,
        "costToSeller": costToSeller,
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
  final num id;
  final String name;
  final num days;
  final num cost;
  final num rate;
  final String note;

  Delivery({
    this.cost,
    this.days,
    this.id,
    this.name,
    this.note,
    this.rate,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json['id'],
        name: json['name'],
        days: json['days'],
        cost: json["cost"],
        rate: json["rate"],
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "days": days.toString(),
        "cost": cost.toString(),
        "rate": rate.toString(),
        "note": note,
      };
}
