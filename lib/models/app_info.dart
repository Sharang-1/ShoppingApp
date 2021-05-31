import 'dart:convert';

AppInfo appInfoFromJson(String str) => AppInfo.fromJson(json.decode(str));

String appInfoToJson(AppInfo data) => json.encode(data.toJson());

class AppInfo {
    AppInfo({
        this.lastUpdate,
        this.version,
        this.payment,
    });

    String lastUpdate;
    String version;
    Payment payment;

    factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
        lastUpdate: json["lastUpdate"],
        version: json["version"],
        payment: Payment.fromJson(json["payment"]),
    );

    Map<String, dynamic> toJson() => {
        "lastUpdate": lastUpdate,
        "version": version,
        "payment": payment.toJson(),
    };
}

class Payment {
    Payment({
        this.apiKey,
        this.merchantName,
    });

    String apiKey;
    String merchantName;

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        apiKey: json["apiKey"],
        merchantName: json["merchantName"],
    );

    Map<String, dynamic> toJson() => {
        "apiKey": apiKey,
        "merchantName": merchantName,
    };
}