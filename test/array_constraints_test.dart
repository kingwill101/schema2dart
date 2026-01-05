import 'package:schema2dart/src/generator.dart';
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

      expect(generated, contains("throwValidationError(_ptr0, 'minItems'"));
      expect(generated, contains("throwValidationError(_ptr0, 'maxItems'"));
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

      expect(generated, contains("throwValidationError(_ptr0, 'uniqueItems'"));
      expect(generated, contains('uniqueItemKey'));
    });

    test('validates contains schema constraints', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'tags': {
            'type': 'array',
            'contains': {'type': 'string', 'pattern': r'^urgent'},
            'minContains': 1,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(
        generated,
        contains("throwValidationError(itemPointer, 'pattern'"),
      );
      expect(generated, contains("throwValidationError(_ptr0, 'contains'"));
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
