import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('numeric constraints', () {
    test('generates validation for minimum/maximum', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'age': {
            'type': 'integer',
            'minimum': 0,
            'maximum': 150,
          },
          'score': {
            'type': 'number',
            'minimum': 0.0,
            'maximum': 100.0,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('minimum'));
      expect(generated, contains('maximum'));
    });

    test('generates validation for exclusiveMinimum/exclusiveMaximum', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'percentage': {
            'type': 'number',
            'exclusiveMinimum': 0.0,
            'exclusiveMaximum': 100.0,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('exclusiveMinimum'));
      expect(generated, contains('exclusiveMaximum'));
    });

    test('generates validation for multipleOf', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'quantity': {
            'type': 'integer',
            'multipleOf': 5,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('multipleOf'));
    });
  });
}
