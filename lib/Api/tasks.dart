// To parse this JSON data, do
//
//     final tasks = tasksFromJson(jsonString);

import 'dart:convert';

class Tasks {
  List<Task> tasks;

  Tasks({
    this.tasks,
  });

  factory Tasks.fromJson(String str) => Tasks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tasks.fromMap(Map<String, dynamic> json) => Tasks(
    tasks: json["tasks"] == null ? null : List<Task>.from(json["tasks"].map((x) => Task.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "tasks": tasks == null ? null : List<dynamic>.from(tasks.map((x) => x.toMap())),
  };
}

class Task {
  String id;
  String time;
  String day;
  bool done;
  String title;

  Task({
    this.id,
    this.time,
    this.day,
    this.done,
    this.title,
  });

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json["id"] == null ? null : json["id"],
    time: json["time"] == null ? null : json["time"],
    day: json["day"] == null ? null : json["day"],
    done: json["done"] == null ? null : json["done"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "time": time == null ? null : time,
    "day": day == null ? null : day,
    "done": done == null ? null : done,
    "title": title == null ? null : title,
  };
}
