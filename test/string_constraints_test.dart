import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('string constraints', () {
    test('generates validation for minLength/maxLength', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'username': {'type': 'string', 'minLength': 3, 'maxLength': 20},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('minLength'));
      expect(generated, contains('maxLength'));
    });

    test('generates validation for pattern', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'email': {
            'type': 'string',
            'pattern': r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(generated, contains('pattern'));
    });
  });
}
