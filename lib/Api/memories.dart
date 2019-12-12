// To parse this JSON data, do
//
//     final memories = memoriesFromJson(jsonString);

import 'dart:convert';

class Memories {
  List<Picture> pictures;

  Memories({
    this.pictures,
  });

  factory Memories.fromJson(String str) => Memories.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Memories.fromMap(Map<String, dynamic> json) => Memories(
    pictures: json["pictures"] == null ? null : List<Picture>.from(json["pictures"].map((x) => Picture.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "pictures": pictures == null ? null : List<dynamic>.from(pictures.map((x) => x.toMap())),
  };
}

class Picture {
  String pictureId;
  String pictureUrl;
  String title;
  String description;
  String date;

  Picture({
    this.pictureId,
    this.pictureUrl,
    this.title,
    this.description,
    this.date,
  });

  factory Picture.fromJson(String str) => Picture.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Picture.fromMap(Map<String, dynamic> json) => Picture(
    pictureId: json["pictureId"] == null ? null : json["pictureId"],
    pictureUrl: json["pictureUrl"] == null ? null : json["pictureUrl"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    date: json["date"] == null ? null : json["date"],
  );

  Map<String, dynamic> toMap() => {
    "pictureId": pictureId == null ? null : pictureId,
    "pictureUrl": pictureUrl == null ? null : pictureUrl,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "date": date == null ? null : date,
  };
}
