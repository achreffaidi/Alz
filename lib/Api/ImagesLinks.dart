// To parse this JSON data, do
//
//     final imagesLinks = imagesLinksFromJson(jsonString);

import 'dart:convert';

ImagesLinks imagesLinksFromJson(String str) => ImagesLinks.fromJson(json.decode(str));

String imagesLinksToJson(ImagesLinks data) => json.encode(data.toJson());

class ImagesLinks {
  Links links;

  ImagesLinks({
    this.links,
  });

  factory ImagesLinks.fromJson(Map<String, dynamic> json) => ImagesLinks(
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links.toJson(),
  };
}

class Links {
  String link1;
  String link2;


  Links({
    this.link1,
    this.link2,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    link1: json["link1"],
    link2: json["link2"],
  );

  Map<String, dynamic> toJson() => {
    "link1": link1,
    "link2": link2,
  };
}
