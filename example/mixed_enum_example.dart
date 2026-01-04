import 'package:schema2model/schema2model.dart';

void main() {
  final schema = {
    '\$schema': 'https://json-schema.org/draft/2020-12/schema',
    'title': 'ConfigValue',
    'type': 'object',
    'properties': {
      'setting': {
        'description': 'A configuration value that can be string, number, boolean, or null',
        'enum': ['auto', 'manual', 42, 3.14, true, false, null]
      }
    }
  };

  final generator = SchemaGenerator(options: SchemaGeneratorOptions());
  final code = generator.generate(schema);

  print('Generated Dart code:');
  print('=' * 80);
  print(code);
  print('=' * 80);
}
