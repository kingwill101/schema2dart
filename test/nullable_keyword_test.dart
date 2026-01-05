import 'package:test/test.dart';
import 'package:schema2dart/src/generator.dart';

void main() {
  group('OpenAPI nullable Keyword', () {
    test('nullable string field', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'name': {'type': 'string', 'nullable': true},
        },
        'required': ['name'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Field should be nullable (nullable overrides required)
      expect(output, contains('final String? name;'));
      expect(output, contains('this.name'));
    });

    test('nullable object field', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'user': {
            'type': 'object',
            'nullable': true,
            'properties': {
              'name': {'type': 'string'},
            },
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Nested object should be nullable
      expect(output, contains('User? user;'));
    });

    test('nullable array field', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'tags': {
            'type': 'array',
            'items': {'type': 'string'},
            'nullable': true,
          },
        },
        'required': ['tags'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Array should be nullable
      expect(output, contains('final List<String>? tags;'));
    });

    test('nullable with default null', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'status': {'type': 'string', 'nullable': true, 'default': null},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Should be nullable and optional
      expect(output, contains('final String? status;'));
      expect(output, contains('this.status'));
    });

    test('nullable false is not nullable unless not required', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'name': {'type': 'string', 'nullable': false},
        },
        'required': ['name'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Should NOT be nullable
      expect(output, contains('final String name;'));
    });

    test('nullable with enum', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'color': {
            'type': 'string',
            'enum': ['RED', 'GREEN', 'BLUE'],
            'nullable': true,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Enum should be nullable
      expect(output, contains('Color?'));
    });

    test('nullable works with type array', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'value': {
            'type': ['string', 'null'],
            'nullable': true,
          },
        },
        'required': ['value'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Should be nullable (both nullable keyword and type array)
      expect(output, contains('final String? value;'));
    });

    test('nullable on integer field', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'age': {'type': 'integer', 'nullable': true},
        },
        'required': ['age'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );

      final output = generator.generate(schema);

      // Integer should be nullable
      expect(output, contains('final int? age;'));
    });
  });
}
