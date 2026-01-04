// Example of using schema2model's standalone API
// Run with: dart run example.dart

import 'package:schema2model/schema2model.dart';

void main() {
  print('=== schema2model Standalone API Example ===\n');

  basicExample();
}

void basicExample() {
  print('Example: Basic Code Generation\n');

  final schema = {
    'type': 'object',
    'title': 'Person',
    'properties': {
      'name': {'type': 'string'},
      'age': {'type': 'integer', 'minimum': 0},
    },
    'required': ['name'],
  };

  final options = SchemaGeneratorOptions(
    rootClassName: 'Person',
    emitDocumentation: true,
    emitValidationHelpers: true,
  );

  // Generate code from schema
  final generator = SchemaGenerator(options: options);
  final code = generator.generate(schema);

  print('Generated ${code.split('\n').length} lines of Dart code\n');
  print('Output preview:\n');
  print(code);
}
