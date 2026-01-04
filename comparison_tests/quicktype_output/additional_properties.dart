// To parse this JSON data, do
//
//     final additionalProperties = additionalPropertiesFromJson(jsonString);

import 'dart:convert';

AdditionalProperties additionalPropertiesFromJson(String str) => AdditionalProperties.fromJson(json.decode(str));

String additionalPropertiesToJson(AdditionalProperties data) => json.encode(data.toJson());

class AdditionalProperties {
    String schema;
    String type;
    Properties properties;
    AdditionalPropertiesClass additionalProperties;

    AdditionalProperties({
        required this.schema,
        required this.type,
        required this.properties,
        required this.additionalProperties,
    });

    factory AdditionalProperties.fromJson(Map<String, dynamic> json) => AdditionalProperties(
        schema: json["\u0024schema"],
        type: json["type"],
        properties: Properties.fromJson(json["properties"]),
        additionalProperties: AdditionalPropertiesClass.fromJson(json["additionalProperties"]),
    );

    Map<String, dynamic> toJson() => {
        "\u0024schema": schema,
        "type": type,
        "properties": properties.toJson(),
        "additionalProperties": additionalProperties.toJson(),
    };
}

class AdditionalPropertiesClass {
    String type;

    AdditionalPropertiesClass({
        required this.type,
    });

    factory AdditionalPropertiesClass.fromJson(Map<String, dynamic> json) => AdditionalPropertiesClass(
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}

class Properties {
    AdditionalPropertiesClass known;

    Properties({
        required this.known,
    });

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        known: AdditionalPropertiesClass.fromJson(json["known"]),
    );

    Map<String, dynamic> toJson() => {
        "known": known.toJson(),
    };
}
