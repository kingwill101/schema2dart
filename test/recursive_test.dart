import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('recursive schemas', () {
    test('handles self-referencing schemas', () {
      const schema = <String, dynamic>{
        '\$id': 'https://example.com/tree',
        'type': 'object',
        'properties': {
          'value': {'type': 'string'},
          'children': {
            'type': 'array',
            'items': {'\$ref': '#'},
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('List<'));
      expect(generated, isNotEmpty);
    });

    test('handles mutually recursive schemas', () {
      const schema = <String, dynamic>{
        'title': 'Person',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
          'spouse': {'\$ref': '#'},
          'children': {
            'type': 'array',
            'items': {'\$ref': '#'},
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('Person'));
      expect(generated, isNotEmpty);
    });

    test('handles recursive definitions', () {
      const schema = <String, dynamic>{
        '\$defs': {
          'node': {
            'type': 'object',
            'properties': {
              'value': {'type': 'integer'},
              'next': {'\$ref': '#/\$defs/node'},
            },
          },
        },
        '\$ref': '#/\$defs/node',
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });
  });
}
