// To parse this JSON data, do
//
//     final arrayOfObjects = arrayOfObjectsFromJson(jsonString);

import 'dart:convert';

ArrayOfObjects arrayOfObjectsFromJson(String str) =>
    ArrayOfObjects.fromJson(json.decode(str));

String arrayOfObjectsToJson(ArrayOfObjects data) => json.encode(data.toJson());

class ArrayOfObjects {
  String schema;
  String type;
  ArrayOfObjectsProperties properties;

  ArrayOfObjects({
    required this.schema,
    required this.type,
    required this.properties,
  });

  factory ArrayOfObjects.fromJson(Map<String, dynamic> json) => ArrayOfObjects(
    schema: json["\u0024schema"],
    type: json["type"],
    properties: ArrayOfObjectsProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "\u0024schema": schema,
    "type": type,
    "properties": properties.toJson(),
  };
}

class ArrayOfObjectsProperties {
  Users users;

  ArrayOfObjectsProperties({required this.users});

  factory ArrayOfObjectsProperties.fromJson(Map<String, dynamic> json) =>
      ArrayOfObjectsProperties(users: Users.fromJson(json["users"]));

  Map<String, dynamic> toJson() => {"users": users.toJson()};
}

class Users {
  String type;
  Items items;

  Users({required this.type, required this.items});

  factory Users.fromJson(Map<String, dynamic> json) =>
      Users(type: json["type"], items: Items.fromJson(json["items"]));

  Map<String, dynamic> toJson() => {"type": type, "items": items.toJson()};
}

class Items {
  String type;
  ItemsProperties properties;
  List<String> required;

  Items({required this.type, required this.properties, required this.required});

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    type: json["type"],
    properties: ItemsProperties.fromJson(json["properties"]),
    required: List<String>.from(json["required"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties.toJson(),
    "required": List<dynamic>.from(required.map((x) => x)),
  };
}

class ItemsProperties {
  Id id;
  Id name;

  ItemsProperties({required this.id, required this.name});

  factory ItemsProperties.fromJson(Map<String, dynamic> json) =>
      ItemsProperties(
        id: Id.fromJson(json["id"]),
        name: Id.fromJson(json["name"]),
      );

  Map<String, dynamic> toJson() => {"id": id.toJson(), "name": name.toJson()};
}

class Id {
  String type;

  Id({required this.type});

  factory Id.fromJson(Map<String, dynamic> json) => Id(type: json["type"]);

  Map<String, dynamic> toJson() => {"type": type};
}
