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
  Priority priority;
  String size;
  String features;
  String bugFixes;

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
        lastUpdate: json["lastUpdate"],
        version: json["version"],
        priority: json["releasePriority"] == null
            ? null
            : Priority.fromJson(json["releasePriority"]),
        size: json["size"],
        features: json["features"],
        bugFixes: json["bugFixes"],
      );

  Map<String, dynamic> toJson() => {
        "lastUpdate": lastUpdate,
        "version": version,
        "releasePriority": priority.toJson(),
        "size": size,
        "features": features,
        "bugFixes": bugFixes,
      };
}

class Priority {
  Priority({
    this.priority,
    this.name,
  });

  int priority;
  String name;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        priority: json["priority"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "priority": priority,
        "name": name,
      };
}
