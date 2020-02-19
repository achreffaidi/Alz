// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

Contact contactFromJson(String str) => Contact.fromMap(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toMap());

class Contact {
  List<ContactsList> contactsList;

  Contact({
    this.contactsList,
  });

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    contactsList: List<ContactsList>.from(json["contactsList"].map((x) => ContactsList.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "contactsList": List<dynamic>.from(contactsList.map((x) => x.toMap())),
  };
}

class ContactsList {
  String id;
  String description;
  int number;
  String name;
  String imageId;
  String imageUrl;
  int v;

  ContactsList({
    this.id,
    this.description,
    this.number,
    this.name,
    this.imageId,
    this.imageUrl,
    this.v,
  });

  factory ContactsList.fromMap(Map<String, dynamic> json) => ContactsList(
    id: json["_id"],
    description: json["description"],
    number: json["number"],
    name: json["name"],
    imageId: json["imageId"],
    imageUrl: json["imageURL"],
    v: json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "description": description,
    "number": number,
    "name": name,
    "imageId": imageId,
    "imageURL": imageUrl,
    "__v": v,
  };
}
