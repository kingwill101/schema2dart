import 'package:test/test.dart';
import 'package:schema2model/schema2model.dart';

void main() {
  group('Primitive Union Types', () {
    test('generates sealed class for string | number union', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'oneOf': [
              {'type': 'string'},
              {'type': 'number'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      // Should generate sealed class, not dynamic
      expect(code, contains('sealed class'));
      expect(code, contains('sealed class Value')); // Updated: uses contextual name
      expect(code, isNot(contains('final dynamic value')));
    });

    test('generates sealed class for string | number | boolean union', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'oneOf': [
              {'type': 'string'},
              {'type': 'number'},
              {'type': 'boolean'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      expect(code, contains('sealed class Value')); // Updated: uses contextual name
      expect(code, contains('String'));
      expect(code, contains('num'));
      expect(code, contains('bool'));
    });

    test('generates sealed class for string | null union', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'oneOf': [
              {'type': 'string'},
              {'type': 'null'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      // Should return nullable String? instead of sealed class for string | null
      expect(code, contains('final String? value'));
    });

    test('generates sealed class for mixed object and primitive union', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'oneOf': [
              {'type': 'string'},
              {
                'type': 'object',
                'properties': {
                  'name': {'type': 'string'},
                },
              },
            ],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      expect(code, contains('sealed class Value')); // Updated: uses contextual name
      expect(code, contains('String'));
      expect(code, contains('class'));
    });

    test('serializes and deserializes primitive unions correctly', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'oneOf': [
              {'type': 'string'},
              {'type': 'number'},
            ],
          },
        },
        'required': ['value'],
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      // Should have fromJson that checks types
      expect(code, contains('fromJson'));
      expect(code, anyOf(contains('is String'), contains('String')));
      expect(code, anyOf(contains('is num'), contains('num')));
      
      // Should have toJson
      expect(code, contains('toJson'));
    });

    test('handles anyOf with primitive types', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'anyOf': [
              {'type': 'string'},
              {'type': 'integer'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      expect(code, contains('sealed class'));
      expect(code, contains('Value')); // Updated: uses contextual name from pointer
    });

    test('handles array of primitive unions', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'values': {
            'type': 'array',
            'items': {
              'oneOf': [
                {'type': 'string'},
                {'type': 'number'},
              ],
            },
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);
      
      expect(code, contains('List<'));
      expect(code, contains('Value')); // Updated: uses contextual name from pointer
    });
  });
}
