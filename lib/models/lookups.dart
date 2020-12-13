// To parse this JSON data, do
//
//     final lookups = lookupsFromJson(jsonString);

import 'dart:convert';

List<Lookups> lookupsFromJson(String str) => List<Lookups>.from(json.decode(str).map((x) => Lookups.fromJson(x)));

String lookupsToJson(List<Lookups> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lookups {
    Lookups({
        this.name,
        this.options,
    });

    String name;
    List<Lookup> options;

    factory Lookups.fromJson(Map<String, dynamic> json) => Lookups(
        name: json["name"],
        options: List<Lookup>.from(json["options"].map((x) => Lookup.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
    };
}

class Lookup {
    Lookup({
        this.id,
        this.name,
    });

    int id;
    String name;

    factory Lookup.fromJson(Map<String, dynamic> json) => Lookup(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
