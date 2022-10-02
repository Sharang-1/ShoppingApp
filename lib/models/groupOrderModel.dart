class GroupOrderModel {
  String? productId;
  Variation? variation;
  OrderQueue? orderQueue;

  GroupOrderModel({this.productId, this.orderQueue, this.variation});

  factory GroupOrderModel.fromJson(Map<String, dynamic> json) => GroupOrderModel(
        orderQueue: json['orderQueue'],
        productId: json['productId'],
        variation: json['variation'],
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'orderQueue': orderQueue,
        'variation': variation,
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

class OrderQueue {
  String? clientQueueId;

  OrderQueue({this.clientQueueId});

  factory OrderQueue.fromJson(Map<String, dynamic> json) =>
      OrderQueue(clientQueueId: json['clientQueueId']);

  Map<String, dynamic> toJson() => {'clientQueueId': clientQueueId};
}

class CustomerDetails {
  
}


