// To parse this JSON data, do
//
//     final definitionsRefs = definitionsRefsFromJson(jsonString);

import 'dart:convert';

DefinitionsRefs definitionsRefsFromJson(String str) =>
    DefinitionsRefs.fromJson(json.decode(str));

String definitionsRefsToJson(DefinitionsRefs data) =>
    json.encode(data.toJson());

class DefinitionsRefs {
  String schema;
  Definitions definitions;
  String type;
  DefinitionsRefsProperties properties;

  DefinitionsRefs({
    required this.schema,
    required this.definitions,
    required this.type,
    required this.properties,
  });

  factory DefinitionsRefs.fromJson(Map<String, dynamic> json) =>
      DefinitionsRefs(
        schema: json["\u0024schema"],
        definitions: Definitions.fromJson(json["definitions"]),
        type: json["type"],
        properties: DefinitionsRefsProperties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
    "\u0024schema": schema,
    "definitions": definitions.toJson(),
    "type": type,
    "properties": properties.toJson(),
  };
}

class Definitions {
  Address address;

  Definitions({required this.address});

  factory Definitions.fromJson(Map<String, dynamic> json) =>
      Definitions(address: Address.fromJson(json["address"]));

  Map<String, dynamic> toJson() => {"address": address.toJson()};
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
  City street;
  City city;

  AddressProperties({required this.street, required this.city});

  factory AddressProperties.fromJson(Map<String, dynamic> json) =>
      AddressProperties(
        street: City.fromJson(json["street"]),
        city: City.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
    "street": street.toJson(),
    "city": city.toJson(),
  };
}

class City {
  String type;

  City({required this.type});

  factory City.fromJson(Map<String, dynamic> json) => City(type: json["type"]);

  Map<String, dynamic> toJson() => {"type": type};
}

class DefinitionsRefsProperties {
  Home home;
  Home work;

  DefinitionsRefsProperties({required this.home, required this.work});

  factory DefinitionsRefsProperties.fromJson(Map<String, dynamic> json) =>
      DefinitionsRefsProperties(
        home: Home.fromJson(json["home"]),
        work: Home.fromJson(json["work"]),
      );

  Map<String, dynamic> toJson() => {
    "home": home.toJson(),
    "work": work.toJson(),
  };
}

class Home {
  String ref;

  Home({required this.ref});

  factory Home.fromJson(Map<String, dynamic> json) =>
      Home(ref: json["\u0024ref"]);

  Map<String, dynamic> toJson() => {"\u0024ref": ref};
}
