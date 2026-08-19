import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  test('default values for primitives appear in constructors', () {
    const schema = {
      'type': 'object',
      'properties': {
        'flag': {'type': 'boolean', 'default': true},
        'items': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'name': {'type': 'string'},
              'done': {'type': 'boolean', 'default': false},
            },
            'required': ['name'],
          },
        },
      },
    };

    final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
    final output = generator.generate(schema);

    expect(
      output,
      contains(
        'const RootSchema({\n    this.flag = true,\n    this.items,\n  });',
      ),
    );
    expect(output, contains("final flag = (json['flag'] as bool?) ?? true;"));
    expect(
      output,
      contains(
        'const Item({\n    this.done = false,\n    required this.name,\n  });',
      ),
    );
    expect(output, contains("final done = (json['done'] as bool?) ?? false;"));
  });

  test('default values for arrays and objects', () {
    const schema = {
      'type': 'object',
      'properties': {
        'tags': {
          'type': 'array',
          'items': {'type': 'string'},
          'default': ['a', 'b', 'c'],
        },
        'config': {
          'type': 'object',
          'default': {'key': 'value', 'count': 42},
        },
        'name': {'type': 'string', 'default': 'default-name'},
      },
    };

    final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
    final output = generator.generate(schema);

    // Check array default in constructor
    expect(output, contains("this.tags = const ['a', 'b', 'c']"));

    // Check object default in constructor
    expect(
      output,
      contains("this.config = const {'key': 'value', 'count': 42}"),
    );

    // Check string default in constructor
    expect(output, contains("this.name = 'default-name'"));
  });

  test('default values for arrays of enums convert each element', () {
    const schema = {
      'type': 'object',
      'properties': {
        'modalities': {
          'type': 'array',
          'items': {
            'enum': ['text', 'image', 'audio'],
          },
          'default': ['text', 'image'],
        },
      },
    };

    final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
    final output = generator.generate(schema);

    // Each element must be emitted through the enum type, not as a raw string
    // literal (a raw `const ['text', 'image']` would not type-check against a
    // `List<Modality>` field).
    // Each element emits its const enum form (a `.fromJson(...)` call would
    // not be a constant, and raw strings would not type-check against
    // `List<Modality>`).
    expect(
      output,
      contains('this.modalities = const [Modality.text, Modality.image],'),
    );
    expect(
      output,
      contains(
        'final modalities = (json[\'modalities\'] == null ? null : '
        "(json['modalities'] as List).map((e) => ModalityJson.fromJson(e as String)).toList()) ?? "
        'const [Modality.text, Modality.image];',
      ),
    );
  });

  test('defaults referencing union-internal enums are dropped safely', () {
    // The union's enum variant types live in a separate file; a default like
    // `[InputModalityValue(InputModalityString.text)]` would reference types
    // not imported into this file. The generator must drop such defaults
    // (field stays nullable) rather than emit uncompilable Dart.
    const schema = {
      'type': 'object',
      'properties': {
        'modalities': {
          'type': 'array',
          'items': {
            'oneOf': [
              {
                'enum': ['text', 'image'],
              },
              {
                'enum': ['audio', 'video'],
              },
            ],
          },
          'default': ['text', 'image'],
        },
      },
    };

    final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
    final output = generator.generate(schema);

    // No constructor default, no fromJson fallback — the field stays nullable
    // but the generated code compiles.
    expect(output, contains('final List<Modality>? modalities;'));
    expect(output, isNot(contains('this.modalities = ')));
    expect(
      output,
      contains(
        "final modalities = json['modalities'] == null ? null : "
        "(json['modalities'] as List).map((e) => Modality.fromJson(e)).toList();",
      ),
    );
  });
}
