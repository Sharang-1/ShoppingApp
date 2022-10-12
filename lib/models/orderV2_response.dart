class GroupOrderResponseModel {
  GroupOrderResponseModel({
    required this.requestedOrders,
    required this.groupQueueId,
  });

  List<RequestedOrders> requestedOrders;
  String groupQueueId;

  factory GroupOrderResponseModel.fromJson(Map<String, dynamic> json) => GroupOrderResponseModel(
        requestedOrders: List<RequestedOrders>.from(
            json["requestedOrders"].map((x) => RequestedOrders.fromJson(x))),
        groupQueueId: json["groupQueueId"],
      );

  Map<String, dynamic> toJson() => {
        "requestedOrders": List<dynamic>.from(requestedOrders.map((x) => x.toJson())),
        "groupQueueId": groupQueueId,
      };
}

class RequestedOrders {
  String? queueId;
  String? clientQueueId;
  String? status;
  // String? orderId;
  // String? httpStatus;
  // String? error;
  // String? field;

  RequestedOrders({
    this.clientQueueId,
    // this.error,
    // this.field,
    // this.httpStatus,
    // this.orderId,
    this.queueId,
    this.status,
  });

  RequestedOrders.fromJson(Map<String, dynamic> json) {
    queueId = json['queueId'];
    clientQueueId = json['clientQueueId'];
    status = json['status'];
    // orderId = json['orderId'];
    // httpStatus = json['httpStatus'];
    // error = json['error'];
    // field = json['field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['queueId'] = this.queueId;
    data['clientQueueId'] = this.clientQueueId;
    data['status'] = this.status;
    // data['orderId'] = this.orderId;
    // data['httpStatus'] = this.httpStatus;
    // data['error'] = this.error;
    // data['field'] = this.field;

    return data;
  }
}

// {
//   "requestedOrders": [
//     {
//       "queueId": "string",
//       "clientQueueId": "string",
//       "orderId": "string",
//       "status": "QUEUE",
//       "httpStatus": "100 CONTINUE",
//       "error": "string",
//       "field": "string"
//     }
//   ],
//   "groupQueueId": "string"
// }