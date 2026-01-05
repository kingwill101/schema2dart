// Example: Handling Dart reserved keywords in schemas

// Example schema with reserved keywords
const schemaWithKeywords = {
  "type": "object",
  "properties": {
    "class": {"type": "string"},
    "const": {"type": "integer"},
    "if": {"type": "boolean"},
    "enum": {"type": "string"},
    "switch": {"type": "number"},
  },
  "required": ["class"],
};

// This generates:
//
// class MyClass {
//   final String class$;
//   final int? const$;
//   final bool? if$;
//   final String? enum$;
//   final double? switch$;
//
//   const MyClass({
//     required this.class$,
//     this.const$,
//     this.if$,
//     this.enum$,
//     this.switch$,
//   });
//
//   factory MyClass.fromJson(Map<String, dynamic> json) {
//     final class$ = json['class'] as String;
//     final const$ = json['const'] as int?;
//     final if$ = json['if'] as bool?;
//     final enum$ = json['enum'] as String?;
//     final switch$ = json['switch'] as double?;
//     return MyClass(
//       class$: class$,
//       const$: const$,
//       if$: if$,
//       enum$: enum$,
//       switch$: switch$,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'class': class$,
//     if (const$ != null) 'const': const$,
//     if (if$ != null) 'if': if$,
//     if (enum$ != null) 'enum': enum$,
//     if (switch$ != null) 'switch': switch$,
//   };
// }

void demonstrateReservedKeywords() {
  print('Reserved keyword handling:');
  print('1. Appends \$ to field names (class -> class\$)');
  print('2. Maps back to original names in toJson/fromJson');
  print('3. Serialization/deserialization works transparently');
  print('4. Prevents Dart compilation errors');

  // Usage example:
  /*
  final obj = MyClass(
    class$: 'MyType',
    const$: 42,
    if$: true,
  );
  
  // Serializes to original property names
  final json = obj.toJson();
  // {"class": "MyType", "const": 42, "if": true}
  
  // Deserializes from original property names
  final parsed = MyClass.fromJson(json);
  print(parsed.class$); // MyType
  */
}

void demonstrateNestedKeywords() {
  // Reserved keywords in nested objects
  const nestedSchema = {
    "type": "object",
    "properties": {
      "data": {
        "type": "object",
        "properties": {
          "return": {"type": "string"},
          "async": {"type": "boolean"},
        },
      },
    },
  };

  print('\nNested objects handle keywords too:');
  print('Each nested class safely escapes reserved words');
  print('Nested schema example: $nestedSchema');
}

void demonstrateEnumKeywords() {
  // Reserved keywords as enum values
  const enumSchema = {
    "type": "string",
    "enum": ["class", "const", "if", "switch", "normal"],
  };

  print('\nEnum values also handle keywords:');
  print('Enum cases use safe names with value mapping');
  print('Enum schema example: $enumSchema');
}

void main() {
  demonstrateReservedKeywords();
  demonstrateNestedKeywords();
  demonstrateEnumKeywords();

  print('\n✅ All Dart reserved keywords are handled automatically!');
}
