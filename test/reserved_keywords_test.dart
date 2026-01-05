import 'package:test/test.dart';
import 'package:schema2dart/src/generator.dart';

void main() {
  group('Reserved Keywords', () {
    test('handles reserved keyword property names', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'class': {'type': 'string'},
          'const': {'type': 'string'},
          'if': {'type': 'boolean'},
          'for': {'type': 'integer'},
          'while': {'type': 'string'},
          'return': {'type': 'number'},
          'name': {'type': 'string'},
        },
        'required': ['class', 'name'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final result = generator.generate(schema);

      expect(result, isNotEmpty);

      // Check that reserved words have underscore suffix
      expect(result, contains('final String class_;'));
      expect(result, contains('final String? const_;'));
      expect(result, contains('final bool? if_;'));
      expect(result, contains('final int? for_;'));
      expect(result, contains('final String? while_;'));
      expect(
        result,
        contains('final double? return_;'),
      ); // number becomes double
      expect(result, contains('final String name;'));

      // Check constructor
      expect(result, contains('required this.class_'));
      expect(result, contains('this.const_'));
      expect(result, contains('this.if_'));

      // Check fromJson uses correct JSON keys
      expect(result, contains("json['class']"));
      expect(result, contains("json['const']"));
      expect(result, contains("json['if']"));
      expect(result, contains("json['for']"));
      expect(result, contains("json['while']"));
      expect(result, contains("json['return']"));

      // Check toJson uses correct JSON keys
      expect(result, contains("map['class'] = class_"));
      expect(result, contains("map['const'] = const_"));
      expect(result, contains("map['if'] = if_"));
    });

    test('handles all Dart reserved keywords', () {
      const reservedKeywords = [
        'abstract',
        'as',
        'assert',
        'async',
        'await',
        'break',
        'case',
        'catch',
        'class',
        'const',
        'continue',
        'default',
        'do',
        'else',
        'enum',
        'extends',
        'factory',
        'false',
        'final',
        'for',
        'if',
        'import',
        'in',
        'is',
        'new',
        'null',
        'return',
        'super',
        'switch',
        'this',
        'throw',
        'true',
        'try',
        'var',
        'void',
        'while',
        'with',
      ];

      final properties = <String, dynamic>{};
      for (final keyword in reservedKeywords) {
        properties[keyword] = const {'type': 'string'};
      }

      final schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': properties,
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final result = generator.generate(schema);

      expect(result, isNotEmpty);

      // All reserved keywords should have underscore suffix
      for (final keyword in reservedKeywords) {
        expect(
          result,
          contains('final String? ${keyword}_'),
          reason: 'Expected "$keyword" to be renamed to "${keyword}_"',
        );
      }
    });

    test('reserved keywords work with serialization', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'class': {'type': 'string'},
          'if': {'type': 'boolean'},
        },
        'required': ['class'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final result = generator.generate(schema);

      // Verify fromJson logic
      expect(result, contains("final class_ = json['class'] as String"));
      expect(result, contains("final if_ = json['if'] as bool?"));

      // Verify toJson logic
      expect(result, contains("map['class'] = class_"));
      expect(result, contains("if (if_ != null) map['if'] = if_"));
    });

    test('reserved keywords in nested objects', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'data': {
            'type': 'object',
            'properties': {
              'const': {'type': 'string'},
              'return': {'type': 'integer'},
            },
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final result = generator.generate(schema);

      expect(result, isNotEmpty);
      expect(result, contains('final String? const_;'));
      expect(result, contains('final int? return_;'));
    });

    test('reserved keywords in enum values', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'status': {
            'type': 'string',
            'enum': ['class', 'const', 'return', 'normal'],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final result = generator.generate(schema);

      expect(result, isNotEmpty);
      // Enum values with reserved keywords should have underscore suffix
      expect(result, contains('class_'));
      expect(result, contains('const_'));
      expect(result, contains('return_'));
      expect(result, contains('normal'));
    });
  });
}
