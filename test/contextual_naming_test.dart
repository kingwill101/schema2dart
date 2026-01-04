import 'dart:io';
import 'package:test/test.dart';
import 'package:schema2model/src/generator.dart';

void main() {
  group('Contextual Naming', () {
    test('array items should use singularized parent name', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'users': {
            'type': 'array',
            'items': {
              'type': 'object',
              'properties': {
                'name': {'type': 'string'},
                'age': {'type': 'integer'}
              }
            }
          }
        }
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final output = generator.generate(schema);

      // Should generate a "User" class, not "UsersItem" or "Class1"
      expect(output, contains('class User'));
      expect(output, isNot(contains('Class1')));
      expect(output, isNot(contains('UsersItem')));
    });

    test('union variants should use type suffixes', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'status': {
            'oneOf': [
              {'type': 'string'},
              {
                'type': 'object',
                'properties': {
                  'code': {'type': 'integer'}
                }
              }
            ]
          }
        }
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final output = generator.generate(schema);

      // Should generate StatusString and StatusObject variants
      expect(output, contains('class StatusString'));
      expect(output, contains('class StatusObject'));
      expect(output, isNot(contains('Class1')));
      expect(output, isNot(contains('StatusVariant')));
    });

    test('discriminated unions should use discriminator values', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'title': 'Shape',
        'oneOf': [
          {
            'type': 'object',
            'properties': {
              'type': {'const': 'circle'},
              'radius': {'type': 'number'}
            }
          },
          {
            'type': 'object',
            'properties': {
              'type': {'const': 'square'},
              'side': {'type': 'number'}
            }
          }
        ],
        'discriminator': {'propertyName': 'type'}
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final output = generator.generate(schema);

      // Should generate Circle and Square classes
      expect(output, contains('class Circle'));
      expect(output, contains('class Square'));
      expect(output, isNot(contains('Class1')));
      expect(output, isNot(contains('ShapeVariant')));
    });

    test('nested objects should use property name', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'config': {
            'type': 'object',
            'properties': {
              'timeout': {'type': 'integer'},
              'retries': {'type': 'integer'}
            }
          }
        }
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final output = generator.generate(schema);

      // Should generate a Config class
      expect(output, contains('class Config'));
      expect(output, isNot(contains('Class1')));
      expect(output, isNot(contains('TestSchemaConfig')));
    });

    test('irregular plural singularization', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'children': {
            'type': 'array',
            'items': {
              'type': 'object',
              'properties': {
                'name': {'type': 'string'}
              }
            }
          },
          'entries': {
            'type': 'array',
            'items': {
              'type': 'object',
              'properties': {
                'key': {'type': 'string'}
              }
            }
          }
        }
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final output = generator.generate(schema);

      // Should handle irregular plurals correctly
      expect(output, contains('class Child'));
      expect(output, contains('class Entry'));
      expect(output, isNot(contains('Childre')));
      expect(output, isNot(contains('Entrie')));
    });

    test('avoid numeric class names', () {
      const schema = <String, dynamic>{
        '\$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'workflowCall': {
            'oneOf': [
              {'type': 'string'},
              {
                'type': 'object',
                'properties': {
                  'uses': {'type': 'string'}
                }
              }
            ]
          }
        }
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final output = generator.generate(schema);

      // Should not generate Class22 or similar
      expect(output, isNot(matches(r'class Class\d+')));
      expect(output, contains('WorkflowCall'));
    });
  });
}
