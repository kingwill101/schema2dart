import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('nullable types', () {
    test('handles type array with null', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'value': {
            'type': ['string', 'null'],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('String?'));
    });

    test('handles nullable in anyOf', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'value': {
            'anyOf': [
              {'type': 'string'},
              {'type': 'null'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('?'));
    });

    test('handles complex nullable objects', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'data': {
            'anyOf': [
              {
                'type': 'object',
                'properties': {
                  'name': {'type': 'string'},
                },
              },
              {'type': 'null'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('?'));
    });
  });
}
