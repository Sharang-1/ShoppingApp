import 'dart:convert';

import 'calculatedPrice.dart';

PromoCode promoCodeFromJson(String str) => PromoCode.fromJson(json.decode(str));

String promoCodeToJson(PromoCode data) => json.encode(data.toJson());

class PromoCode {
  PromoCode({
    this.productPrice,
    this.quantity,
    this.convenienceCharges,
    this.costForSeller,
    this.deliveryCharges,
    this.gstCharges,
    this.promocodeDiscount,
    this.note,
    this.cost,
  });

  final num? productPrice;
  final num? quantity;
  final CostAndRate? convenienceCharges;
  final PromocodeDiscount? promocodeDiscount;
  final CostAndRate? gstCharges;
  final Delivery? deliveryCharges;
  final num? costForSeller;
  final num? cost;
  final String? note;

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    // if (json == null) return null;
    return PromoCode(
      productPrice: json["productPrice"],
      quantity: json["quantity"],
      convenienceCharges: (json["convenienceCharges"] == null)
          ? null
          : CostAndRate.fromJson(json["convenienceCharges"]),
      gstCharges: (json["gstCharges"] == null)
          ? null
          : CostAndRate.fromJson(json["gstCharges"]),
      promocodeDiscount: (json["promocodeDiscount"] == null)
          ? null
          : PromocodeDiscount.fromJson(json['promocodeDiscount']),
      deliveryCharges: (json["deliveryCharges"] == null)
          ? null
          : Delivery.fromJson(json['deliveryCharges']),
      cost: json["cost"],
      costForSeller: json['costForSeller'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "convenienceCharges": convenienceCharges?.toJson(),
        "gstCharges": gstCharges?.toJson(),
        "promocodeDiscount": promocodeDiscount?.toJson(),
        "deliveryCharges": deliveryCharges?.toJson(),
        "cost": cost,
        "costForSeller": costForSeller,
        "note": note,
      };
}

class PromocodeDiscount {
  PromocodeDiscount({this.cost, this.promocode, this.promocodeId});

  final String? promocodeId;
  final String? promocode;
  final num? cost;

  factory PromocodeDiscount.fromJson(Map<String, dynamic> json) =>
      PromocodeDiscount(
        promocodeId: json["promocodeId"],
        promocode: json['promocode'],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "promocodeId": promocodeId,
        "promocode": promocode,
        "cost": cost,
      };
}
