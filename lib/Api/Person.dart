// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

class Person {
  String name;
  String userData;

  Person({
    this.name,
    this.userData,
  });

  factory Person.fromJson(String str) => Person.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Person.fromMap(Map<String, dynamic> json) => Person(
    name: json["name"] == null ? null : json["name"],
    userData: json["userData"] == null ? null : json["userData"],
  );

  Map<String, dynamic> toMap() => {
    "name": name == null ? null : name,
    "userData": userData == null ? null : userData,
  };
}
