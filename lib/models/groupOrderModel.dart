class GroupOrderModel {
  String? productId;
  Variation? variation;
  String? clientQueueId;
  // OrderQueue? orderQueue;
  String? promocode;

  // GroupOrderModel({this.productId, this.orderQueue, this.variation, this.promocode});
  GroupOrderModel(
      {this.productId, this.variation, this.clientQueueId, this.promocode});

  factory GroupOrderModel.fromJson(Map<String, dynamic> json) =>
      GroupOrderModel(
        // orderQueue: json['orderQueue'],
        clientQueueId: json['clientQueueId'],
        productId: json['productId'],
        variation: json['variation'],
        promocode: json['promocode'],
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        // 'orderQueue': orderQueue,
        'clientQueueId': clientQueueId,
        'variation': variation,
        'promocode': promocode,
      };
}

class Variation {
  String? size;
  int? quantity;
  String? color;

  Variation({this.color, this.quantity, this.size});

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        color: json['color'],
        size: json['size'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'color': color,
        'size': size,
        'quantity': quantity,
      };
}

// class OrderQueue {
//   String? clientQueueId;

//   OrderQueue({this.clientQueueId});

//   factory OrderQueue.fromJson(Map<String, dynamic> json) =>
//       OrderQueue(clientQueueId: json['clientQueueId']);

//   Map<String, dynamic> toJson() => {'clientQueueId': clientQueueId};
// }

class GroupOrderCostEstimateModel {
  String? productId;
  int? quantity;
  String? promoCode;

  GroupOrderCostEstimateModel({this.productId, this.promoCode, this.quantity});

  factory GroupOrderCostEstimateModel.fromJson(Map<String, dynamic> json) =>
      GroupOrderCostEstimateModel(
        productId: json['productId'],
        promoCode: json['promocode'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
        'promocode': promoCode ?? null
      };
}
