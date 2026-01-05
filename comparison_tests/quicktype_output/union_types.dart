// To parse this JSON data, do
//
//     final unionTypes = unionTypesFromJson(jsonString);

import 'dart:convert';

UnionTypes unionTypesFromJson(String str) =>
    UnionTypes.fromJson(json.decode(str));

String unionTypesToJson(UnionTypes data) => json.encode(data.toJson());

class UnionTypes {
  String schema;
  String type;
  Properties properties;

  UnionTypes({
    required this.schema,
    required this.type,
    required this.properties,
  });

  factory UnionTypes.fromJson(Map<String, dynamic> json) => UnionTypes(
    schema: json["\u0024schema"],
    type: json["type"],
    properties: Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "\u0024schema": schema,
    "type": type,
    "properties": properties.toJson(),
  };
}

class Properties {
  Value value;

  Properties({required this.value});

  factory Properties.fromJson(Map<String, dynamic> json) =>
      Properties(value: Value.fromJson(json["value"]));

  Map<String, dynamic> toJson() => {"value": value.toJson()};
}

class Value {
  List<OneOf> oneOf;

  Value({required this.oneOf});

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    oneOf: List<OneOf>.from(json["oneOf"].map((x) => OneOf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "oneOf": List<dynamic>.from(oneOf.map((x) => x.toJson())),
  };
}

class OneOf {
  String type;

  OneOf({required this.type});

  factory OneOf.fromJson(Map<String, dynamic> json) =>
      OneOf(type: json["type"]);

  Map<String, dynamic> toJson() => {"type": type};
}
