import 'dart:convert';

Queue queueFromJson(String str) => Queue.fromJson(json.decode(str));

String queueToJson(Queue data) => json.encode(data.toJson());

class Queue {
    Queue({
        this.queueId,
        this.orderId,
        this.status,
        this.error,
        this.httpStatus,
    });

    String queueId;
    String orderId;
    String status;
    String error;
    String httpStatus;

    factory Queue.fromJson(Map<String, dynamic> json) => Queue(
        queueId: json["queueId"],
        orderId: json["orderId"],
        status: json["status"],
        error: json["error"],
        httpStatus: json["httpStatus"],
    );

    Map<String, dynamic> toJson() => {
        "queueId": queueId,
        "orderId": orderId,
        "status": status,
        "error": error,
        "httpStatus": httpStatus,
    };
}
