// To parse this JSON data, do
//
//     final quicktypePubspec2 = quicktypePubspec2FromJson(jsonString);

import 'dart:convert';

QuicktypePubspec2 quicktypePubspec2FromJson(String str) =>
    QuicktypePubspec2.fromJson(json.decode(str));

String quicktypePubspec2ToJson(QuicktypePubspec2 data) =>
    json.encode(data.toJson());

///A tiny subset of the pubspec.yaml structure to demonstrate generation.
class QuicktypePubspec2 {
  Environment? environment;

  ///Package name.
  String name;

  ///Publish destination or 'none'.
  PublishTo? publishTo;
  String? version;

  QuicktypePubspec2({
    this.environment,
    required this.name,
    this.publishTo,
    this.version,
  });

  factory QuicktypePubspec2.fromJson(Map<String, dynamic> json) =>
      QuicktypePubspec2(
        environment: json["environment"] == null
            ? null
            : Environment.fromJson(json["environment"]),
        name: json["name"],
        publishTo: publishToValues.map[json["publish_to"]]!,
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
    "environment": environment?.toJson(),
    "name": name,
    "publish_to": publishToValues.reverse[publishTo],
    "version": version,
  };
}

class Environment {
  String? flutter;
  String? sdk;

  Environment({this.flutter, this.sdk});

  factory Environment.fromJson(Map<String, dynamic> json) =>
      Environment(flutter: json["flutter"], sdk: json["sdk"]);

  Map<String, dynamic> toJson() => {"flutter": flutter, "sdk": sdk};
}

///Publish destination or 'none'.
enum PublishTo { NONE, PUB_DEV }

final publishToValues = EnumValues({
  "none": PublishTo.NONE,
  "pub.dev": PublishTo.PUB_DEV,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
