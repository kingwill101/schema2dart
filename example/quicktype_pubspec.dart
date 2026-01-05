// To parse this JSON data, do
//
//     final quicktypePubspec = quicktypePubspecFromJson(jsonString);

import 'dart:convert';

QuicktypePubspec quicktypePubspecFromJson(String str) =>
    QuicktypePubspec.fromJson(json.decode(str));

String quicktypePubspecToJson(QuicktypePubspec data) =>
    json.encode(data.toJson());

class QuicktypePubspec {
  String schema;
  String title;
  String description;
  String type;
  QuicktypePubspecProperties properties;
  List<String> required;

  QuicktypePubspec({
    required this.schema,
    required this.title,
    required this.description,
    required this.type,
    required this.properties,
    required this.required,
  });

  factory QuicktypePubspec.fromJson(Map<String, dynamic> json) =>
      QuicktypePubspec(
        schema: json["\u0024schema"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        properties: QuicktypePubspecProperties.fromJson(json["properties"]),
        required: List<String>.from(json["required"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "\u0024schema": schema,
    "title": title,
    "description": description,
    "type": type,
    "properties": properties.toJson(),
    "required": List<dynamic>.from(required.map((x) => x)),
  };
}

class QuicktypePubspecProperties {
  Name name;
  Version version;
  Environment environment;
  PublishTo publishTo;

  QuicktypePubspecProperties({
    required this.name,
    required this.version,
    required this.environment,
    required this.publishTo,
  });

  factory QuicktypePubspecProperties.fromJson(Map<String, dynamic> json) =>
      QuicktypePubspecProperties(
        name: Name.fromJson(json["name"]),
        version: Version.fromJson(json["version"]),
        environment: Environment.fromJson(json["environment"]),
        publishTo: PublishTo.fromJson(json["publish_to"]),
      );

  Map<String, dynamic> toJson() => {
    "name": name.toJson(),
    "version": version.toJson(),
    "environment": environment.toJson(),
    "publish_to": publishTo.toJson(),
  };
}

class Environment {
  String type;
  EnvironmentProperties properties;

  Environment({required this.type, required this.properties});

  factory Environment.fromJson(Map<String, dynamic> json) => Environment(
    type: json["type"],
    properties: EnvironmentProperties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "properties": properties.toJson(),
  };
}

class EnvironmentProperties {
  Version sdk;
  Version flutter;

  EnvironmentProperties({required this.sdk, required this.flutter});

  factory EnvironmentProperties.fromJson(Map<String, dynamic> json) =>
      EnvironmentProperties(
        sdk: Version.fromJson(json["sdk"]),
        flutter: Version.fromJson(json["flutter"]),
      );

  Map<String, dynamic> toJson() => {
    "sdk": sdk.toJson(),
    "flutter": flutter.toJson(),
  };
}

class Version {
  String type;

  Version({required this.type});

  factory Version.fromJson(Map<String, dynamic> json) =>
      Version(type: json["type"]);

  Map<String, dynamic> toJson() => {"type": type};
}

class Name {
  String type;
  String description;

  Name({required this.type, required this.description});

  factory Name.fromJson(Map<String, dynamic> json) =>
      Name(type: json["type"], description: json["description"]);

  Map<String, dynamic> toJson() => {"type": type, "description": description};
}

class PublishTo {
  String type;
  List<String> publishToEnum;
  String description;

  PublishTo({
    required this.type,
    required this.publishToEnum,
    required this.description,
  });

  factory PublishTo.fromJson(Map<String, dynamic> json) => PublishTo(
    type: json["type"],
    publishToEnum: List<String>.from(json["enum"].map((x) => x)),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "enum": List<dynamic>.from(publishToEnum.map((x) => x)),
    "description": description,
  };
}
