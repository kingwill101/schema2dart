import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('conditional schemas', () {
    test('handles if/then/else', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'country': {'type': 'string'},
        },
        'if': {
          'properties': {
            'country': {'const': 'USA'},
          },
        },
        'then': {
          'properties': {
            'zipCode': {'type': 'string', 'pattern': r'^\d{5}$'},
          },
          'required': ['zipCode'],
        },
        'else': {
          'properties': {
            'postalCode': {'type': 'string'},
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      // Should generate a class that can handle conditional properties
      expect(generated, isNotEmpty);
    });

    test('handles dependentSchemas', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'creditCard': {'type': 'string'},
        },
        'dependentSchemas': {
          'creditCard': {
            'properties': {
              'billingAddress': {'type': 'string'},
            },
            'required': ['billingAddress'],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });

    test('handles dependentRequired', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
          'creditCard': {'type': 'string'},
          'billingAddress': {'type': 'string'},
        },
        'dependentRequired': {
          'creditCard': ['billingAddress'],
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('dependentRequired'));
    });
  });
}
