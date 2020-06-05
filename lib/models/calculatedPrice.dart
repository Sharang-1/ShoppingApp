// To parse this JSON data, do
//
//     final calculatedPrice = calculatedPriceFromJson(jsonString);

import 'dart:convert';

CalculatedPrice calculatedPriceFromJson(String str) => CalculatedPrice.fromJson(json.decode(str));

String calculatedPriceToJson(CalculatedPrice data) => json.encode(data.toJson());

class CalculatedPrice {
    CalculatedPrice({
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
    double cost;
    num costToSeller;

    factory CalculatedPrice.fromJson(Map<String, dynamic> json) => CalculatedPrice(
        productId: json["productId"],
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        shippingCharge: json["shippingCharge"],
        cost: json["cost"].toDouble(),
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
