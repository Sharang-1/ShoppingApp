class GroupOrderReponseModel {
  List<RequestedOrders>? requestedOrders;
  String? groupQueueid;

  GroupOrderReponseModel({
    this.groupQueueid,
    this.requestedOrders,
  });

  GroupOrderReponseModel.fromJson(Map<String, dynamic> json) {
    groupQueueid = json['groupQueueId'];
    requestedOrders = json['requestedOrders'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestedOrders'] = this.requestedOrders;
    data['groupQueueId'] = this.groupQueueid;
    return data;
  }
}

class RequestedOrders {
  String? queueId;
  String? clientQueueId;
  String? orderId;
  String? status;
  String? httpStatus;
  String? error;
  String? field;

  RequestedOrders({
    this.clientQueueId,
    this.error,
    this.field,
    this.httpStatus,
    this.orderId,
    this.queueId,
    this.status,
  });

  RequestedOrders.fromJson(Map<String, dynamic> json) {
    queueId = json['queueId'];
    clientQueueId = json['clientQueueId'];
    orderId = json['orderId'];
    status = json['status'];
    httpStatus = json['httpStatus'];
    error = json['error'];
    field = json['field'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['queueId'] = this.queueId;
    data['clientQueueId'] = this.clientQueueId;
    data['orderId'] = this.orderId;
    data['status'] = this.status;
    data['httpStatus'] = this.httpStatus;
    data['error'] = this.error;
    data['field'] = this.field;

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