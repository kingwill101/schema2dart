import 'dart:io';

import 'package:schema2dart/schema2dart.dart';
import 'package:test/test.dart';

// Regression tests for bugs found generating the Codex app-server protocol:
//
//  1. Refs to unions with primitive variants (e.g. `RequestId` = string | int)
//     were deserialized as `X.fromJson((json['k'] as Map).cast<...>())`,
//     which throws at runtime for primitive wire values. The raw value must
//     be passed instead.
//
//  2. Property keys containing `$` (e.g. `$schema`) were emitted as Dart
//     interpolated literals (`'$schema'`), which reference the local variable
//     being declared. Keys must be escaped (or raw) in generated literals.
void main() {
  group('primitive-union refs at call sites', () {
    test('passes the raw wire value instead of casting to a Map', () {
      final schema = {
        r'$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'id': {r'$ref': '#/definitions/RequestId'},
          'name': {'type': 'string'},
        },
        'required': ['id'],
        'definitions': {
          'RequestId': {
            'title': 'RequestId',
            'anyOf': [
              {'type': 'string'},
              {'type': 'integer'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(rootClassName: 'Request'),
      );
      final code = generator.generate(schema);

      expect(
        code,
        contains("final id = RequestId.fromJson(json['id']);"),
      );
      expect(
        code,
        isNot(contains("RequestId.fromJson((json['id'] as Map)")),
      );
    });

    test('compiles and round-trips an int RequestId at runtime', () {
      final schema = {
        r'$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          'id': {r'$ref': '#/definitions/RequestId'},
        },
        'required': ['id'],
        'definitions': {
          'RequestId': {
            'title': 'RequestId',
            'anyOf': [
              {'type': 'string'},
              {'type': 'integer'},
            ],
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(rootClassName: 'Request'),
      );
      final code = generator.generate(schema);

      _compileAndRun(code, r'''
import 'generated.dart';
void main() {
  final request = Request.fromJson({'id': 123});
  if (request.id is RequestIdInt) {
    final back = request.toJson();
    if (back['id'] == 123) {
      print('OK int id round-trip');
    } else {
      print('FAIL: id serialized as ${back['id']}');
    }
  } else {
    print('FAIL: id was ${request.id.runtimeType}');
  }
}
''');
    });
  });

  group('dollar-prefixed JSON keys', () {
    test('escapes the dollar so literals are not interpolated', () {
      final schema = {
        r'$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          r'$schema': {'type': 'string'},
          'type': {'type': 'string'},
        },
        'required': [r'$schema'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(rootClassName: 'SchemaHolder'),
      );
      final code = generator.generate(schema);

      // The generated literal must be an escaped dollar, not an interpolated
      // `'$schema'` referencing the local being declared.
      expect(code, contains(r"json['\$schema']"));
      expect(
        code,
        isNot(contains("final schema = json['\$schema']")),
      );
      expect(code, contains(r"map['\$schema']"));
    });

    test(r'compiles and round-trips a $schema key at runtime', () {
      final schema = {
        r'$schema': 'https://json-schema.org/draft/2020-12/schema',
        'type': 'object',
        'properties': {
          r'$schema': {'type': 'string'},
          'type': {'type': 'string'},
        },
        'required': [r'$schema', 'type'],
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(rootClassName: 'SchemaHolder'),
      );
      final code = generator.generate(schema);

      _compileAndRun(code, r'''
import 'generated.dart';
void main() {
  final holder = SchemaHolder.fromJson({r'$schema': 'http://x', 'type': 'object'});
  if (holder.schema == 'http://x' && holder.type == 'object') {
    final back = holder.toJson();
    if (back[r'$schema'] == 'http://x') {
      print('OK dollar key round-trip');
    } else {
      print('FAIL: back[r\$schema] = ${back[r'$schema']}');
    }
  } else {
    print('FAIL: ${holder.schema} ${holder.type}');
  }
}
''');
    });
  });
}

void _compileAndRun(String generated, String harnessSource) {
  final dir = Directory.systemTemp.createTempSync('schema2dart_regression_');
  try {
    File('${dir.path}/generated.dart').writeAsStringSync(generated);
    File('${dir.path}/main.dart').writeAsStringSync(harnessSource);
    final run = Process.runSync(
      'dart',
      ['${dir.path}/main.dart'],
    );
    expect(
      run.exitCode,
      0,
      reason: 'stdout:\n${run.stdout}\nstderr:\n${run.stderr}',
    );
    expect(run.stdout, contains('OK'));
  } finally {
    dir.deleteSync(recursive: true);
  }
}
