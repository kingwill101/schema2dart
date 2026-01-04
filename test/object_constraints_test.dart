import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('object constraints', () {
    test('generates validation for minProperties/maxProperties', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'metadata': {
            'type': 'object',
            'minProperties': 1,
            'maxProperties': 5,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains("throwValidationError(_ptr0, 'minProperties'"));
      expect(generated, contains("throwValidationError(_ptr0, 'maxProperties'"));
    });

    test('handles additionalProperties with schema', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
        'additionalProperties': {'type': 'integer'},
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('Map<String,'));
    });

    test('handles patternProperties', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'patternProperties': {
          r'^[a-z]+$': {'type': 'string'},
          r'^[A-Z]+$': {'type': 'integer'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('Map<String,'));
    });

    test('handles propertyNames constraint', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'propertyNames': {
          'pattern': r'^[a-z_]+$',
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('propertyNames'));
    });
  });
}
