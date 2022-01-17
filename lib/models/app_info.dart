import 'dart:convert';

AppInfo appInfoFromJson(String str) => AppInfo.fromJson(json.decode(str));

String appInfoToJson(AppInfo data) => json.encode(data.toJson());

class AppInfo {
  AppInfo({
    this.lastUpdate,
    this.version,
    this.payment,
    this.pollWaitTime,
  });

  String? lastUpdate;
  String? version;
  Payment? payment;
  int? pollWaitTime;

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
        lastUpdate: json["lastUpdate"],
        version: json["version"],
        payment: Payment.fromJson(json["payment"]),
        pollWaitTime: json["pollWaitTime"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdate": lastUpdate,
        "version": version,
        "payment": payment?.toJson(),
        "pollWaitTime": pollWaitTime,
      };
}

class Payment {
  Payment({
    this.apiKey,
    this.merchantName,
    this.email,
  });

  String? apiKey;
  String? merchantName;
  String? email;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        apiKey: json["apiKey"],
        merchantName: json["merchantName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "apiKey": apiKey,
        "merchantName": merchantName,
        "email": email,
      };
}
