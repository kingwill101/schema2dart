import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('edge cases', () {
    test('handles empty schema', () {
      const schema = <String, dynamic>{};

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });

    test('handles schema with only title', () {
      const schema = <String, dynamic>{'title': 'EmptyClass'};

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('EmptyClass'));
    });

    test('handles deeply nested objects', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'level1': {
            'type': 'object',
            'properties': {
              'level2': {
                'type': 'object',
                'properties': {
                  'level3': {
                    'type': 'object',
                    'properties': {
                      'value': {'type': 'string'},
                    },
                  },
                },
              },
            },
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });

    test('handles special characters in property names', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          '@type': {'type': 'string'},
          '\$id': {'type': 'string'},
          'kebab-case': {'type': 'string'},
          'snake_case': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });

    test('handles boolean schemas', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {'anything': true, 'nothing': false},
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });

    test('handles multiple types', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'flexible': {
            'type': ['string', 'integer', 'boolean'],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });
  });
}
