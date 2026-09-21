import 'dart:io';

import 'package:schema2dart/schema2dart.dart';
import 'package:test/test.dart';

Map<String, dynamic> _sourceSchema(String keyword, {bool constTags = false}) => {
  'title': 'Input',
  'oneOf': [
    {
      'title': 'ImageInput',
      'type': 'object',
      'properties': {
        'type': {
          'type': 'string',
          if (constTags) 'const': 'image' else 'enum': ['image'],
        },
        'detail': {'type': 'string'},
      },
      'required': ['type'],
      keyword: [
        {
          'title': 'UrlInput',
          'type': 'object',
          'properties': {
            'url': {'type': 'string'},
          },
          'required': ['url'],
        },
        {
          'title': 'FileInput',
          'type': 'object',
          'properties': {
            'fileId': {'type': 'string'},
          },
          'required': ['fileId'],
        },
      ],
    },
    for (final kind in ['audio', 'localImage', 'localAudio'])
      {
        'title': '${kind}Input',
        'type': 'object',
        'properties': {
          'type': {
            'type': 'string',
            if (constTags) 'const': kind else 'enum': [kind],
          },
          (kind == 'audio' ? 'url' : 'path'): {'type': 'string'},
        },
        'required': ['type', kind == 'audio' ? 'url' : 'path'],
      },
  ],
};

void main() {
  for (final constTags in [false, true]) {
  test('nested anyOf keeps discriminator dispatch and overlapping sources (const: $constTags)', () {
    _run(_sourceSchema('anyOf', constTags: constTags), r'''
import 'dart:convert';
import 'generated.dart';
void main() {
  for (final json in <Map<String, dynamic>>[
    {'type': 'image', 'detail': 'high', 'url': 'https://example.test/image'},
    {'type': 'image', 'fileId': 'file-1'},
    {'type': 'image', 'detail': 'high', 'url': 'image', 'fileId': 'file-1'},
    {'type': 'audio', 'url': 'audio'},
    {'type': 'localImage', 'path': '/image'},
    {'type': 'localAudio', 'path': '/audio'},
  ]) {
    final decoded = Input.fromJson(json);
    final actual = decoded.toJson() as Map;
    if (actual.length != json.length || json.entries.any((entry) =>
        jsonEncode(actual[entry.key]) != jsonEncode(entry.value))) {
      throw StateError('Lost fields: $json -> $actual');
    }
  }
  try {
    Input.fromJson({'type': 'image'});
  } catch (_) {
    print('OK');
    return;
  }
  throw StateError('Accepted an image with no source');
}
''');
  });

  test('nested oneOf still rejects overlapping object branches (const: $constTags)', () {
    _run(_sourceSchema('oneOf', constTags: constTags), r'''
import 'generated.dart';
void main() {
  final image = Input.fromJson({'type': 'image', 'url': 'image'});
  if (image.toJson()['url'] != 'image') throw StateError('Lost image source');
  try {
    Input.fromJson({'type': 'image', 'url': 'image', 'fileId': 'file-1'});
  } catch (_) {
    print('OK');
    return;
  }
  throw StateError('Accepted ambiguous oneOf');
}
''');
  });

  }
  test('nullable references retain the named union identity', () {
    _run(
      {
        'title': 'Request',
        'type': 'object',
        'properties': {
          'policy': {
            'anyOf': [
              {r'$ref': '#/definitions/Policy'},
              {'type': 'null'},
            ],
          },
        },
        'definitions': {
          'Policy': {
            'oneOf': [
              for (final kind in ['read', 'write'])
                {
                  'title': '${kind}Policy',
                  'type': 'object',
                  'properties': {
                    'type': {
                      'type': 'string',
                      'enum': [kind],
                    },
                  },
                  'required': ['type'],
                },
            ],
          },
        },
      },
      r'''
import 'generated.dart';
void main() {
  final Policy policy = Policy.fromJson({'type': 'read'});
  final request = Request(policy: policy);
  final Policy? decoded = Request.fromJson(request.toJson()).policy;
  if (decoded?.toJson()['type'] != 'read') throw StateError('Lost policy');
  print('OK');
}
''',
    );
  });

  test('annotated allOf references keep union types and decoded defaults', () {
    _run(
      {
        'title': 'Holder',
        'type': 'object',
        'properties': {
          'view': {
            'allOf': [
              {r'$ref': '#/definitions/View'},
            ],
            'default': 'full',
            'description': 'Amount of detail.',
          },
          'views': {
            'type': 'array',
            'items': {r'$ref': '#/definitions/View'},
            'default': ['summary'],
          },
        },
        'definitions': {
          'View': {
            'oneOf': [
              {
                'type': 'string',
                'enum': ['notLoaded'],
              },
              {
                'type': 'string',
                'enum': ['summary'],
              },
              {
                'type': 'string',
                'enum': ['full'],
              },
            ],
          },
        },
      },
      r'''
import 'generated.dart';
void main() {
  for (final value in ['notLoaded', 'summary', 'full']) {
    final View view = View.fromJson(value);
    final holder = Holder(view: view);
    if (holder.toJson()['view'] != value) throw StateError('Untyped serialization');
    final View? decoded = Holder.fromJson({'view': value}).view;
    if (decoded?.toJson() != value) throw StateError('Untyped decoding');
  }
  final View? defaultView = Holder.fromJson({}).view;
  if (defaultView?.toJson() != 'full') throw StateError('Missing typed default');
  final views = Holder.fromJson({}).views;
  if (views?.single.toJson() != 'summary') throw StateError('Missing list default');
  print('OK');
}
''',
    );
  });
}

void _run(Map<String, dynamic> schema, String harness) {
  final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
  final directory = Directory.systemTemp.createTempSync('schema_union_');
  try {
    final plan = generator.planMultiFile(
      generator.buildIr(schema),
      baseName: 'generated',
    );
    Directory(
      '${directory.path}/${plan.partsDirectory}',
    ).createSync(recursive: true);
    File('${directory.path}/generated.dart').writeAsStringSync(plan.barrel);
    for (final entry in plan.files.entries) {
      File(
        '${directory.path}/${plan.partsDirectory}/${entry.key}',
      ).writeAsStringSync(entry.value);
    }
    File('${directory.path}/main.dart').writeAsStringSync(harness);
    final result = Process.runSync(Platform.resolvedExecutable, [
      '${directory.path}/main.dart',
    ]);
    expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    expect(result.stdout, contains('OK'));
  } finally {
    directory.deleteSync(recursive: true);
  }
}
