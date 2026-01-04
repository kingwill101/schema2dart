// To parse this JSON data, do
//
//     final anyOfObjects = anyOfObjectsFromJson(jsonString);

import 'dart:convert';

AnyOfObjects anyOfObjectsFromJson(String str) => AnyOfObjects.fromJson(json.decode(str));

String anyOfObjectsToJson(AnyOfObjects data) => json.encode(data.toJson());

class AnyOfObjects {
    String schema;
    String type;
    AnyOfObjectsProperties properties;

    AnyOfObjects({
        required this.schema,
        required this.type,
        required this.properties,
    });

    factory AnyOfObjects.fromJson(Map<String, dynamic> json) => AnyOfObjects(
        schema: json["\u0024schema"],
        type: json["type"],
        properties: AnyOfObjectsProperties.fromJson(json["properties"]),
    );

    Map<String, dynamic> toJson() => {
        "\u0024schema": schema,
        "type": type,
        "properties": properties.toJson(),
    };
}

class AnyOfObjectsProperties {
    Data data;

    AnyOfObjectsProperties({
        required this.data,
    });

    factory AnyOfObjectsProperties.fromJson(Map<String, dynamic> json) => AnyOfObjectsProperties(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    List<AnyOf> anyOf;

    Data({
        required this.anyOf,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        anyOf: List<AnyOf>.from(json["anyOf"].map((x) => AnyOf.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "anyOf": List<dynamic>.from(anyOf.map((x) => x.toJson())),
    };
}

class AnyOf {
    String type;
    AnyOfProperties properties;
    List<String> required;

    AnyOf({
        required this.type,
        required this.properties,
        required this.required,
    });

    factory AnyOf.fromJson(Map<String, dynamic> json) => AnyOf(
        type: json["type"],
        properties: AnyOfProperties.fromJson(json["properties"]),
        required: List<String>.from(json["required"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties.toJson(),
        "required": List<dynamic>.from(required.map((x) => x)),
    };
}

class AnyOfProperties {
    Type type;
    Content? content;
    Content? value;

    AnyOfProperties({
        required this.type,
        this.content,
        this.value,
    });

    factory AnyOfProperties.fromJson(Map<String, dynamic> json) => AnyOfProperties(
        type: Type.fromJson(json["type"]),
        content: json["content"] == null ? null : Content.fromJson(json["content"]),
        value: json["value"] == null ? null : Content.fromJson(json["value"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type.toJson(),
        "content": content?.toJson(),
        "value": value?.toJson(),
    };
}

class Content {
    String type;

    Content({
        required this.type,
    });

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}

class Type {
    String typeConst;

    Type({
        required this.typeConst,
    });

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        typeConst: json["const"],
    );

    Map<String, dynamic> toJson() => {
        "const": typeConst,
    };
}
