// To parse this JSON data, do
//
//     final tasksByDay = tasksByDayFromJson(jsonString);

import 'dart:convert';

class TasksByDay {
  List<ListByDay> listByDay;

  TasksByDay({
    this.listByDay,
  });

  factory TasksByDay.fromJson(String str) => TasksByDay.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TasksByDay.fromMap(Map<String, dynamic> json) => TasksByDay(
    listByDay: json["listByDay"] == null ? null : List<ListByDay>.from(json["listByDay"].map((x) => ListByDay.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "listByDay": listByDay == null ? null : List<dynamic>.from(listByDay.map((x) => x.toMap())),
  };
}

class ListByDay {
  String title;
  int id;
  String time;
  bool done;
  int day;

  ListByDay({
    this.title,
    this.id,
    this.time,
    this.done,
    this.day,
  });

  factory ListByDay.fromJson(String str) => ListByDay.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ListByDay.fromMap(Map<String, dynamic> json) => ListByDay(
    title: json["title"] == null ? null : json["title"],
    id: json["id"] == null ? null : json["id"],
    time: json["time"] == null ? null : json["time"],
    done: json["done"] == null ? null : json["done"],
    day: json["day"] == null ? null : json["day"],
  );

  Map<String, dynamic> toMap() => {
    "title": title == null ? null : title,
    "id": id == null ? null : id,
    "time": time == null ? null : time,
    "done": done == null ? null : done,
    "day": day == null ? null : day,
  };
}
