// Example: Handling Dart reserved keywords in schemas

// Example schema with reserved keywords
const schemaWithKeywords = {
  "type": "object",
  "properties": {
    "class": {"type": "string"},
    "const": {"type": "integer"},
    "if": {"type": "boolean"},
    "enum": {"type": "string"},
    "switch": {"type": "number"}
  },
  "required": ["class"]
};

// This generates:
//
// class MyClass {
//   @JsonKey(name: 'class')
//   final String class$;
//   
//   @JsonKey(name: 'const')
//   final int? const$;
//   
//   @JsonKey(name: 'if')
//   final bool? if$;
//   
//   @JsonKey(name: 'enum')
//   final String? enum$;
//   
//   @JsonKey(name: 'switch')
//   final double? switch$;
//   
//   MyClass({
//     required this.class$,
//     this.const$,
//     this.if$,
//     this.enum$,
//     this.switch$,
//   });
// }

void demonstrateReservedKeywords() {
  print('Reserved keyword handling:');
  print('1. Appends \$ to field names (class -> class\$)');
  print('2. Uses @JsonKey to map back to original names');
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
          "async": {"type": "boolean"}
        }
      }
    }
  };
  
  print('\nNested objects handle keywords too:');
  print('Each nested class safely escapes reserved words');
  print('Nested schema example: $nestedSchema');
}

void demonstrateEnumKeywords() {
  // Reserved keywords as enum values
  const enumSchema = {
    "type": "string",
    "enum": ["class", "const", "if", "switch", "normal"]
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
