// To parse this JSON data, do
//
//     final gameCategories = gameCategoriesFromJson(jsonString);

import 'dart:convert';

class GameCategories {
  List<CategoriesList> categoriesList;

  GameCategories({
    this.categoriesList,
  });

  factory GameCategories.fromJson(String str) => GameCategories.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GameCategories.fromMap(Map<String, dynamic> json) => GameCategories(
    categoriesList: json["categoriesList"] == null ? null : List<CategoriesList>.from(json["categoriesList"].map((x) => CategoriesList.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "categoriesList": categoriesList == null ? null : List<dynamic>.from(categoriesList.map((x) => x.toMap())),
  };
}

class CategoriesList {
  List<String> labels;
  String id;
  String chosen;
  String category;
  int v;

  CategoriesList({
    this.labels,
    this.id,
    this.chosen,
    this.category,
    this.v,
  });

  factory CategoriesList.fromJson(String str) => CategoriesList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriesList.fromMap(Map<String, dynamic> json) => CategoriesList(
    labels: json["labels"] == null ? null : List<String>.from(json["labels"].map((x) => x)),
    id: json["_id"] == null ? null : json["_id"],
    chosen: json["chosen"] == null ? null : json["chosen"],
    category: json["category"] == null ? null : json["category"],
    v: json["__v"] == null ? null : json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "labels": labels == null ? null : List<dynamic>.from(labels.map((x) => x)),
    "_id": id == null ? null : id,
    "chosen": chosen == null ? null : chosen,
    "category": category == null ? null : category,
    "__v": v == null ? null : v,
  };
}
