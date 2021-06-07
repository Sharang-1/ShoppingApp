import 'dart:convert';

List<Coupon> couponFromJson(String str) => List<Coupon>.from(json.decode(str).map((x) => Coupon.fromJson(x)));

String couponToJson(List<Coupon> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coupon {
    Coupon({
        this.key,
        this.name,
        this.enabled,
        this.created,
        this.modified,
        this.code,
        this.discount,
        this.customers,
        this.minimumOrderValue,
        this.validTill,
        this.used,
        this.lastUsed,
    });

    String key;
    String name;
    bool enabled;
    String created;
    String modified;
    String code;
    num discount;
    num customers;
    num minimumOrderValue;
    String validTill;
    num used;
    String lastUsed;

    factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        key: json["key"],
        name: json["name"],
        enabled: json["enabled"],
        created: json["created"],
        modified: json["modified"],
        code: json["code"],
        discount: json["discount"],
        customers: json["customers"],
        minimumOrderValue: json["minimumOrderValue"],
        validTill: json["validTill"],
        used: json["used"] == null ? null : json["used"],
        lastUsed: json["lastUsed"] == null ? null : json["lastUsed"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
        "enabled": enabled,
        "created": created,
        "modified": modified,
        "code": code,
        "discount": discount,
        "customers": customers,
        "minimumOrderValue": minimumOrderValue,
        "validTill": validTill,
        "used": used == null ? null : used,
        "lastUsed": lastUsed == null ? null : lastUsed,
    };
}
