// To parse this JSON data, do
//
//     final paymentOptions = paymentOptionFromJson(jsonString);

import 'dart:convert';

List<PaymentOption> paymentOptionsFromJson(String str) => List<PaymentOption>.from(json.decode(str).map((x) => PaymentOption.fromJson(x)));

String paymentOptionsToJson(List<PaymentOption> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentOption {
    PaymentOption({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
