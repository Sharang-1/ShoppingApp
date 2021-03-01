import 'dart:convert';
import 'calculatedPrice.dart';

PromoCode promoCodeFromJson(String str) => PromoCode.fromJson(json.decode(str));

String promoCodeToJson(PromoCode data) => json.encode(data.toJson());

class PromoCode {
    PromoCode({
        this.productPrice,
        this.quantity,
        this.productDiscount,
        this.convenienceCharges,
        this.costForSeller,
        this.deliveryCharges,
        this.gstCharges,
        this.promocodeDiscount,
        this.note,
        this.cost,
    });

    final num productPrice;
    final num quantity;
    final CostAndRate productDiscount;
    final CostAndRate convenienceCharges;
    final CostAndRate gstCharges;
    final PromocodeDiscount promocodeDiscount;
    final Delivery deliveryCharges;
    final num costForSeller;
    final double cost;
    final String note;

    factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        productDiscount: CostAndRate.fromJson(json["productDiscount"]),
        convenienceCharges: CostAndRate.fromJson(json["convenienceCharges"]),
        gstCharges: CostAndRate.fromJson(json["gstCharges"]),
        promocodeDiscount: PromocodeDiscount.fromJson(json['promocodeDiscount']),
        deliveryCharges: Delivery.fromJson(json['deliveryCharges']),
        cost: json["cost"].toDouble(),
        costForSeller: json['costForSeller'],
        note: json['note'],
    );

    Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount.toJson(),
        "convenienceCharges": convenienceCharges.toJson(),
        "gstCharges": gstCharges.toJson(),
        "promocodeDiscount": promocodeDiscount.toJson(),
        "deliveryCharges": deliveryCharges.toJson(),
        "cost": cost,
        "costForSeller": costForSeller,
        "note": note,
    };
}

class PromocodeDiscount {
  PromocodeDiscount({
        this.cost,
        this.promocode,
        this.promocodeId
    });

   final String promocodeId;
   final String promocode;
   final num cost;

    factory PromocodeDiscount.fromJson(Map<String, dynamic> json) => PromocodeDiscount(
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
