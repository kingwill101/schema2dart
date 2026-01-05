import 'package:test/test.dart';
import 'package:schema2dart/schema2dart.dart';

void main() {
  group('Mixed Type Enum Tests', () {
    test('generates sealed class for mixed-type enum', () {
      final schema = {
        'type': 'object',
        'properties': {
          'status': {
            'enum': ['active', 'inactive', 42, true, null],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);

      print(code);

      // Should generate sealed class
      expect(code, contains('sealed class'));
      expect(code, contains('Status'));
      expect(code, contains('factory'));
      expect(code, contains('.fromJson(dynamic json)'));
      expect(code, contains('dynamic toJson()'));

      // Should generate variant classes
      expect(code, contains('String extends'));
      expect(code, contains('int extends'));
      expect(code, contains('bool extends'));
      expect(code, contains('Null extends'));
    });

    test('handles string and number enum', () {
      final schema = {
        'type': 'object',
        'properties': {
          'value': {
            'enum': ['text', 123, 45.6],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);

      expect(code, contains('sealed class'));
      expect(code, contains('Value'));
      expect(code, contains('String extends'));
      expect(code, contains('int extends'));
      expect(code, contains('double extends'));
    });

    test('serializes and deserializes mixed enum correctly', () {
      final schema = {
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'data': {
            'enum': ['test', 42, true],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);

      // Verify fromJson handles all types
      expect(code, contains('if (json is String)'));
      expect(code, contains('if (json is int)'));
      expect(code, contains('if (json is bool)'));
    });

    test('handles null in mixed enum', () {
      final schema = {
        'type': 'object',
        'properties': {
          'nullable': {
            'enum': ['value', null],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);

      expect(code, contains('sealed class'));
      expect(code, contains('Nullable'));
      expect(code, contains('if (json == null)'));
      expect(code, contains('Null extends'));
    });

    test('falls back to regular enum for string-only values', () {
      final schema = {
        'type': 'object',
        'properties': {
          'simple': {
            'enum': ['one', 'two', 'three'],
          },
        },
      };

      final generator = SchemaGenerator(options: SchemaGeneratorOptions());
      final code = generator.generate(schema);

      // Should use regular enum, not sealed class
      expect(code, contains('enum'));
      expect(code, contains('Simple'));
      expect(code, isNot(contains('sealed class')));
    });
  });
}
