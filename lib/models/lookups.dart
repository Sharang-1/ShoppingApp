import 'dart:convert';

List<Lookups> lookupsFromJson(String str) =>
    List<Lookups>.from(json.decode(str).map((x) => Lookups.fromJson(x)));

String lookupsToJson(List<Lookups> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lookups {
  Lookups({
    this.sectionName,
    this.sections,
  });

  String sectionName;
  List<Section> sections;

  factory Lookups.fromJson(Map<String, dynamic> json) => Lookups(
        sectionName: json["sectionName"],
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sectionName": sectionName,
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
      };
}

class Section {
  Section({
    this.option,
    this.values,
  });

  String option;
  List<Value> values;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        option: json["option"],
        values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "option": option,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
