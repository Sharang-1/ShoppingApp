// To parse this JSON data, do
//
//     final groupOrderResponseModel = groupOrderResponseModelFromJson(jsonString);

import 'dart:convert';

GroupOrderResponseModel groupOrderResponseModelFromJson(String str) =>
    GroupOrderResponseModel.fromJson(json.decode(str));

String groupOrderResponseModelToJson(GroupOrderResponseModel data) => json.encode(data.toJson());

class GroupOrderResponseModel {
  GroupOrderResponseModel({
    this.groupQueueId,
    this.requestedOrders,
    this.status,
  });

  String? groupQueueId;
  List<RequestedOrder>? requestedOrders;
  String? status;

  factory GroupOrderResponseModel.fromJson(Map<String, dynamic> json) => GroupOrderResponseModel(
        groupQueueId: json["groupQueueId"] == null ? null : json["groupQueueId"],
        requestedOrders: json["requestedOrders"] == null
            ? null
            : List<RequestedOrder>.from(
                json["requestedOrders"].map((x) => RequestedOrder.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "groupQueueId": groupQueueId == null ? null : groupQueueId,
        "requestedOrders": requestedOrders == null
            ? null
            : List<dynamic>.from(requestedOrders!.map((x) => x.toJson())),
        "status": status == null ? null : status,
      };
}

class RequestedOrder {
  RequestedOrder({
    this.queueId,
    this.orderId,
    this.status,
    this.httpStatus,
  });

  String? queueId;
  String? orderId;
  String? status;
  String? httpStatus;

  factory RequestedOrder.fromJson(Map<String, dynamic> json) => RequestedOrder(
        queueId: json["queueId"] == null ? null : json["queueId"],
        orderId: json["orderId"] == null ? null : json["orderId"],
        status: json["status"] == null ? null : json["status"],
        httpStatus: json["httpStatus"] == null ? null : json["httpStatus"],
      );

  Map<String, dynamic> toJson() => {
        "queueId": queueId == null ? null : queueId,
        "orderId": orderId == null ? null : orderId,
        "status": status == null ? null : status,
        "httpStatus": httpStatus == null ? null : httpStatus,
      };
}
