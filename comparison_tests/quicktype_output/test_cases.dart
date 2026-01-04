// To parse this JSON data, do
//
//     final testCases = testCasesFromJson(jsonString);

import 'dart:convert';

TestCases testCasesFromJson(String str) => TestCases.fromJson(json.decode(str));

String testCasesToJson(TestCases data) => json.encode(data.toJson());

class TestCases {
    List<TestCase> testCases;

    TestCases({
        required this.testCases,
    });

    factory TestCases.fromJson(Map<String, dynamic> json) => TestCases(
        testCases: List<TestCase>.from(json["test_cases"].map((x) => TestCase.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "test_cases": List<dynamic>.from(testCases.map((x) => x.toJson())),
    };
}

class TestCase {
    String name;
    Schema schema;

    TestCase({
        required this.name,
        required this.schema,
    });

    factory TestCase.fromJson(Map<String, dynamic> json) => TestCase(
        name: json["name"],
        schema: Schema.fromJson(json["schema"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "schema": schema.toJson(),
    };
}

class Schema {
    String schema;
    String type;
    SchemaProperties? properties;
    List<AllOf>? allOf;
    AdditionalProperties? additionalProperties;
    Definitions? definitions;

    Schema({
        required this.schema,
        required this.type,
        this.properties,
        this.allOf,
        this.additionalProperties,
        this.definitions,
    });

    factory Schema.fromJson(Map<String, dynamic> json) => Schema(
        schema: json["\u0024schema"],
        type: json["type"],
        properties: json["properties"] == null ? null : SchemaProperties.fromJson(json["properties"]),
        allOf: json["allOf"] == null ? [] : List<AllOf>.from(json["allOf"]!.map((x) => AllOf.fromJson(x))),
        additionalProperties: json["additionalProperties"] == null ? null : AdditionalProperties.fromJson(json["additionalProperties"]),
        definitions: json["definitions"] == null ? null : Definitions.fromJson(json["definitions"]),
    );

    Map<String, dynamic> toJson() => {
        "\u0024schema": schema,
        "type": type,
        "properties": properties?.toJson(),
        "allOf": allOf == null ? [] : List<dynamic>.from(allOf!.map((x) => x.toJson())),
        "additionalProperties": additionalProperties?.toJson(),
        "definitions": definitions?.toJson(),
    };
}

class AdditionalProperties {
    String type;

    AdditionalProperties({
        required this.type,
    });

    factory AdditionalProperties.fromJson(Map<String, dynamic> json) => AdditionalProperties(
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
    };
}

class AllOf {
    AllOfProperties properties;
    List<String> required;

    AllOf({
        required this.properties,
        required this.required,
    });

    factory AllOf.fromJson(Map<String, dynamic> json) => AllOf(
        properties: AllOfProperties.fromJson(json["properties"]),
        required: List<String>.from(json["required"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "properties": properties.toJson(),
        "required": List<dynamic>.from(required.map((x) => x)),
    };
}

class AllOfProperties {
    AdditionalProperties? name;
    AdditionalProperties? age;

    AllOfProperties({
        this.name,
        this.age,
    });

    factory AllOfProperties.fromJson(Map<String, dynamic> json) => AllOfProperties(
        name: json["name"] == null ? null : AdditionalProperties.fromJson(json["name"]),
        age: json["age"] == null ? null : AdditionalProperties.fromJson(json["age"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name?.toJson(),
        "age": age?.toJson(),
    };
}

class Definitions {
    Address address;

    Definitions({
        required this.address,
    });

    factory Definitions.fromJson(Map<String, dynamic> json) => Definitions(
        address: Address.fromJson(json["address"]),
    );

    Map<String, dynamic> toJson() => {
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
    AdditionalProperties street;
    AdditionalProperties city;

    AddressProperties({
        required this.street,
        required this.city,
    });

    factory AddressProperties.fromJson(Map<String, dynamic> json) => AddressProperties(
        street: AdditionalProperties.fromJson(json["street"]),
        city: AdditionalProperties.fromJson(json["city"]),
    );

    Map<String, dynamic> toJson() => {
        "street": street.toJson(),
        "city": city.toJson(),
    };
}

class SchemaProperties {
    User? user;
    Users? users;
    Value? value;
    Data? data;
    AdditionalProperties? known;
    Home? home;
    Home? work;

    SchemaProperties({
        this.user,
        this.users,
        this.value,
        this.data,
        this.known,
        this.home,
        this.work,
    });

    factory SchemaProperties.fromJson(Map<String, dynamic> json) => SchemaProperties(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
        value: json["value"] == null ? null : Value.fromJson(json["value"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        known: json["known"] == null ? null : AdditionalProperties.fromJson(json["known"]),
        home: json["home"] == null ? null : Home.fromJson(json["home"]),
        work: json["work"] == null ? null : Home.fromJson(json["work"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "users": users?.toJson(),
        "value": value?.toJson(),
        "data": data?.toJson(),
        "known": known?.toJson(),
        "home": home?.toJson(),
        "work": work?.toJson(),
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
    AdditionalProperties? content;
    AdditionalProperties? value;

    AnyOfProperties({
        required this.type,
        this.content,
        this.value,
    });

    factory AnyOfProperties.fromJson(Map<String, dynamic> json) => AnyOfProperties(
        type: Type.fromJson(json["type"]),
        content: json["content"] == null ? null : AdditionalProperties.fromJson(json["content"]),
        value: json["value"] == null ? null : AdditionalProperties.fromJson(json["value"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type.toJson(),
        "content": content?.toJson(),
        "value": value?.toJson(),
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

class Home {
    String ref;

    Home({
        required this.ref,
    });

    factory Home.fromJson(Map<String, dynamic> json) => Home(
        ref: json["\u0024ref"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024ref": ref,
    };
}

class User {
    String type;
    UserProperties properties;
    List<String> required;

    User({
        required this.type,
        required this.properties,
        required this.required,
    });

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
    AdditionalProperties name;
    Address address;

    UserProperties({
        required this.name,
        required this.address,
    });

    factory UserProperties.fromJson(Map<String, dynamic> json) => UserProperties(
        name: AdditionalProperties.fromJson(json["name"]),
        address: Address.fromJson(json["address"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name.toJson(),
        "address": address.toJson(),
    };
}

class Users {
    String type;
    Items items;

    Users({
        required this.type,
        required this.items,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        type: json["type"],
        items: Items.fromJson(json["items"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "items": items.toJson(),
    };
}

class Items {
    String type;
    ItemsProperties properties;
    List<String> required;

    Items({
        required this.type,
        required this.properties,
        required this.required,
    });

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
    AdditionalProperties id;
    AdditionalProperties name;

    ItemsProperties({
        required this.id,
        required this.name,
    });

    factory ItemsProperties.fromJson(Map<String, dynamic> json) => ItemsProperties(
        id: AdditionalProperties.fromJson(json["id"]),
        name: AdditionalProperties.fromJson(json["name"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id.toJson(),
        "name": name.toJson(),
    };
}

class Value {
    List<AdditionalProperties> oneOf;

    Value({
        required this.oneOf,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        oneOf: List<AdditionalProperties>.from(json["oneOf"].map((x) => AdditionalProperties.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "oneOf": List<dynamic>.from(oneOf.map((x) => x.toJson())),
    };
}
