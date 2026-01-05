// To parse this JSON data, do
//
//     final allOfComposition = allOfCompositionFromJson(jsonString);

import 'dart:convert';

AllOfComposition allOfCompositionFromJson(String str) =>
    AllOfComposition.fromJson(json.decode(str));

String allOfCompositionToJson(AllOfComposition data) =>
    json.encode(data.toJson());

class AllOfComposition {
  String schema;
  String type;
  List<AllOf> allOf;

  AllOfComposition({
    required this.schema,
    required this.type,
    required this.allOf,
  });

  factory AllOfComposition.fromJson(Map<String, dynamic> json) =>
      AllOfComposition(
        schema: json["\u0024schema"],
        type: json["type"],
        allOf: List<AllOf>.from(json["allOf"].map((x) => AllOf.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "\u0024schema": schema,
    "type": type,
    "allOf": List<dynamic>.from(allOf.map((x) => x.toJson())),
  };
}

class AllOf {
  Properties properties;
  List<String> required;

  AllOf({required this.properties, required this.required});

  factory AllOf.fromJson(Map<String, dynamic> json) => AllOf(
    properties: Properties.fromJson(json["properties"]),
    required: List<String>.from(json["required"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "properties": properties.toJson(),
    "required": List<dynamic>.from(required.map((x) => x)),
  };
}

class Properties {
  Age? name;
  Age? age;

  Properties({this.name, this.age});

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    name: json["name"] == null ? null : Age.fromJson(json["name"]),
    age: json["age"] == null ? null : Age.fromJson(json["age"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name?.toJson(),
    "age": age?.toJson(),
  };
}

class Age {
  String type;

  Age({required this.type});

  factory Age.fromJson(Map<String, dynamic> json) => Age(type: json["type"]);

  Map<String, dynamic> toJson() => {"type": type};
}
