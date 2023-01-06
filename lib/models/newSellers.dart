// class NewSeller {
//   NewSeller({
//     this.documentId,
//     this.key,
//     this.accountType,
//     this.name,
//     this.created,
//     this.modified,
//     this.approved,
//     this.enabled,
//     this.intro,
//     this.establishmentTypeId,
//     this.subscriptionTypeId,
//     this.photo,
//     this.contact,
//     this.owner,
//     this.replacementPolicy,
//     this.returnPolicy,
//     this.subscriptionType,
//     this.establishmentType,
//   });

//   String? documentId;
//   String? key;
//   String? accountType;
//   String? name;
//   String? created;
//   String? modified;
//   bool? approved;
//   bool? enabled;
//   String? intro;
//   int? establishmentTypeId;
//   int? subscriptionTypeId;
//   Photo? photo;
//   Contact? contact;
//   Owner? owner;
//   Policy? replacementPolicy;
//   Policy? returnPolicy;
//   Type? subscriptionType;
//   Type? establishmentType;

//   factory NewSeller.fromJson(Map<String, dynamic> json) => NewSeller(
//         documentId: json["documentId"] == null ? null : json["documentId"],
//         key: json["key"] == null ? null : json["key"],
//         accountType: json["accountType"] == null ? null : json["accountType"],
//         name: json["name"] == null ? null : json["name"],
//         created: json["created"] == null ? null : json["created"],
//         modified: json["modified"] == null ? null : json["modified"],
//         approved: json["approved"] == null ? null : json["approved"],
//         enabled: json["enabled"] == null ? null : json["enabled"],
//         intro: json["intro"] == null ? null : json["intro"],
//         establishmentTypeId:
//             json["establishmentTypeId"] == null ? null : json["establishmentTypeId"],
//         subscriptionTypeId: json["subscriptionTypeId"] == null ? null : json["subscriptionTypeId"],
//         photo: json["photo"] == null ? null : Photo.fromJson(json["photo"]),
//         contact: json["contact"] == null ? null : Contact.fromJson(json["contact"]),
//         owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
//         replacementPolicy:
//             json["replacementPolicy"] == null ? null : Policy.fromJson(json["replacementPolicy"]),
//         returnPolicy: json["returnPolicy"] == null ? null : Policy.fromJson(json["returnPolicy"]),
//         subscriptionType:
//             json["subscriptionType"] == null ? null : Type.fromJson(json["subscriptionType"]),
//         establishmentType:
//             json["establishmentType"] == null ? null : Type.fromJson(json["establishmentType"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "documentId": documentId == null ? null : documentId,
//         "key": key == null ? null : key,
//         "accountType": accountType == null ? null : accountType,
//         "name": name == null ? null : name,
//         "created": created == null ? null : created,
//         "modified": modified == null ? null : modified,
//         "approved": approved == null ? null : approved,
//         "enabled": enabled == null ? null : enabled,
//         "intro": intro == null ? null : intro,
//         "establishmentTypeId": establishmentTypeId == null ? null : establishmentTypeId,
//         "subscriptionTypeId": subscriptionTypeId == null ? null : subscriptionTypeId,
//         "photo": photo == null ? null : photo?.toJson(),
//         "contact": contact == null ? null : contact?.toJson(),
//         "owner": owner == null ? null : owner?.toJson(),
//         "replacementPolicy": replacementPolicy == null ? null : replacementPolicy?.toJson(),
//         "returnPolicy": returnPolicy == null ? null : returnPolicy?.toJson(),
//         "subscriptionType": subscriptionType == null ? null : subscriptionType?.toJson(),
//         "establishmentType": establishmentType == null ? null : establishmentType?.toJson(),
//       };
// }

// class Contact {
//   Contact({
//     this.address,
//     this.city,
//     this.state,
//     this.pincode,
//   });

//   String? address;
//   String? city;
//   String? state;
//   int? pincode;

//   factory Contact.fromJson(Map<String, dynamic> json) => Contact(
//         address: json["address"] == null ? null : json["address"],
//         city: json["city"] == null ? null : json["city"],
//         state: json["state"] == null ? null : json["state"],
//         pincode: json["pincode"] == null ? null : json["pincode"],
//       );

//   Map<String, dynamic> toJson() => {
//         "address": address == null ? null : address,
//         "city": city == null ? null : city,
//         "state": state == null ? null : state,
//         "pincode": pincode == null ? null : pincode,
//       };
// }

// class Type {
//   Type({
//     this.id,
//     this.name,
//   });

//   int? id;
//   String? name;

//   factory Type.fromJson(Map<String, dynamic> json) => Type(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//       };
// }

// class Owner {
//   Owner({
//     this.key,
//     this.name,
//   });

//   String? key;
//   String? name;

//   factory Owner.fromJson(Map<String, dynamic> json) => Owner(
//         key: json["key"] == null ? null : json["key"],
//         name: json["name"] == null ? null : json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "key": key == null ? null : key,
//         "name": name == null ? null : name,
//       };
// }

// class Photo {
//   Photo({
//     this.name,
//     this.originalName,
//     this.created,
//   });

//   String? name;
//   String? originalName;
//   String? created;

//   factory Photo.fromJson(Map<String, dynamic> json) => Photo(
//         name: json["name"] == null ? null : json["name"],
//         originalName: json["originalName"] == null ? null : json["originalName"],
//         created: json["created"] == null ? null : json["created"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name == null ? null : name,
//         "originalName": originalName == null ? null : originalName,
//         "created": created == null ? null : created,
//       };
// }

// class Policy {
//   Policy({
//     this.supported,
//     this.days,
//     this.note,
//   });

//   bool? supported;
//   int? days;
//   String? note;

//   factory Policy.fromJson(Map<String, dynamic> json) => Policy(
//         supported: json["supported"] == null ? null : json["supported"],
//         days: json["days"] == null ? null : json["days"],
//         note: json["note"] == null ? null : json["note"],
//       );

//   Map<String, dynamic> toJson() => {
//         "supported": supported == null ? null : supported,
//         "days": days == null ? null : days,
//         "note": note == null ? null : note,
//       };
// }
