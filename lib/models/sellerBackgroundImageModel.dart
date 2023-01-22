class SellerBackImageModel {
  String? key;
  String? created;
  String? modified;
  List<Photos>? photos;
  String? accountId;

  SellerBackImageModel(
      {this.key, this.created, this.modified, this.photos, this.accountId});

  SellerBackImageModel.fromJson(Map<String, dynamic> json) {
    key = json["key"];
    created = json["created"];
    modified = json["modified"];
    photos = json["photos"] == null
        ? null
        : (json["photos"] as List).map((e) => Photos.fromJson(e)).toList();
    accountId = json["accountId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["key"] = key;
    _data["created"] = created;
    _data["modified"] = modified;
    if (photos != null) {
      _data["photos"] = photos?.map((e) => e.toJson()).toList();
    }
    _data["accountId"] = accountId;
    return _data;
  }
}

class Photos {
  String? name;
  String? originalName;
  String? created;

  Photos({this.name, this.originalName, this.created});

  Photos.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    originalName = json["originalName"];
    created = json["created"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["originalName"] = originalName;
    _data["created"] = created;
    return _data;
  }
}
