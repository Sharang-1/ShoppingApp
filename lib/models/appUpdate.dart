// To parse this JSON data, do
//
//     final appUpdate = appUpdateFromJson(jsonString);

import 'dart:convert';

AppUpdate appUpdateFromJson(String str) => AppUpdate.fromJson(json.decode(str));

String appUpdateToJson(AppUpdate data) => json.encode(data.toJson());

class AppUpdate {
  AppUpdate({
    this.lastUpdate,
    this.version,
    this.priority,
    this.size,
    this.features,
    this.bugFixes,
  });

  String lastUpdate;
  String version;
  String priority;
  String size;
  String features;
  String bugFixes;

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
        lastUpdate: json["lastUpdate"],
        version: json["version"],
        priority: json["priority"],
        size: json["size"],
        features: json["features"],
        bugFixes: json["bugFixes"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdate": lastUpdate,
        "version": version,
        "priority": priority,
        "size": size,
        "features": features,
        "bugFixes": bugFixes,
      };
}
