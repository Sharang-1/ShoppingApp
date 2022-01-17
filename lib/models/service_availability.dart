import 'dart:convert';

ServiceAvailability appInfoFromJson(String str) =>
    ServiceAvailability.fromJson(json.decode(str));

String appInfoToJson(ServiceAvailability data) => json.encode(data.toJson());

class ServiceAvailability {
  ServiceAvailability({
    this.pincode,
    this.serviceAvailable,
    this.message,
  });

  String? pincode;
  bool? serviceAvailable;
  String? message;

  factory ServiceAvailability.fromJson(Map<String, dynamic> json) =>
      ServiceAvailability(
        pincode: json["pincode"],
        serviceAvailable: json["serviceAvailable"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "pincode": pincode,
        "serviceAvailable": serviceAvailable,
        "message": message,
      };
}
