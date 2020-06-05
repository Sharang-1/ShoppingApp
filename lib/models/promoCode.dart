import 'dart:convert';

PromoCode promoCodeFromJson(String str) => PromoCode.fromJson(json.decode(str));

String promoCodeToJson(PromoCode data) => json.encode(data.toJson());

class PromoCode {
    PromoCode({
        this.productId,
        this.productPrice,
        this.quantity,
        this.productDiscount,
        this.productDiscountCost,
        this.promocodeId,
        this.promocode,
        this.promocodeDiscount,
        this.promocodeDiscountCost,
        this.shippingCharge,
        this.cost,
    });

    String productId;
    num productPrice;
    num quantity;
    num productDiscount;
    num productDiscountCost;
    String promocodeId;
    String promocode;
    num promocodeDiscount;
    double promocodeDiscountCost;
    num shippingCharge;
    double cost;

    factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        productId: json["productId"],
        productPrice: json["productPrice"],
        quantity: json["quantity"],
        productDiscount: json["productDiscount"],
        productDiscountCost: json["productDiscountCost"],
        promocodeId: json["promocodeId"],
        promocode: json["promocode"],
        promocodeDiscount: json["promocodeDiscount"],
        promocodeDiscountCost: json["promocodeDiscountCost"].toDouble(),
        shippingCharge: json["shippingCharge"],
        cost: json["cost"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "productPrice": productPrice,
        "quantity": quantity,
        "productDiscount": productDiscount,
        "productDiscountCost": productDiscountCost,
        "promocodeId": promocodeId,
        "promocode": promocode,
        "promocodeDiscount": promocodeDiscount,
        "promocodeDiscountCost": promocodeDiscountCost,
        "shippingCharge": shippingCharge,
        "cost": cost,
    };
}
