// To parse this JSON data, do
//
//     final tasksByDay = tasksByDayFromJson(jsonString);

import 'dart:convert';

TasksByDay tasksByDayFromJson(String str) => TasksByDay.fromMap(json.decode(str));

String tasksByDayToJson(TasksByDay data) => json.encode(data.toMap());

class TasksByDay {
  List<ListByDay> listByDay;

  TasksByDay({
    this.listByDay,
  });

  factory TasksByDay.fromMap(Map<String, dynamic> json) => TasksByDay(
    listByDay: List<ListByDay>.from(json["listByDay"].map((x) => ListByDay.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "listByDay": List<dynamic>.from(listByDay.map((x) => x.toMap())),
  };
}

class ListByDay {
  bool done;
  String imageUrl;
  String id;
  String title;
  String description;
  String time;
  String imageId;
  String voice;
  String voiceLink;
  String name;
  int day;
  int priority;
  String category;
  int v;

  ListByDay({
    this.done,
    this.imageUrl,
    this.id,
    this.title,
    this.description,
    this.time,
    this.imageId,
    this.voice,
    this.voiceLink,
    this.name,
    this.day,
    this.priority,
    this.category,
    this.v,
  });

  factory ListByDay.fromMap(Map<String, dynamic> json) => ListByDay(
    done: json["done"],
    imageUrl: json["imageURL"] == null ? null : json["imageURL"],
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    time: json["time"],
    imageId: json["imageId"] == null ? null : json["imageId"],
    voice: json["voice"],
    voiceLink: json["voiceLink"],
    name: json["name"],
    day: json["day"],
    priority: json["priority"] == null ? null : json["priority"],
    category: json["category"],
    v: json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "done": done,
    "imageURL": imageUrl == null ? null : imageUrl,
    "_id": id,
    "title": title,
    "description": description,
    "time": time,
    "imageId": imageId == null ? null : imageId,
    "voice": voice,
    "voiceLink": voiceLink,
    "name": name,
    "day": day,
    "priority": priority == null ? null : priority,
    "category": category,
    "__v": v,
  };
}
