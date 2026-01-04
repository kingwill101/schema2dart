import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('not keyword', () {
    test('handles not constraint', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'value': {
            'not': {
              'type': 'null',
            },
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('not'));
    });

    test('handles complex not with object', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'not': {
          'properties': {
            'forbidden': {'type': 'string'},
          },
          'required': ['forbidden'],
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, isNotEmpty);
    });
  });
}
