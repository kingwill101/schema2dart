import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('Usage Documentation Generation', () {
    test('generates usage docs when option is enabled', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitUsageDocs: true),
      );
      final generated = generator.generate(schema);

      // Should contain usage instructions
      expect(generated, contains('// To parse JSON data:'));
      expect(generated, contains("//     import 'dart:convert';"));
      expect(generated, contains('//     final obj = ClassName.fromJson(jsonDecode(jsonString));'));
      expect(generated, contains('//     final jsonString = jsonEncode(obj.toJson());'));
    });

    test('includes helper function docs when helpers are enabled', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(
          emitUsageDocs: true,
          generateHelpers: true,
        ),
      );
      final generated = generator.generate(schema);

      // Should contain helper function usage
      expect(generated, contains('// Or use the helper functions:'));
      expect(generated, contains('//     final obj = classNameFromJson(jsonString);'));
      expect(generated, contains('//     final jsonString = classNameToJson(obj);'));
    });

    test('does not generate usage docs when option is disabled', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitUsageDocs: false),
      );
      final generated = generator.generate(schema);

      // Should not contain usage docs
      expect(generated, isNot(contains('// To parse JSON data:')));
    });

    test('still includes DO NOT MODIFY warning', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitUsageDocs: true),
      );
      final generated = generator.generate(schema);

      // Should always have the warning
      expect(generated, contains('// GENERATED CODE - DO NOT MODIFY BY HAND'));
    });

    test('includes source path when provided', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(
          emitUsageDocs: true,
          sourcePath: 'schemas/user.json',
        ),
      );
      final generated = generator.generate(schema);

      // Should include source
      expect(generated, contains('// Source: schemas/user.json'));
    });
  });
}
