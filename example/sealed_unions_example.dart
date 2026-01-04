// Example: Type-safe union types with sealed classes

// Example schema with oneOf
const oneOfSchema = {
  "oneOf": [
    {"type": "string"},
    {"type": "integer"},
    {
      "type": "object",
      "properties": {
        "id": {"type": "string"},
        "name": {"type": "string"}
      },
      "required": ["id"]
    }
  ]
};

// This generates a sealed class hierarchy:
//
// sealed class Value {}
//
// class ValueString extends Value {
//   final String value;
//   ValueString(this.value);
// }
//
// class ValueInteger extends Value {
//   final int value;
//   ValueInteger(this.value);
// }
//
// class ValueObject extends Value {
//   final String id;
//   final String? name;
//   ValueObject({required this.id, this.name});
// }

void demonstrateExhaustiveMatching() {
  // Example usage with pattern matching
  print('Union types with sealed classes provide:');
  print('1. Type safety - compiler ensures all cases handled');
  print('2. Exhaustiveness - no missing cases');
  print('3. Pattern matching - elegant switch expressions');
  
  // Pattern matching example:
  /*
  String describe(Value v) => switch (v) {
    ValueString(value: final s) => 'String: $s',
    ValueInteger(value: final i) => 'Number: $i',
    ValueObject(id: final id, name: final name) => 
      'Object(id: $id, name: ${name ?? "unnamed"})',
  };
  
  // Usage:
  final value1 = ValueString('hello');
  final value2 = ValueInteger(42);
  final value3 = ValueObject(id: 'abc-123', name: 'Item');
  
  print(describe(value1)); // String: hello
  print(describe(value2)); // Number: 42
  print(describe(value3)); // Object(id: abc-123, name: Item)
  */
}

void demonstrateAnyOf() {
  // anyOf generates similar sealed classes but allows multiple matches
  const anyOfSchema = {
    "anyOf": [
      {"type": "string", "minLength": 5},
      {"type": "string", "pattern": r"^\d+$"}
    ]
  };
  
  print('\nanyOf is handled similarly to oneOf');
  print('Generates sealed class unions for type safety');
}

void demonstrateDiscriminatedUnions() {
  // With discriminator property
  const discriminatedSchema = {
    "oneOf": [
      {
        "type": "object",
        "properties": {
          "type": {"const": "circle"},
          "radius": {"type": "number"}
        },
        "required": ["type", "radius"]
      },
      {
        "type": "object",
        "properties": {
          "type": {"const": "rectangle"},
          "width": {"type": "number"},
          "height": {"type": "number"}
        },
        "required": ["type", "width", "height"]
      }
    ]
  };
  
  print('\nDiscriminated unions use const values for efficient deserialization');
  print('Pattern matching on sealed classes provides type-safe access');
}

void main() {
  demonstrateExhaustiveMatching();
  demonstrateAnyOf();
  demonstrateDiscriminatedUnions();
  
  print('\n✨ Sealed unions are a major advantage over dynamic typing!');
}
