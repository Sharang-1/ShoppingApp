// To parse this JSON data, do
//
//     final costEstimateModel = costEstimateModelFromJson(jsonString);

import 'dart:convert';

CostEstimateModel costEstimateModelFromJson(String str) =>
    CostEstimateModel.fromJson(json.decode(str));

String costEstimateModelToJson(CostEstimateModel data) => json.encode(data.toJson());

class CostEstimateModel {
  CostEstimateModel({
    this.convenienceCharges,
    this.cost,
    this.deliveryChargesList,
    this.individualTotalOrderCost,
    this.orderCosts,
    this.note,
  });

  ConvenienceCharges? convenienceCharges;
  double? cost;
  List<DeliveryChargesList>? deliveryChargesList;
  double? individualTotalOrderCost;
  List<OrderCost>? orderCosts;
  String? note;

  factory CostEstimateModel.fromJson(Map<String, dynamic> json) => CostEstimateModel(
        convenienceCharges: ConvenienceCharges.fromJson(json["convenienceCharges"]),
        cost: json["cost"].toDouble(),
        deliveryChargesList: List<DeliveryChargesList>.from(
            json["deliveryChargesList"].map((x) => DeliveryChargesList.fromJson(x))),
        individualTotalOrderCost: json["individualTotalOrderCost"].toDouble(),
        orderCosts: List<OrderCost>.from(json["orderCosts"].map((x) => OrderCost.fromJson(x))),
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "convenienceCharges": convenienceCharges?.toJson(),
        "cost": cost,
        "deliveryChargesList": List<dynamic>.from(deliveryChargesList!.map((x) => x.toJson())),
        "individualTotalOrderCost": individualTotalOrderCost,
        "orderCosts": List<dynamic>.from(orderCosts!.map((x) => x.toJson())),
        "note": note,
      };
}

class ConvenienceCharges {
  ConvenienceCharges({
    this.rate,
    this.cost,
  });

  double? rate;
  double? cost;

  factory ConvenienceCharges.fromJson(Map<String, dynamic> json) => ConvenienceCharges(
        rate: json["rate"].toDouble(),
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
        cost: json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "sellerId": sellerId,
        "cost": cost,
      };
}

class OrderCost {
  OrderCost({
    this.productPrice,
    this.quantity,
    this.gstCharges,
    this.cost,
    this.productId,
    this.note,
    this.productDiscount,
  });

  double? productPrice;
  int? quantity;
  GstCharges? gstCharges;
  double? cost;
  String? productId;
  String? note;
  ConvenienceCharges? productDiscount;

  factory OrderCost.fromJson(Map<String, dynamic> json) => OrderCost(
        productPrice: json["productPrice"].toDouble(),
        quantity: json["quantity"],
        gstCharges: GstCharges.fromJson(json["gstCharges"]),
        cost: json["cost"].toDouble(),
        productId: json["productId"],
        note: json["note"],
        productDiscount: json["productDiscount"] == null
            ? null
            : ConvenienceCharges.fromJson(json["productDiscount"]),
      );

  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "quantity": quantity,
        "gstCharges": gstCharges?.toJson(),
        "cost": cost,
        "productId": productId,
        "note": note,
        "productDiscount": productDiscount == null ? null : productDiscount?.toJson(),
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
        rate: json["rate"].toDouble(),
        cost: json["cost"].toDouble(),
        productPrice: json["productPrice"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "cost": cost,
        "productPrice": productPrice,
      };
}
