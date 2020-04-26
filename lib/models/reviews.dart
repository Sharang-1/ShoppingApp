// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
    int records;
    int startIndex;
    int limit;
    List<Review> items;
    RatingAverage ratingAverage;

    Reviews({
        this.records,
        this.startIndex,
        this.limit,
        this.items,
        this.ratingAverage,
    });

    factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        records: json["records"],
        startIndex: json["startIndex"],
        limit: json["limit"],
        items: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        ratingAverage: RatingAverage.fromJson(json["ratingAverage"]),
    );

    Map<String, dynamic> toJson() => {
        "records": records,
        "startIndex": startIndex,
        "limit": limit,
        "reviews": List<dynamic>.from(items.map((x) => x.toJson())),
        "ratingAverage": ratingAverage.toJson(),
    };
}

class RatingAverage {
    int rating;
    int total;
    int person;

    RatingAverage({
        this.rating,
        this.total,
        this.person,
    });

    factory RatingAverage.fromJson(Map<String, dynamic> json) => RatingAverage(
        rating: json["rating"],
        total: json["total"],
        person: json["person"],
    );

    Map<String, dynamic> toJson() => {
        "rating": rating,
        "total": total,
        "person": person,
    };
}

class Review {
    String key;
    String description;
    String created;
    String modified;
    String userId;
    List<Reviewer> reviewer;
    String productId;
    int rating;

    Review({
        this.key,
        this.description,
        this.created,
        this.modified,
        this.userId,
        this.reviewer,
        this.productId,
        this.rating,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        key: json["key"],
        description: json["description"] == null ? null : json["description"],
        created: json["created"],
        modified: json["modified"],
        userId: json["userId"],
        reviewer: List<Reviewer>.from(json["reviewer"].map((x) => Reviewer.fromJson(x))),
        productId: json["productId"],
        rating: json["rating"] == null ? null : json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "description": description == null ? null : description,
        "created": created,
        "modified": modified,
        "userId": userId,
        "reviewer": List<dynamic>.from(reviewer.map((x) => x.toJson())),
        "productId": productId,
        "rating": rating == null ? null : rating,
    };
}

class Reviewer {
    Reviewer();

    factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
    );

    Map<String, dynamic> toJson() => {
    };
}
