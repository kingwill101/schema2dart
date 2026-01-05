// To parse this JSON data, do
//
//     final nestedObjects = nestedObjectsFromJson(jsonString);

import 'dart:convert';

NestedObjects nestedObjectsFromJson(String str) =>
    NestedObjects.fromJson(json.decode(str));

String nestedObjectsToJson(NestedObjects data) => json.encode(data.toJson());

class NestedObjects {
  String schema;
  String type;
  NestedObjectsProperties properties;

  NestedObjects({
    required this.schema,
    required this.type,
    required this.properties,
  });

  factory NestedObjects.fromJson(Map<String, dynamic> json) => NestedObjects(
    schema: json["\u0024schema"],
    type: json["type"],
    properties: NestedObjectsProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "\u0024schema": schema,
    "type": type,
    "properties": properties.toJson(),
  };
}

class NestedObjectsProperties {
  User user;

  NestedObjectsProperties({required this.user});

  factory NestedObjectsProperties.fromJson(Map<String, dynamic> json) =>
      NestedObjectsProperties(user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"user": user.toJson()};
}

class User {
  String type;
  UserProperties properties;
  List<String> required;

  User({required this.type, required this.properties, required this.required});

  factory User.fromJson(Map<String, dynamic> json) => User(
    type: json["type"],
    properties: UserProperties.fromJson(json["properties"]),
    required: List<String>.from(json["required"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties.toJson(),
    "required": List<dynamic>.from(required.map((x) => x)),
  };
}

class UserProperties {
  Name name;
  Address address;

  UserProperties({required this.name, required this.address});

  factory UserProperties.fromJson(Map<String, dynamic> json) => UserProperties(
    name: Name.fromJson(json["name"]),
    address: Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name.toJson(),
    "address": address.toJson(),
  };
}

class Address {
  String type;
  AddressProperties properties;
  List<String> required;

  Address({
    required this.type,
    required this.properties,
    required this.required,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    type: json["type"],
    properties: AddressProperties.fromJson(json["properties"]),
    required: List<String>.from(json["required"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties.toJson(),
    "required": List<dynamic>.from(required.map((x) => x)),
  };
}

class AddressProperties {
  Name street;
  Name city;

  AddressProperties({required this.street, required this.city});

  factory AddressProperties.fromJson(Map<String, dynamic> json) =>
      AddressProperties(
        street: Name.fromJson(json["street"]),
        city: Name.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
    "street": street.toJson(),
    "city": city.toJson(),
  };
}

class Name {
  String type;

  Name({required this.type});

  factory Name.fromJson(Map<String, dynamic> json) => Name(type: json["type"]);

  Map<String, dynamic> toJson() => {"type": type};
}
