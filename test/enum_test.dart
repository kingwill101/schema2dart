import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('enum handling', () {
    test('generates enum for string enum values', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'status': {
            'type': 'string',
            'enum': ['pending', 'approved', 'rejected'],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('enum'));
    });

    test('handles const values', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'version': {'const': '1.0.0'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('1.0.0'));
    });

    test('handles mixed-type enum with anyOf', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'value': {
            'enum': ['auto', 42, true, null],
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
