import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('array constraints', () {
    test('generates validation for minItems/maxItems', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'tags': {
            'type': 'array',
            'items': {'type': 'string'},
            'minItems': 1,
            'maxItems': 10,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('minItems'));
      expect(generated, contains('maxItems'));
    });

    test('generates validation for uniqueItems', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'uniqueTags': {
            'type': 'array',
            'items': {'type': 'string'},
            'uniqueItems': true,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('uniqueItems'));
    });

    test('handles tuple validation with prefixItems', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'coordinate': {
            'type': 'array',
            'prefixItems': [
              {'type': 'number'},
              {'type': 'number'},
            ],
            'items': false,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('List'));
    });
  });
}
