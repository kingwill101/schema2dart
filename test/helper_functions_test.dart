import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('Helper Functions Generation', () {
    test('generates helper functions when option is enabled', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
          'age': {'type': 'integer'},
        },
        'required': ['name', 'age'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(generateHelpers: true),
      );
      final generated = generator.generate(schema);

      // Should contain dart:convert import
      expect(generated, contains("import 'dart:convert';"));

      // Should contain fromJson helper
      expect(generated, contains('User userFromJson(String str)'));
      expect(generated, contains('User.fromJson(json.decode(str)'));

      // Should contain toJson helper
      expect(generated, contains('String userToJson(User data)'));
      expect(generated, contains('json.encode(data.toJson())'));

      // Should have documentation
      expect(generated, contains('/// Parses [str] as JSON'));
      expect(generated, contains('/// Serializes [data] into a JSON string'));
    });

    test('does not generate helpers when option is disabled', () {
      const schema = <String, dynamic>{
        'title': 'User',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(generateHelpers: false),
      );
      final generated = generator.generate(schema);

      // Should not contain helper functions
      expect(generated, isNot(contains('userFromJson')));
      expect(generated, isNot(contains('userToJson')));
    });

    test('uses correct function names for different class names', () {
      const schema = <String, dynamic>{
        'title': 'GitHubRepository',
        'type': 'object',
        'properties': {
          'name': {'type': 'string'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(generateHelpers: true),
      );
      final generated = generator.generate(schema);

      // Should use camelCase for function names
      expect(
        generated,
        contains('GitHubRepository gitHubRepositoryFromJson(String str)'),
      );
      expect(
        generated,
        contains('String gitHubRepositoryToJson(GitHubRepository data)'),
      );
    });

    test('handles acronyms correctly in function names', () {
      const schema = <String, dynamic>{
        'title': 'HTTPSConfig',
        'type': 'object',
        'properties': {
          'enabled': {'type': 'boolean'},
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(generateHelpers: true),
      );
      final generated = generator.generate(schema);

      // Class names get normalized to PascalCase (HTTPSConfig -> Httpsconfig)
      expect(
        generated,
        contains('Httpsconfig httpsconfigFromJson(String str)'),
      );
      expect(generated, contains('String httpsconfigToJson(Httpsconfig data)'));
    });
  });
}
