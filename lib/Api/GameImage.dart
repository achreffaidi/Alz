// To parse this JSON data, do
//
//     final gameImage = gameImageFromJson(jsonString);

import 'dart:convert';

class GameImage {
  int totalHits;
  List<Hit> hits;
  int total;

  GameImage({
    this.totalHits,
    this.hits,
    this.total,
  });

  factory GameImage.fromJson(String str) => GameImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GameImage.fromMap(Map<String, dynamic> json) => GameImage(
    totalHits: json["totalHits"] == null ? null : json["totalHits"],
    hits: json["hits"] == null ? null : List<Hit>.from(json["hits"].map((x) => Hit.fromMap(x))),
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toMap() => {
    "totalHits": totalHits == null ? null : totalHits,
    "hits": hits == null ? null : List<dynamic>.from(hits.map((x) => x.toMap())),
    "total": total == null ? null : total,
  };
}

class Hit {
  String largeImageUrl;
  int webformatHeight;
  int webformatWidth;
  int likes;
  int imageWidth;
  int id;
  int userId;
  int views;
  int comments;
  String pageUrl;
  int imageHeight;
  String webformatUrl;
  String type;
  int previewHeight;
  String tags;
  int downloads;
  String user;
  int favorites;
  int imageSize;
  int previewWidth;
  String userImageUrl;
  String previewUrl;

  Hit({
    this.largeImageUrl,
    this.webformatHeight,
    this.webformatWidth,
    this.likes,
    this.imageWidth,
    this.id,
    this.userId,
    this.views,
    this.comments,
    this.pageUrl,
    this.imageHeight,
    this.webformatUrl,
    this.type,
    this.previewHeight,
    this.tags,
    this.downloads,
    this.user,
    this.favorites,
    this.imageSize,
    this.previewWidth,
    this.userImageUrl,
    this.previewUrl,
  });

  factory Hit.fromJson(String str) => Hit.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hit.fromMap(Map<String, dynamic> json) => Hit(
    largeImageUrl: json["largeImageURL"] == null ? null : json["largeImageURL"],
    webformatHeight: json["webformatHeight"] == null ? null : json["webformatHeight"],
    webformatWidth: json["webformatWidth"] == null ? null : json["webformatWidth"],
    likes: json["likes"] == null ? null : json["likes"],
    imageWidth: json["imageWidth"] == null ? null : json["imageWidth"],
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    views: json["views"] == null ? null : json["views"],
    comments: json["comments"] == null ? null : json["comments"],
    pageUrl: json["pageURL"] == null ? null : json["pageURL"],
    imageHeight: json["imageHeight"] == null ? null : json["imageHeight"],
    webformatUrl: json["webformatURL"] == null ? null : json["webformatURL"],
    type: json["type"] == null ? null : json["type"],
    previewHeight: json["previewHeight"] == null ? null : json["previewHeight"],
    tags: json["tags"] == null ? null : json["tags"],
    downloads: json["downloads"] == null ? null : json["downloads"],
    user: json["user"] == null ? null : json["user"],
    favorites: json["favorites"] == null ? null : json["favorites"],
    imageSize: json["imageSize"] == null ? null : json["imageSize"],
    previewWidth: json["previewWidth"] == null ? null : json["previewWidth"],
    userImageUrl: json["userImageURL"] == null ? null : json["userImageURL"],
    previewUrl: json["previewURL"] == null ? null : json["previewURL"],
  );

  Map<String, dynamic> toMap() => {
    "largeImageURL": largeImageUrl == null ? null : largeImageUrl,
    "webformatHeight": webformatHeight == null ? null : webformatHeight,
    "webformatWidth": webformatWidth == null ? null : webformatWidth,
    "likes": likes == null ? null : likes,
    "imageWidth": imageWidth == null ? null : imageWidth,
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "views": views == null ? null : views,
    "comments": comments == null ? null : comments,
    "pageURL": pageUrl == null ? null : pageUrl,
    "imageHeight": imageHeight == null ? null : imageHeight,
    "webformatURL": webformatUrl == null ? null : webformatUrl,
    "type": type == null ? null : type,
    "previewHeight": previewHeight == null ? null : previewHeight,
    "tags": tags == null ? null : tags,
    "downloads": downloads == null ? null : downloads,
    "user": user == null ? null : user,
    "favorites": favorites == null ? null : favorites,
    "imageSize": imageSize == null ? null : imageSize,
    "previewWidth": previewWidth == null ? null : previewWidth,
    "userImageURL": userImageUrl == null ? null : userImageUrl,
    "previewURL": previewUrl == null ? null : previewUrl,
  };
}
